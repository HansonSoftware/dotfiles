return {
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	dependencies = {
		{ "folke/ts-comments.nvim", opts = {} },
	},

	branch = "main",
	build = function()
		-- update parsers, if TSUpdate exists
		if vim.fn.exists(":TSUpdate") == 2 then
			vim.cmd("TSUpdate")
		end
	end,

	-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
	---@module 'nvim-treesitter'
	---@type TSConfig
	---@diagnostic disable-next-line: missing-fields

	config = function(_, _)
		local ensure_installed = {
			"bash",
			"c",
			"css",
			"c_sharp",
			"diff",
			"gitcommit",
			"html",
			"javascript",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
		}

		-- make sure nvim-treesitter can load
		local ok, nvim_treesitter = pcall(require, "nvim-treesitter")

		-- no nvim-treesitter, maybe fresh install
		if not ok then
			return
		end

		-- no longer need to override but keeping here as a reference
		-- vim.api.nvim_create_autocmd('User', {
		--   pattern = 'TSUpdate',
		--   callback = function()
		--     local tmux_parser = require('nvim-treesitter.parsers')['tmux']
		--     tmux_parser.install_info = {
		--       url = 'https://github.com/Freed-Wu/tree-sitter-tmux',
		--       branch = 'all-fixes',
		--       revision = '7b63f7399c8756316ed46fdfa0cc3971572a249e',
		--     }
		--   end,
		-- })
		--
		-- vim.api.nvim_create_autocmd('User', {
		--   pattern = 'TSUpdate',
		--   callback = function()
		--     local tmux_parser = require('nvim-treesitter.parsers')['tmux']
		--     ---@diagnostic disable-next-line: missing-fields
		--     tmux_parser.install_info = {
		--       path = '~/dev/neovim-dev/tree-sitter-tmux/',
		--       generate = true,
		--       generate_from_json = false,
		--     }
		--   end,
		-- })

		nvim_treesitter.install(ensure_installed)
	end,
}
