return {
	"hanschen/vim-ipython-cell",
	config = function()
		vim.g.slime_cell_delimiter = "# %%"
		vim.keymap.set("n", "<S-CR>", "<Plug>SlimeSendCell")

		-- Map N to navigate to the next cell in normal mode
		-- vim.api.nvim_set_keymap("n", "N", ":IPythonCellNextCell<CR>", { noremap = true, silent = true })

		-- Map P to navigate to the previous cell in normal mode
		-- vim.api.nvim_set_keymap("n", "P", ":IPythonCellPrevCell<CR>", { noremap = true, silent = true })
	end,
}
