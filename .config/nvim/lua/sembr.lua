-- One sentence per line for markdown: a line break is added after each
-- sentence of a paragraph. Lines are never joined, and everything that is not
-- paragraph text (code, tables, headings, frontmatter, block quotes, lists) is
-- left alone.
local M = {}

-- Words that end in a period without ending the sentence (compared lowercase).
local abbreviations =
	{ "e.g", "i.e", "al", "cf", "vs", "fig", "eq", "no", "ca", "approx", "dr", "mr", "mrs", "ms", "prof" }

-- The text of every paragraph outside a block quote or list.
local paragraph_text = "((paragraph (inline) @text) (#not-has-ancestor? @text block_quote list))"

-- Text that can open a sentence: a capital or non-ASCII letter, a quote,
-- bracket or underscore, the start of `code`, *emphasis* or a #123 reference,
-- or a number. Anything else (lowercase, and whatever would start a list,
-- heading or code fence if it began a line) stays on the line it is on.
local function starts_sentence(text)
	return text:match("^[%u\128-\255%[\"'(_]") or text:match("^[*`#][^%s`#]") or text:match("^%d+[^%d.)]")
end

-- True when the last word of the text is an abbreviation or a single letter
-- (an initial), so that the period after it does not end a sentence.
local function ends_with_abbreviation(text)
	local word = text:match("%S*$"):gsub("^%p+", ""):lower()
	return vim.list_contains(abbreviations, word) or word:match("^%a$")
end

-- True when the text ends inside an open `code span` or [link text]: with the
-- closed ones removed, there is still something opening one.
local function ends_inside_span(text)
	return text:gsub("`[^`]*`", ""):gsub("%b[]", ""):match("[`%[]")
end

-- Put a line break (followed by `indent`) after each sentence of `text`.
local function break_sentences(text, indent)
	-- Sentence punctuation, any closing quotes/brackets/emphasis, then spaces.
	local broken = text:gsub("()([.!?]+[%)%]\"'*_]*) +()", function(start, punctuation, next_start)
		local before, after = text:sub(1, start - 1), text:sub(next_start)
		if starts_sentence(after) and not ends_with_abbreviation(before) and not ends_inside_span(before) then
			return punctuation .. "\n" .. indent
		end
	end)
	return broken
end

function M.format_lines(lines)
	local text = table.concat(lines, "\n")
	local root = vim.treesitter.get_string_parser(text, "markdown"):parse()[1]:root()
	local query = vim.treesitter.query.parse("markdown", paragraph_text)

	-- Copy the document piece by piece, breaking up each paragraph on the way.
	local out, copied = {}, 0
	for _, node in query:iter_captures(root, text) do
		local _, start_col, start_byte, _, _, end_byte = node:range(true)
		-- What precedes the paragraph on its first line (indent, list marker),
		-- blanked out, so that new lines line up with the first one.
		local indent = text:sub(start_byte - start_col + 1, start_byte):gsub("%S", " ")
		table.insert(out, text:sub(copied + 1, start_byte))
		table.insert(out, break_sentences(text:sub(start_byte + 1, end_byte), indent))
		copied = end_byte
	end
	table.insert(out, text:sub(copied + 1))
	return vim.split(table.concat(out), "\n")
end

return M
