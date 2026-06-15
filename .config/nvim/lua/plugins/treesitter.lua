return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	main = "nvim-treesitter",
	init = function()
		-- Install parsers that aren't already present
		local ensure_installed = {
			"bash",
			"c",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"vim",
			"vimdoc",
			"json",
			"python",
			"rust",
			"julia",
		}
		local already_installed = require("nvim-treesitter.config").get_installed()
		local to_install = vim.iter(ensure_installed)
			:filter(function(p)
				return not vim.tbl_contains(already_installed, p)
			end)
			:totable()
		if #to_install > 0 then
			require("nvim-treesitter").install(to_install)
		end

		-- Enable highlighting + indentation per filetype
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(ev)
				local ft = ev.match
				if vim.tbl_contains({ "latex", "tex" }, ft) then
					return
				end
				pcall(vim.treesitter.start)
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
