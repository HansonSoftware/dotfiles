return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},

	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- setup diagnostics
		vim.diagnostic.config({
			signs = {
				-- Set the sign text per severity
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN]  = " ",
					[vim.diagnostic.severity.HINT]  = " ",
					[vim.diagnostic.severity.INFO]  = " ",
				},
				-- (Optional) If you want number column highlights per severity
				-- Use the default DiagnosticSign* highlight groups or your own
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
					[vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
				},
				-- (Optional) If you want to highlight the entire line for diagnostics
				-- linehl = {
				--   [vim.diagnostic.severity.ERROR] = "DiagnosticLineError",
				--   [vim.diagnostic.severity.WARN]  = "DiagnosticLineWarn",
				--   [vim.diagnostic.severity.HINT]  = "DiagnosticLineHint",
				--   [vim.diagnostic.severity.INFO]  = "DiagnosticLineInfo",
				-- },
			},
		})

		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>lr", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- lua ls
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			filetypes = { "lua" },
		})

		vim.lsp.enable("lua_ls")

		-- roslyn
		-- vim.lsp.config("roslyn", {
		-- 	capabilities = capabilities,
		-- 	filetypes = { "cs" },
		-- })
		--
		-- vim.lsp.enable("roslyn")
	end,
}
