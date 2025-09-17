return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	config = function()
		-- Setup orgmode
		require("orgmode").setup({
			org_agenda_files = "~/areas/orgfiles/**/*",
			org_default_notes_file = "~/areas/orgfiles/txart/refile.org",
			org_capture_templates = {
				p = {
					description = "Personal Task",
					template = "** TODO %?\n  SCHEDULED: %t\n",
					target = "~/areas/orgfiles/txart/personal.org",
				},
				w = {
					description = "Work Task",
					template = "** TODO %?\n  SCHEDULED: %t\n",
					target = "~/areas/orgfiles/txart/work.org",
				},

				u = {
					description = "Uminak Task",
					template = "** TODO %?\n  SCHEDULED: %t\n",
					target = "~/areas/orgfiles/uminak/uminak.org",
				},
			},
		})
	end,
}
