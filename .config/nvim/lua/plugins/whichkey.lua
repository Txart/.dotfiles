-- return { -- Useful plugin to show you pending keybinds.
-- 	"folke/which-key.nvim",
-- 	event = "VimEnter", -- Sets the loading event to 'VimEnter'
-- 	config = function() -- This is the function that runs, AFTER loading
-- 		require("which-key").setup()
--
-- 		-- Document existing key chains
-- 		require("which-key").register({
-- 			["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
-- 			["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
-- 			["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
-- 			["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
-- 			["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
-- 			["<leader>t"] = { name = "[T]ests", _ = "which_key_ignore" },
-- 		})
-- 	end,
-- }

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		spec = {

			{ "<leader>c", group = "[C]ode" },
			{ "<leader>c_", hidden = true },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>d_", hidden = true },
			{ "<leader>f", group = "[F]ind" },
			{ "<leader>f_", hidden = true },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>r_", hidden = true },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>s_", hidden = true },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>w_", hidden = true },
			{ "<leader>g", group = "[G]it" },
			{ "<leader>w_", hidden = true },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
