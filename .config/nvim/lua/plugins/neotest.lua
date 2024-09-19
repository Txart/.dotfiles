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
			':lua require("neotest").run.run(vim.fn.getcwd())<CR>',
			desc = "Run all project tests with neotest",
		},
		{
			"<leader>tf",
			':lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
			desc = "Run current tests file with neotest",
		},
		{ "<leader>ts", ":Neotest summary<CR>", desc = "Show test summary" },
		{ "<leader>to", ":Neotest output<CR>", desc = "Show test output pane" },
		{
			"[t",
			':lua require("neotest").jump.prev({ status = "failed" })<CR>',
			desc = "Jump to previous failing test",
		},
		{
			"]t",
			':lua require("neotest").jump.next({ status = "failed" })<CR>',
			desc = "Jump to next failing test",
		},
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
