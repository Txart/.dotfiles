return {
	{
		"williamboman/mason.nvim",
		config = true,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"lua-language-server",
				"rust-analyzer",
				"taplo",
				"zls",
				"ruff",
				"ty",
				"prettier",
				"stylua",
			},
		},
	},
}
