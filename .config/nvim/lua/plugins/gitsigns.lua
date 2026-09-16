return { -- Adds git related signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	},
	keys = {
		{ "<leader>gc", ":Gitsigns preview_hunk_inline<cr>", desc = "View git changes inline" },
		{
			"]g",
			function()
				require("gitsigns").nav_hunk("next")
			end,
			desc = "Next git hunk",
		},
		{
			"[g",
			function()
				require("gitsigns").nav_hunk("prev")
			end,
			desc = "Previous git hunk",
		},
	},
}
