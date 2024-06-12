return {
	"klafyvel/vim-slime-cells",
	requires = { { "jpalardy/vim-slime", opt = true } },
	config = function()
		-- Key mappings
		vim.api.nvim_set_keymap("n", "<leader>cv", "<Plug>SlimeConfig", {})
		vim.api.nvim_set_keymap("n", "<leader>cc", "<Plug>SlimeCellsSend", {})
		vim.api.nvim_set_keymap("n", "<leader>cj", "<Plug>SlimeCellsNext", {})
		vim.api.nvim_set_keymap("n", "<leader>ck", "<Plug>SlimeCellsPrev", {})
	end,
}
