return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod
		local trouble = require("trouble")
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				mappings              = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
					},
				},

				dynamic_preview_title = false,

				path_display          = { "tail" },

				layout_strategy       = "vertical",

				border                = true,

				layout_config         = {
					height = .99,
					width = .80,
					prompt_position = "bottom",
					preview_cutoff = 0,
					vertical = {
						mirror = false,
						preview_height = 0.55,
						results_height = 0.45,
					},
				},

			},

			pickers = {
				oldfiles = {
					prompt_title = "Recent Files",
					results_title = "Recent Files",
					preview_title = "Preview",
				},
				live_grep = {
					prompt_title = "Grep",
					results_title = "Matches",
					preview_title = "Grep Results",
				},
				find_files = {
					prompt_title = "Find Files",
					results_title = "Files",
					preview_title = "Preview",
				},
				buffers = {
					prompt_title = "Buffers",
					results_title = "Open Buffers",
					preview_title = "Preview",
				},
			},
		})

		telescope.load_extension("fzf")

		local builtin = require("telescope.builtin")

		local keymap = vim.keymap

		keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
		keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
		keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp docs" })
		keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles in cwd" })
		keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent files" })
		keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "[F]ind [W]ord in cwd" })
		keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "[F]ind [S]tring under cursor in cwd" })

		keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				previewer = false,
			}))
		end)

		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "[F]ind [T]odo comments" })
	end,
}
