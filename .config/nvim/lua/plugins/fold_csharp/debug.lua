local M = {}

-- Namespaces for extmarks
M.ns_virtual = vim.api.nvim_create_namespace("myfold_debug_virtual")

--------------------------------------------------------
-- VIRTUAL TEXT
--------------------------------------------------------
function M.show_virtual_text(bufnr, lnum, text)
  vim.api.nvim_buf_set_extmark(bufnr, M.ns_virtual, lnum - 1, -1, {
    id = lnum,                          -- reuse same id per line
    virt_text = { { text, "Search" } }, -- CursorLineNr
    virt_text_pos = "eol",
  })
end

--------------------------------------------------------
-- SIGN COLUMN
--------------------------------------------------------

M.sign_group = "myfold_debug_group"

---@enum sign
M.sign = {
  star = "star",
  foldstart = "foldstart",
  foldend = "foldend",
}

---@type {[sign]: string}
local sign_values = {
  star = "-",
  foldstart = ">",
  foldend = "<",
}

for key, value in pairs(sign_values) do
  vim.fn.sign_define(key, { text = value, texthl = "Search" })
end

---@param sign_name sign
function M.place_sign(bufnr, lnum, sign_name)
  vim.fn.sign_place(
    lnum,         -- id (use lnum for uniqueness)
    M.sign_group, -- group
    sign_name,    -- sign type
    bufnr,
    { lnum = lnum, priority = 10 }
  )
end

--------------------------------------------------------
-- CLEAR
--------------------------------------------------------
function M.clear(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, M.ns_virtual, 0, -1)
  vim.fn.sign_unplace(M.sign_group, { buffer = bufnr })
end

return M
