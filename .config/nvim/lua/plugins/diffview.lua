return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewFileHistory",
	},
	keys = {
		{
			"<leader>gd",
			function()
				local lib = require("diffview.lib")
				if lib.get_current_view() then
					vim.cmd("DiffviewClose")
				else
					vim.cmd("DiffviewOpen")
				end
			end,
			desc = "Diff view toggle",
		},
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diff view: file history" },
	},
	opts = {
		enhanced_diff_hl = true,
		view = {
			merge_tool = {
				layout = "diff3_horizontal",
			},
		},
		file_panel = {
			listing_style = "tree",
			win_config = {
				width = 35,
			},
		},
	},
}
