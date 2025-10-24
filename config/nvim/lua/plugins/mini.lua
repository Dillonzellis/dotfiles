return {
	-- Mini.pick configuration
	{
		"echasnovski/mini.pick",
		version = false, -- Use HEAD
		config = function()
			local pick = require("mini.pick")
			pick.setup({
				options = {
					use_cache = true,
				},
			})



			-- Which-Key integration picker
			local function pick_which_key()
				local wk_ok, wk = pcall(require, "which-key")
				if not wk_ok then
					vim.notify("Which-key not available", vim.log.levels.WARN)
					return
				end

				local items = {}

				-- Get leader-based keymaps that are likely registered with which-key
				local leader = vim.g.mapleader or " "
				local keymaps = vim.api.nvim_get_keymap("n")
				local buf_keymaps = vim.api.nvim_buf_get_keymap(0, "n")

				-- Combine global and buffer keymaps
				local all_keymaps = {}
				for _, map in ipairs(keymaps) do
					table.insert(all_keymaps, map)
				end
				for _, map in ipairs(buf_keymaps) do
					table.insert(all_keymaps, map)
				end

				-- Filter for leader-based or commonly mapped keys
				for _, map in ipairs(all_keymaps) do
					if map.lhs then
						local should_include = false

						-- Include leader-based mappings
						if string.find(map.lhs, "^" .. vim.pesc(leader)) then
							should_include = true
						end

						-- Include common prefixes
						local common_prefixes = { "g", "z", "]", "[", "<C-", "<A-" }
						for _, prefix in ipairs(common_prefixes) do
							if string.find(map.lhs, "^" .. vim.pesc(prefix)) then
								should_include = true
								break
							end
						end

						if should_include and map.desc then
							local desc = map.desc
							local is_buffer = false

							-- Check if this is a buffer-local mapping
							for _, buf_map in ipairs(buf_keymaps) do
								if buf_map.lhs == map.lhs then
									is_buffer = true
									break
								end
							end

							table.insert(items, {
								text = string.format("%-20s %s%s", map.lhs, desc, is_buffer and " [buf]" or ""),
								value = map.lhs,
								is_group = false,
								desc = desc,
							})
						end
					end
				end

				-- Add visual mode keymaps with descriptions
				local visual_maps = vim.api.nvim_get_keymap("v")
				for _, map in ipairs(visual_maps) do
					if map.lhs and map.desc then
						local should_include = false

						-- Include leader-based or common mappings
						if string.find(map.lhs, "^" .. vim.pesc(leader)) then
							should_include = true
						end

						local common_prefixes = { "g", "z", "]", "[", "<C-", "<A-" }
						for _, prefix in ipairs(common_prefixes) do
							if string.find(map.lhs, "^" .. vim.pesc(prefix)) then
								should_include = true
								break
							end
						end

						if should_include then
							table.insert(items, {
								text = string.format("%-20s %s [visual]", map.lhs, map.desc),
								value = map.lhs,
								mode = "v",
								is_group = false,
								desc = map.desc,
							})
						end
					end
				end

				-- If no items found, fallback to all leader mappings
				if #items == 0 then
					for _, map in ipairs(all_keymaps) do
						if map.lhs and string.find(map.lhs, "^" .. vim.pesc(leader)) then
							local desc = map.desc or map.rhs or (map.callback and "[Function]") or "[No description]"
							table.insert(items, {
								text = string.format("%-20s %s", map.lhs, desc),
								value = map.lhs,
								is_group = false,
								desc = desc,
							})
						end
					end
				end

				-- Remove duplicates and sort
				local seen = {}
				local unique_items = {}
				for _, item in ipairs(items) do
					local key = item.value .. (item.mode or "n")
					if not seen[key] then
						seen[key] = true
						table.insert(unique_items, item)
					end
				end

				table.sort(unique_items, function(a, b)
					return a.value < b.value
				end)

				require("mini.pick").start({
					source = {
						items = unique_items,
						name = "Which-Key Style Commands",
						choose = function(item)
							if item and not item.is_group then
								-- Execute the key sequence
								local mode = item.mode or "n"
								local keys = vim.api.nvim_replace_termcodes(item.value, true, false, true)
								vim.api.nvim_feedkeys(keys, mode, false)
							end
						end,
					},
				})
			end

			-- Regular keymap picker (all keymaps)
			local function pick_keymaps()
				local keymaps = {}

				-- Get all keymaps for normal mode
				local normal_maps = vim.api.nvim_get_keymap("n")
				for _, map in ipairs(normal_maps) do
					if map.lhs then
						local desc = map.desc or map.rhs or (map.callback and "[Function]") or ""
						table.insert(keymaps, {
							text = string.format("%-20s %s", map.lhs, desc),
							value = map.lhs,
							mode = "n",
							map = map,
						})
					end
				end

				-- Get buffer-local keymaps for current buffer
				local buf_maps = vim.api.nvim_buf_get_keymap(0, "n")
				for _, map in ipairs(buf_maps) do
					if map.lhs then
						local desc = map.desc or map.rhs or (map.callback and "[Function]") or ""
						table.insert(keymaps, {
							text = string.format("%-20s %s [buf]", map.lhs, desc),
							value = map.lhs,
							mode = "n",
							map = map,
						})
					end
				end

				-- Visual mode keymaps
				local visual_maps = vim.api.nvim_get_keymap("v")
				for _, map in ipairs(visual_maps) do
					if map.lhs then
						local desc = map.desc or map.rhs or (map.callback and "[Function]") or ""
						table.insert(keymaps, {
							text = string.format("%-20s %s [visual]", map.lhs, desc),
							value = map.lhs,
							mode = "v",
							map = map,
						})
					end
				end

				-- Sort keymaps
				table.sort(keymaps, function(a, b)
					return a.value < b.value
				end)

				require("mini.pick").start({
					source = {
						items = keymaps,
						name = "All Keymaps",
						choose = function(item)
							if item then
								-- Execute the keymap
								local keys = vim.api.nvim_replace_termcodes(item.value, true, false, true)
								vim.api.nvim_feedkeys(keys, item.mode or "n", false)
							end
						end,
					},
				})
			end

			-- Make functions globally available
			_G.pick_which_key = pick_which_key
			_G.pick_keymaps = pick_keymaps
		end,
		keys = {
			{ "<leader><leader>", "<cmd>Pick files<cr>", desc = "Find Files" },
			{ "<leader>fb", "<cmd>Pick buffers<cr>", desc = "Find Buffers" },
			{
				"<leader>fg",
				function()
					vim.ui.input({ prompt = "Grep:" }, function(input)
						if input and input ~= "" then
							require("mini.pick").builtin.cli({
								command = { "rg", "--line-number", "--column", "--no-heading", "--color=never", input },
								postprocess = function(lines)
									local items = {}
									for _, line in ipairs(lines) do
										local file, lnum, col, text = line:match("^([^:]+):(%d+):(%d+):(.*)$")
										if file then
											table.insert(items, {
												text = string.format("%s:%s: %s", file, lnum, text:gsub("^%s+", "")),
												path = file,
												lnum = tonumber(lnum),
												col = tonumber(col),
											})
										end
									end
									return items
								end,
							})
						end
					end)
				end,
				desc = "Grep Search"
			},
			{
				"<leader>fk",
				function()
					_G.pick_keymaps()
				end,
				desc = "Find All Keymaps",
			},
			{
				"<leader>fK",
				function()
					_G.pick_which_key()
				end,
				desc = "Find Which-Key Commands",
			},

			{
				"<leader>h",
				function()
					require("mini.pick").builtin.cli({ command = { "rg", "--files", "--hidden" } })
				end,
				desc = "Find Files (with hidden)",
			},
		},
	},

	-- Mini.extra configuration
	{
		"echasnovski/mini.extra",
		version = false, -- Use HEAD
		config = function()
			require("mini.extra").setup()
		end,
		keys = {
			-- Git file pickers
			{
				"<leader>gf",
				function()
					require("mini.extra").pickers.git_files()
				end,
				desc = "Git Files (changed)",
			},
			{
				"<leader>gh",
				function()
					require("mini.extra").pickers.git_hunks()
				end,
				desc = "Git Hunks",
			},
			{
				"<leader>gb",
				function()
					require("mini.extra").pickers.git_branches()
				end,
				desc = "Git Branches",
			},
			{
				"<leader>gc",
				function()
					require("mini.extra").pickers.git_commits()
				end,
				desc = "Git Commits",
			},
		},
	},
}
