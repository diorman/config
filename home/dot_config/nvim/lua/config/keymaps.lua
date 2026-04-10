local map = vim.keymap.set

-- Resize splits
map("n", "<A-Up>", "<cmd>vertical resize +2<cr>", { desc = "Window: Increase width" })
map("n", "<A-Down>", "<cmd>vertical resize -2<cr>", { desc = "Window: Decrease width" })
map("n", "<A-S-Up>", "<cmd>resize +2<cr>", { desc = "Window: Increase height" })
map("n", "<A-S-Down>", "<cmd>resize -2<cr>", { desc = "Window: Decrease height" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Line: Move down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Line: Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Line: Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Line: Move up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Line: Move down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Line: Move up" })

-- Quickfix list navigation
map("n", "<C-k>", "<cmd>cnext<cr>zz")
map("n", "<C-j>", "<cmd>cprev<cr>zz")
map("n", "<leader>k", "<cmd>lnext<cr>zz")
map("n", "<leader>j", "<cmd>lprev<cr>zz")

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

map("n", "J", "mzJ`z", { desc = "Same as native J but cursor stays in place" })

-- Half page jumping with. Cursor stays in the middle
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Search term stays in the middle
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Deletes selected text and paste contents in buffer
map("x", "<leader>p", [["_dP]])
map({ "n", "v" }, "<leader>d", [["_d]])

map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
