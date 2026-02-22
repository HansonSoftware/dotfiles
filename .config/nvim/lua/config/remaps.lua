vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

-- disable replace mode
vim.keymap.set({ "n", "v" }, "R", "<Nop>", { silent = true })

-- unhighlight search
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- diagnostic keymaps
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- reactionary esc esc to leave terminal mode
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- toggle spell check
keymap.set("n", "<leader>sc", ":setlocal spell spelllang=en_us<CR>", { desc = "[S]pell [C]heck" })

-- center cursor when scrolling
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "<C-f>", "<C-f>zz")
keymap.set("n", "<C-b>", "<C-b>zz")

-- move lines up in visual mode
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- make Q not quit vim if accidentally pressed...
keymap.set("n", "Q", "<nop>")

-- number utils
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window resizing
keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]])
keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]])
keymap.set("n", "+", [[<cmd>horizontal resize +5<cr>]])
keymap.set("n", "^", [[<cmd>horizontal resize +5<cr>]])

-- window splits
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sx", "<cmd>close<CR>")

-- window navigation
keymap.set("n", "<C-h>", "<C-w><C-h>")
keymap.set("n", "<C-l>", "<C-w><C-l>")
keymap.set("n", "<C-j>", "<C-w><C-j>")
keymap.set("n", "<C-k>", "<C-w><C-k>")
