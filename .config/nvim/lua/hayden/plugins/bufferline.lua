return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	-- load on new tab open
	keys = {
		{ "<leader>to", "<cmd>tabnew<CR>", desc = "Open new tab" },
	},
	opts = {
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
