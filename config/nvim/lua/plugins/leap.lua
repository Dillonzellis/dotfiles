return {
	"ggandor/leap.nvim",
	keys = {
		{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
		{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
	},
	config = function()
		local leap = require("leap")

		-- Add default mappings
		leap.add_default_mappings()

		-- Recommended: Reduce visual noise with preview filter
		-- Excludes whitespace and middle of words from preview
		leap.opts.preview_filter = function(ch0, ch1, ch2)
			return not (ch1:match("%s") or ch0:match("%a") and ch1:match("%a") and ch2:match("%a"))
		end

		-- Recommended: Group similar characters for easier targeting
		leap.opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }

		-- Recommended: Use enter/backspace to repeat last motion
		require("leap.user").set_repeat_keys("<enter>", "<backspace>")
	end,
}
