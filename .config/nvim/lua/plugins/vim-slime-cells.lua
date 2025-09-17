return {
	"klafyvel/vim-slime-cells",
	requires = { { "jpalardy/vim-slime", opt = true } },
	config = function()
		-- Set cell delimiters based on file type
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "python",
			callback = function()
				vim.g.slime_cell_delimiter = "^\\s*# %%"
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "rust",
			callback = function()
				vim.g.slime_cell_delimiter = "^\\s*//%%"
			end,
		})
		-- Key mappings
		vim.api.nvim_set_keymap("n", "<leader>cv", "<Plug>SlimeConfig", {})
		vim.api.nvim_set_keymap("n", "<leader>cc", "<Plug>SlimeCellsSend", {})
		vim.api.nvim_set_keymap("n", "<leader>cj", "<Plug>SlimeCellsNext", {})
		vim.api.nvim_set_keymap("n", "<leader>ck", "<Plug>SlimeCellsPrev", {})
	end,
}
