return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	-- load on new tab open
	keys = {
		{ "<leader>to", "<cmd>tabnew<CR>", desc = "Open new tab" },
	},
	opts = {
		-- colors
		highlights = {
			background = {
				bg = "#1e1e2e",
				fg = "#cdd6f4",
			},
			fill = {
				bg = "#1e1e2e",
				fg = "#1e1e2e",
			},
			tab = {
				bg = "#1e1e2e",
				fg = "#1e1e2e",
			},
			tab_selected = {
				fg = "#cdd6f4",
				bg = "#cdd6f4",
			},
			tab_separator = {
				fg = "#a6e3a1",
				bg = "#a6e3a1",
			},
			tab_separator_selected = {
				fg = "#a6e3a1",
				bg = "#a6e3a1",
				sp = "#a6e3a1",
			},
			tab_close = {
				fg = "#cdd6f4",
				bg = "#1e1e2e",
			},
			close_button = {
				fg = "#cdd6f4",
				bg = "#1e1e2e",
			},
		},
		options = {
			mode = "tabs",
			buffer_close_icon = "󰅖",
			modified_icon = "●",
			close_icon = "",
			left_trunc_marker = "",
			right_trunc_marker = "",
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "center",
					separator = true,
				},
			},
			color_icons = true,
		},
	},
}
