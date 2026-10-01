-- Runs every case in cases/: the text above the "--- becomes ---" line is
-- formatted with sembr and compared to the text below it.
--
--   nvim --headless -l tests/sembr/run.lua
local here = vim.fs.dirname(vim.fs.abspath(debug.getinfo(1, "S").source:sub(2)))
package.path = vim.fs.joinpath(here, "../../lua/?.lua;") .. package.path
local sembr = require("sembr")

local failed = 0
for _, file in ipairs(vim.fn.glob(vim.fs.joinpath(here, "cases/*.txt"), false, true)) do
	local name = vim.fs.basename(file)
	local input, expected = table.concat(vim.fn.readfile(file), "\n"):match("^(.-)\n%-%-%- becomes %-%-%-\n(.*)$")
	if not input then
		failed = failed + 1
		print("FAIL " .. name .. ": no '--- becomes ---' line")
	else
		local got = table.concat(sembr.format_lines(vim.split(input, "\n")), "\n")
		if got == expected then
			print("ok   " .. name)
		else
			failed = failed + 1
			print("FAIL " .. name .. "\n--- got ---\n" .. got .. "\n--- expected ---\n" .. expected .. "\n")
		end
	end
end
os.exit(failed == 0 and 0 or 1)
