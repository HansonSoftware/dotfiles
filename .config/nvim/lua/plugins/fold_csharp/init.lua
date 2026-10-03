return {
  name = "fold_csharp",
  enabled = false,
  dir = vim.fn.stdpath("config") .. "/lua/plugins/fold_csharp",
  config = function()
    local name = "plugins.fold_csharp"
    local group_name = vim.api.nvim_create_augroup('fold_csharp', { clear = true })
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      group = group_name,
      pattern = { "*.cs", "*.razor", "*.cshtml" },
      callback = function()
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr   = "v:lua.require('" .. name .. ".logic').foldexpr()"
      end,
    })
  end,
}

-- local M = {}
-- local Debug = require("myfold.debug")
-- local Fold = require("myfold.foldexpr")
--
-- function M.restart() -- {{{
--   local pattern = "~/development/personal/dotfiles/stow_this/.config/nvim/lua/myfold/*.lua"
--   local files = vim.fn.glob(pattern, false, true)
--   for _, f in ipairs(files) do
--     vim.cmd("luafile " .. vim.fn.fnameescape(f))
--   end
--
--   package.loaded["myfold.debug"] = nil
--   package.loaded["myfold.foldexpr"] = nil
--   package.loaded["myfold"] = nil
-- end
--
-- local group_name = "myfold.testing"
-- vim.api.nvim_create_augroup(group_name, {})
-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--   group = group_name,
--   pattern = "/Users/davidroberson/development/personal/dotfiles/stow_this/.config/nvim/lua/myfold/*",
--   callback = function()
--     vim.notify("bufwritepost")
--     M.restart()
--   end,
-- })
--
-- -- }}}
--
-- ---@diagnostic disable-next-line: unused-local, unused-function
-- local winnr_test_folding = function()
--   for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
--     local win_buf = vim.api.nvim_win_get_buf(win)
--     local win_buf_path = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(win_buf))
--     if win_buf_path ~= nil and win_buf_path:match("test_fold.cs") then
--       return win
--     end
--   end
--
--   return 0
-- end
--
-- ---@diagnostic disable-next-line: unused-local, unused-function
-- local bufnr_test_folding = function()
--   for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
--     local win_buf = vim.api.nvim_win_get_buf(win)
--     local win_buf_path = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(win_buf))
--     if win_buf_path ~= nil and win_buf_path:match("test_fold.cs") then
--       return win_buf
--     end
--   end
--
--   return vim.fn.bufnr("%")
-- end
--
-- local ns_id = vim.api.nvim_create_namespace("debug")
-- local clear = function()
--   local bufnr = bufnr_test_folding()
--   require("utils").clear_virtual_text(bufnr, ns_id)
--   Debug.clear(bufnr)
-- end
--
-- local draw_on_line = function(callback)
--   local bufnr = bufnr_test_folding()
--   local text
--   for lnum = 1, vim.api.nvim_buf_line_count(bufnr), 1 do
--     text = callback(lnum)
--     if text ~= nil and text ~= "=" then
--       Debug.place_sign(bufnr, lnum, "star")
--       Debug.show_virtual_text(bufnr, lnum, text or "ERROR")
--     end
--   end
-- end
--
-- vim.keymap.set("n", "<leader>a", function() -- {{{
--   clear()
--
--   draw_on_line(function(lnum)
--     local bufnr = bufnr_test_folding()
--     return Fold.logic(lnum, bufnr)
--   end)
--
--   local winnr = winnr_test_folding()
--   vim.wo[winnr].foldexpr = "v:lua.require('myfold.foldexpr').foldexpr()"
--   -- vim.wo[winnr].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
--
--   -- vim.wo.foldmethod     = "expr"
--   -- vim.wo.foldexpr = "v:lua.require('myfold.foldexpr').foldexpr()"
--   -- vim.wo.foldlevelstart = 99
--
--   -- local query = vim.treesitter.query.parse("c_sharp", [[
--   --   ; query
--   --   ((method_declaration) @str)
--   -- ]])
--   -- local tree = vim.treesitter.get_parser():parse()[1]
--   -- for id, node, metadata in query:iter_captures(tree:root(), 0) do
--   --   -- Print the node name and source text.
--   --   -- vim.print({ node:type(), vim.treesitter.get_node_text(node, vim.api.nvim_get_current_buf()) })
--   --   -- P({node:type(), node:start(), type(node:start())})
--   --   local lnum = node:start() + 1
--   --   Debug.place_sign(lnum, "star")
--   --   Debug.show_virtual_text(lnum, tostring(lnum))
--   -- end
-- end)                                        -- }}}
--
-- vim.keymap.set("n", "<leader>s", function() -- {{{
--   M.restart()
--   clear()
-- end)               -- }}}
--
-- function M.setup() -- {{{
--   vim.notify("setup")
-- end                -- }}}
--
-- return M
