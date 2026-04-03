return {
	"andyg/leap.nvim",
	url = "https://codeberg.org/andyg/leap.nvim",
	lazy = false,
	config = function()
		local leap = require("leap")

		vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap forward to" })
		vim.keymap.set("n", "S", "<Plug>(leap-from-window)", { desc = "Leap from window" })

		leap.opts.preview = function(ch0, ch1, ch2)
			return not (ch1:match("%s") or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a")))
		end

		leap.opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }

		-- Repeat last leap with enter/backspace
		local clever = require("leap.user").with_traversal_keys
		vim.keymap.set({ "n", "x", "o" }, "<cr>", function()
			leap.leap({ ["repeat"] = true, opts = clever("<cr>", "<bs>") })
		end, { desc = "Leap repeat forward" })
		vim.keymap.set({ "n", "x", "o" }, "<bs>", function()
			leap.leap({ ["repeat"] = true, opts = clever("<bs>", "<cr>"), backward = true })
		end, { desc = "Leap repeat backward" })
	end,
}
