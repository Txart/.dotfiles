-- Function to Test Navigation for Neovim
-- Navigates from Python functions to their corresponding test functions

local M = {}

-- Helper function to get current function name using treesitter
local function get_current_function_name()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local ts = require("nvim-treesitter.parsers")

	-- Get parser for current buffer
	local parser = ts.get_parser(0, "python")
	if not parser then
		return nil
	end

	-- Get cursor position
	local cursor_node = ts_utils.get_node_at_cursor()
	if not cursor_node then
		return nil
	end

	-- Walk up the tree to find function definition
	local current_node = cursor_node
	while current_node do
		if current_node:type() == "function_definition" then
			-- Find the function name node
			for child in current_node:iter_children() do
				if child:type() == "identifier" then
					local name = vim.treesitter.get_node_text(child, 0)
					return name
				end
			end
		end
		current_node = current_node:parent()
	end

	return nil
end

-- Simple similarity scoring - just count common characters
local function similarity_score(test_func_name, target_function)
	local expected_name = "test_" .. target_function
	if test_func_name == expected_name then
		return 1.0 -- Exact match
	end

	-- Count common characters between test function and target
	local common = 0
	local target_lower = target_function:lower()
	local test_lower = test_func_name:lower()

	for char in target_lower:gmatch(".") do
		if test_lower:find(char, 1, true) then
			common = common + 1
		end
	end

	return common / #target_function
end

-- Helper function to find test files
local function find_test_files()
	local test_files = {}

	-- Common test file patterns
	local patterns = {
		"test_*.py",
		"*_test.py",
		"tests/**/*.py",
		"test/**/*.py",
		"tests.py",
	}

	for _, pattern in ipairs(patterns) do
		local files = vim.fn.glob(pattern, false, true)
		for _, file in ipairs(files) do
			table.insert(test_files, file)
		end

		-- Also search in common test directories
		local test_dirs = { "tests/", "test/", "testing/" }
		for _, dir in ipairs(test_dirs) do
			local dir_files = vim.fn.glob(dir .. pattern, false, true)
			for _, file in ipairs(dir_files) do
				table.insert(test_files, file)
			end
		end
	end

	-- Remove duplicates
	local unique_files = {}
	local seen = {}
	for _, file in ipairs(test_files) do
		if not seen[file] then
			seen[file] = true
			table.insert(unique_files, file)
		end
	end

	return unique_files
end

-- Helper function to search for test function in a file
local function find_test_function_in_file(filepath, target_function)
	local file = io.open(filepath, "r")
	if not file then
		return {}
	end

	local matches = {}
	local line_num = 1

	-- Read file line by line to get correct line numbers
	for line in file:lines() do
		local test_func_name = line:match("def%s+(test_[%w_]+)%s*%(")
		if test_func_name then
			local score = similarity_score(test_func_name, target_function)
			table.insert(matches, {
				file = filepath,
				line = line_num,
				function_name = test_func_name,
				score = score,
			})
		end
		line_num = line_num + 1
	end

	file:close()
	return matches
end

-- Main function to navigate to test
function M.navigate_to_test()
	-- Get current function name
	local func_name = get_current_function_name()
	if not func_name then
		vim.notify("No function found at cursor", vim.log.levels.WARN)
		return
	end

	vim.notify("Looking for tests for function: " .. func_name, vim.log.levels.INFO)

	-- Find test files
	local test_files = find_test_files()
	if #test_files == 0 then
		vim.notify("No test files found", vim.log.levels.WARN)
		return
	end

	-- Search for test function in all test files
	local all_matches = {}
	for _, filepath in ipairs(test_files) do
		local matches = find_test_function_in_file(filepath, func_name)
		for _, match in ipairs(matches) do
			table.insert(all_matches, match)
		end
	end

	if #all_matches == 0 then
		vim.notify("No test function found for: " .. func_name, vim.log.levels.WARN)
		return
	end

	-- Sort matches by similarity score (highest first)
	table.sort(all_matches, function(a, b)
		return a.score > b.score
	end)

	-- Check if we have an exact match
	local exact_match = all_matches[1].score == 1.0

	if exact_match and #all_matches == 1 then
		-- Single exact match - navigate directly
		local match = all_matches[1]
		vim.cmd("edit " .. match.file)
		vim.api.nvim_win_set_cursor(0, { match.line, 0 })
		vim.notify("Navigated to: " .. match.function_name)
	else
		-- Multiple matches or no exact match - show selection
		local items = {}
		for i, match in ipairs(all_matches) do
			if i <= 10 then -- Show top 10 matches
				local score_indicator = match.score == 1.0 and " [EXACT]" or string.format(" (%.2f)", match.score)
				table.insert(
					items,
					string.format(
						"%s:%d - %s%s",
						vim.fn.fnamemodify(match.file, ":t"),
						match.line,
						match.function_name,
						score_indicator
					)
				)
			end
		end

		vim.ui.select(items, {
			prompt = "Choose test function:",
		}, function(choice, idx)
			if choice and idx then
				local selected_match = all_matches[idx]
				vim.cmd("edit " .. selected_match.file)
				vim.api.nvim_win_set_cursor(0, { selected_match.line, 0 })
				vim.notify("Navigated to: " .. selected_match.function_name)
			end
		end)
	end
end

-- Setup function to create keymapping
function M.setup(opts)
	opts = opts or {}
	local keymap = opts.keymap

	vim.keymap.set("n", keymap, M.navigate_to_test, {
		desc = "Navigate to test function",
		noremap = true,
		silent = true,
	})
end

return M
