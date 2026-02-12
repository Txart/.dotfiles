return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("refactoring").setup({})

		vim.keymap.set("x", "<leader>re", ":Refactor extract to function")
		vim.keymap.set("x", "<leader>re", ":Refactor extract to variable")
	end,
}
