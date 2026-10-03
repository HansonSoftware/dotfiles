-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- start treesitter
vim.api.nvim_create_autocmd({ "Filetype" }, {
  callback = function(event)
    -- make sure nvim-treesitter is loaded
    local ok, nvim_treesitter = pcall(require, "nvim-treesitter")

    -- no nvim-treesitter, maybe fresh install
    if not ok then
      return
    end

    local parsers = require("nvim-treesitter.parsers")

    if not parsers[event.match] or not nvim_treesitter.install then
      return
    end

    local ft = vim.bo[event.buf].ft
    local lang = vim.treesitter.language.get_lang(ft)
    nvim_treesitter.install({ lang }):await(function(err)
      if err then
        vim.notify("Treesitter install error for ft: " .. ft .. " err: " .. err)
        return
      end

      pcall(vim.treesitter.start, event.buf)
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end)
  end,
})

-- lsp progress notifier
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    local value = ev.data.params.value
    if type(value) ~= "table" then return end

    -- Format the message from Roslyn or any other LSP
    local msg = value.message or value.title or ""
    local percentage = value.percentage and string.format(" (%d%%)", value.percentage) or ""

    vim.notify(msg .. percentage, "info", {
      id = "lsp_progress_" .. client.id,
      title = client.name,
      icon = value.kind == "end" and " " or "󰚰 ",
      timeout = value.kind == "end" and 3000 or false, -- Keeps it visible while loading, dismisses when done
    })
  end,
})
