return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
	},

	keys = {
		{
			"<leader>tt",
			':lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
			desc = "Run current tests file with neotest",
		},
		{
			"<leader>tp",
			':lua require("neotest").run.run(vim.fn.getcwd())<CR>',
			desc = "Run tests in project with neotest",
		},
		{ "<leader>ts", ":Neotest summary<CR>", desc = "Show test summary" },
		{ "<leader>to", ":Neotest output<CR>", desc = "Show test output pane" },
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					python = ".venv/bin/python",
				}),
			},
		})
	end,
}
