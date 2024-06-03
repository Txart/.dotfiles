return {
	"jpalardy/vim-slime",
	config = function()
		vim.g.slime_target = "tmux"
		vim.g.slime_bracketed_paste = 1
		vim.g.slime_default_config = {
			socket_name = "default",
			target_pane = "{last}",
		}

		vim.g.slime_config_defaults = { python_ipython = 1, dispatch_ipython_pause = 100 }
		vim.g.slime_debug = 0
		vim.g.slime_preserve_curpos = 1
		function _EscapeText_python(text)
			local function resolve(key)
				return vim.g.slime_config_defaults[key]
			end

			local function split(input, sep)
				if sep == nil then
					sep = "%s"
				end
				local t = {}
				for str in string.gmatch(input, "([^" .. sep .. "]+)") do
					table.insert(t, str)
				end
				return t
			end

			if resolve("python_ipython") == 1 and #split(text, "\n") > 1 then
				return { "%cpaste -q\n", resolve("dispatch_ipython_pause"), text, "--\n" }
			else
				local empty_lines_pat = "^\n%s*\n+"
				local no_empty_lines = text:gsub(empty_lines_pat, "")
				local dedent_pat = "^\n" .. no_empty_lines:match("^%s*")
				local dedented_lines = no_empty_lines:gsub(dedent_pat, "")
				local except_pat = "(elif|else|except|finally)@!"
				local add_eol_pat = "\n%s[^%s]\n" .. except_pat .. "S$"
				return dedented_lines:gsub(add_eol_pat, "\n")
			end
		end

		vim.cmd([[
                function! _EscapeText_python(text)
                    return luaeval('_EscapeText_python(_A)', a:text)
                endfunction
            ]])
	end,
}
