return {
	"nvim-mini/mini.nvim",
	lazy = false,
	event = { "VimEnter" },
	version = false,
	config = function()
		-- require("mini.animate").setup({
		-- 	cursor = { enable = false },
		-- 	resize = { enable = false },
		-- 	open   = { enable = false },
		-- 	close  = { enable = false },
		-- 	scroll = {
		-- 		enable = true,
		-- 		timing = function() return 10 end
		-- 	},
		-- })
		require("mini.icons").setup()
		require("mini.files").setup({
			content = {
				-- Predicate for which file system entries to show
				filter = nil,
				-- Highlight group to use for a file system entry
				highlight = nil,
				-- Prefix text and highlight to show to the left of file system entry
				prefix = nil,
				-- Order in which to show file system entries
				sort = nil,
			},

			-- Module mappings created only inside explorer.
			-- Use `''` (empty string) to not create one.
			mappings = {
				close       = 'q',
				go_in       = 'l',
				go_in_plus  = 'L',
				go_out      = 'h',
				go_out_plus = 'H',
				mark_goto   = "'",
				mark_set    = 'm',
				reset       = '<BS>',
				reveal_cwd  = '@',
				show_help   = '?',
				synchronize = '=',
				trim_left   = '<',
				trim_right  = '>',
			},

			-- General options
			options = {
				-- Whether to delete permanently or move into module-specific trash
				permanent_delete = true,
				-- Whether to use for editing directories
				use_as_default_explorer = true,
			},

			-- Customization of explorer windows
			windows = {
				-- Maximum number of windows to show side by side
				max_number = math.huge,
				-- Whether to show preview of file/directory under cursor
				preview = true,
				-- Width of focused window
				width_focus = 50,
				-- Width of non-focused window
				width_nofocus = 15,
				-- Width of preview window
				width_preview = 50,
			},
		})

		local mf = require("mini.files")

		local function toggle_or_open(open_fn)
			if mf.close() then
				return
			end
			open_fn()
		end

		vim.keymap.set("n", "<leader>et", function()
			toggle_or_open(function()
				mf.open(nil, false)
			end)
		end, { desc = "[E]xplorer [T]oggle" })

		vim.keymap.set("n", "<leader>ef", function()
			toggle_or_open(function()
				mf.open(vim.api.nvim_buf_get_name(0), false)
			end)
		end, { desc = "[E]xplorer at [F]ile" })

		vim.keymap.set("n", "<leader>el", function()
			toggle_or_open(function()
				mf.open(mf.get_latest_path())
			end)
		end, { desc = "[E]xplorer at [L]ast location" })
	end,
}
