return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("refactoring").setup()

		vim.keymap.set("v", "<leader>r", function()
			require("refactoring").refactor("Extract Function")
		end, { desc = "(R)efactor to function" })
	end,
}
