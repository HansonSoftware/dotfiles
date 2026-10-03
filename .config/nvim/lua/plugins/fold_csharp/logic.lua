local M = {}

---@alias FoldFlag integer -- {{{
---| 1 # FLAG_START — a node begins on this line
---| 2 # FLAG_END   — a node ends on this line
---| 3 # FLAG_START | FLAG_END (bitwise OR) — both start and end on same line -- }}}

--- Bit flags for line states
---@class FoldFlags -- {{{
---@field FLAG_START FoldFlag
---@field FLAG_END FoldFlag -- }}}

---@class FoldPerfState -- {{{
---@field changedtick integer             # Last buffer change tick when this cache was built
---@field map table<integer, FoldFlag>    # Line -> bitflags
---@field blank_lines table<integer, boolean>
---@field recompute_ns integer            # Total nanoseconds spent in recomputes
---@field recomputes integer              # How many full recomputes have been done
---@field line_calls integer              # How many times foldexpr was invoked
---@field line_ns integer                 # Total nanoseconds spent in foldexpr (logic path)
---@field attached? boolean               # Whether an on_lines handler is attached
local STATE ---@type table<integer, FoldPerfState> -- }}}
STATE = {}

-- Bit flags are faster and smaller than boolean tables
local FLAG_START, FLAG_END = 1, 2

-- Compiled once, reused
local LANG = "c_sharp"
local QUERY_RAW = [[
  (method_declaration
    body: (_) @member.method.body)
  (property_declaration
    accessors: (_) @member.property.body)
  (constructor_declaration
    body: (_) @member.constructor.body)
]]
local QUERY = nil

local compute_map = function(bufnr) -- {{{
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, LANG)
  if not ok or not parser then
    return {}
  end

  ---@diagnostic disable-next-line: undefined-field
  local t0 = vim.loop.hrtime()

  local tree = parser:parse()[1]
  if not tree then
    return {}
  end
  local root = tree:root()
  local map = {} ---@type table<integer, FoldFlag>

  if QUERY == nil then
    QUERY = vim.treesitter.query.parse(LANG, QUERY_RAW)
  end

  -- Iterate only once and set flags using bit ops, avoid table allocs in hot paths
  for _, node in QUERY:iter_captures(root, bufnr, 0, -1) do
    local sr, _, er, _ = node:range()
    local start_line   = sr + 1
    local end_line     = er + 1

    local f1           = map[start_line] or 0
    if bit.band(f1, FLAG_START) == 0 then
      map[start_line] = bit.bor(f1, FLAG_START)
    end

    local f2 = map[end_line] or 0
    if bit.band(f2, FLAG_END) == 0 then
      map[end_line] = bit.bor(f2, FLAG_END)
    end
  end

  ---@diagnostic disable-next-line: undefined-field
  local dt = vim.loop.hrtime() - t0

  -- Update perf stats
  local st = STATE[bufnr] or {}
  st.recompute_ns = (st.recompute_ns or 0) + dt
  st.recomputes = (st.recomputes or 0) + 1
  STATE[bufnr] = st

  return map
end                                         -- }}}

local compute_blank_lines = function(bufnr) -- {{{
  -- print("compute_blank_lines: " .. bufnr)
  local blank_lines = {} ---@type table<integer, boolean>
  for lnum, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)) do
    blank_lines[lnum] = string.match(line, [[^%s*$]])
  end
  return blank_lines
end                                  -- }}}

local ensure_state = function(bufnr) -- {{{
  local ct = vim.b[bufnr].changedtick or 0
  local st = STATE[bufnr]
  if not st or st.changedtick ~= ct then
    st = st or {}
    st.map = compute_map(bufnr)
    st.blank_lines = compute_blank_lines(bufnr)
    st.changedtick = ct
    STATE[bufnr] = st
  end
  return st
end -- }}}

---@enum FoldOut -- {{{
local fold = {
  ["start"]     = ">1",
  ["end"]       = "<1",
  ["no_change"] = "=",
} -- }}}

--- @param lnum integer
--- @param bufnr integer|nil
--- @return string
M.logic = function(lnum, bufnr) -- {{{
  bufnr             = bufnr or vim.api.nvim_get_current_buf()
  local st          = ensure_state(bufnr)

  ---@diagnostic disable-next-line: undefined-field
  local t0          = vim.loop.hrtime()
  local map         = st.map
  local blank_lines = st.blank_lines

  local prev        = map[lnum - 1] or 0
  local here        = map[lnum] or 0
  local next        = map[lnum + 1] or 0

  local prev_start  = bit.band(prev, FLAG_START) ~= 0
  local prev_end    = bit.band(prev, FLAG_END) ~= 0
  local is_start    = bit.band(here, FLAG_START) ~= 0
  local is_end      = bit.band(here, FLAG_END) ~= 0
  local is_blank    = blank_lines[lnum]
  local next_end    = bit.band(next, FLAG_END) ~= 0
  local next_start  = bit.band(next, FLAG_START) ~= 0
  local next_blank  = blank_lines[lnum + 1]

  -- local Debug        = require("plugins.fold_csharp.debug")
  -- local virtual_text = ""
  -- -- if prev_start then virtual_text = virtual_text.." " .. "prev_start" end
  -- if prev_end then virtual_text = virtual_text .. " " .. "prev_end" end
  -- if is_start then virtual_text = virtual_text .. " " .. "---> is_start" end
  -- if is_end then virtual_text = virtual_text .. " " .. "<--- is_end" end
  -- -- if next_end then virtual_text = virtual_text.." " .. "next_end" end
  -- if next_start then virtual_text = virtual_text .. " " .. "next_start" end
  -- if next_blank then virtual_text = virtual_text .. " " .. "next_blank" end
  -- if is_blank then virtual_text = "| " .. virtual_text end
  -- Debug.show_virtual_text(bufnr, lnum, virtual_text)

  local out
  if is_start and not is_end then
    out = fold["start"]
  elseif is_end and not next_blank then
    out = fold["end"]
  elseif prev_end and is_blank then
    out = fold["end"]
  else
    out = fold["no_change"]
  end

  st.line_calls = (st.line_calls or 0) + 1
  ---@diagnostic disable-next-line: undefined-field
  st.line_ns = (st.line_ns or 0) + (vim.loop.hrtime() - t0)
  return out
end                     -- }}}

M.foldexpr = function() -- {{{
  return M.logic(vim.v.lnum)
end                     -- }}}

-- Optional: attach to buffer to invalidate aggressively on edits (not required
-- if you rely on b:changedtick, but nice when third-party plugins tweak text)
M.attach = function(bufnr) -- {{{
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if STATE[bufnr] and STATE[bufnr].attached then
    return
  end

  STATE[bufnr] = STATE[bufnr] or {}
  local st = STATE[bufnr]
  vim.api.nvim_buf_attach(bufnr, false, {
    on_lines = function()
      -- Force recompute on next call (changedtick will also change; this is belt-and-suspenders)
      st.changedtick = -1
    end,
    on_detach = function()
      STATE[bufnr] = nil
    end,
  })
  st.attached = true
end                             -- }}}

M.perf_report = function(bufnr) -- {{{
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local st = STATE[bufnr]

  -- Auto-initialize if folding has been applied but no state exists yet
  if not st then
    st = ensure_state(bufnr)
    STATE[bufnr] = st
  end

  local rc = st.recomputes or 0
  local rn = (st.recompute_ns or 0) / 1e6
  local lc = st.line_calls or 0
  local ln = (st.line_ns or 0) / 1e6
  print(string.format(
    "folds: recomputes=%d (%.2f ms total, %.2f ms avg)  line_calls=%d (%.2f ms total, %.3f µs avg)",
    rc, rn, rc > 0 and (rn / rc) or 0, lc, ln, lc > 0 and (ln * 1000 / lc) or 0
  ))
end -- }}}

return M
