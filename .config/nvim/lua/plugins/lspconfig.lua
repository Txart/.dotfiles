return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-tool-installer.nvim",
		"j-hui/fidget.nvim",
		"folke/neodev.nvim",
	},

	config = function()
		require("fidget").setup({})
		require("neodev").setup()

		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		---------------------------------
		-- LSP Attach
		---------------------------------

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
				end

				map("gd", vim.lsp.buf.definition, "Goto Definition")
				map("gr", vim.lsp.buf.references, "Goto References")
				map("K", vim.lsp.buf.hover, "Hover")
				map("<leader>rn", vim.lsp.buf.rename, "Rename")
				map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
			end,
		})

		---------------------------------
		-- LSP Servers
		---------------------------------

		local util = require("lspconfig.util")

		vim.lsp.config("ty", {
			settings = {
				ty = {
					-- ty language server settings go here
				},
			},
		})

		vim.lsp.config("ruff", {
			capabilities = capabilities,
			init_options = {
				settings = {
					format = { enable = true },
					lint = { run = "onSave" },
				},
			},
		})

		vim.lsp.config("rust_analyzer", {
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					cargo = { allTargets = false },
					check = { command = "clippy" },
				},
			},
		})

		vim.lsp.config("taplo", { capabilities = capabilities })
		vim.lsp.config("zls", { capabilities = capabilities })
		vim.lsp.config("cssls", { capabilities = capabilities })
		vim.lsp.config("html", { capabilities = capabilities })

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					completion = { callSnippet = "Replace" },
				},
			},
		})

		---------------------------------
		-- Enable servers
		---------------------------------

		vim.lsp.enable({
			"lua_ls",
			"rust_analyzer",
			"taplo",
			"zls",
			"cssls",
			"html",
			"ruff",
			"ty",
		})
	end,
}
