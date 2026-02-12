return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("refactoring").setup({})

		vim.keymap.set("x", "<leader>rf", ":Refactor extract ")
		vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
	end,
}
