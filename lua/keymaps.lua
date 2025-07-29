vim.g.mapleader = " "

-- buffer motion
vim.keymap.set("n", "<leader>l", "$")
vim.keymap.set("n", "<leader>h", "^")
vim.keymap.set("v", "<leader>l", "$")

-- file actions
vim.keymap.set("n", "<leader>w", ":w<cr>")
vim.keymap.set("n", "<leader>q", ":q<cr>")
vim.keymap.set("n", "<leader>r", ":!python3 %<cr>")

-- insert mode: jj → <esc>
vim.keymap.set("i", "jj", "<esc>")

-- yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- format with black
vim.keymap.set("n", "<leader>fmp", ":silent !black %<cr>")

-- buffer navigation
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>p", ":bp<cr>")
vim.keymap.set("n", "<leader>x", ":bd<cr>")

-- cmd+a to select all (macos only)
vim.keymap.set("n", "<d-a>", "ggvg", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>tt", "<cmd>toggleterm<cr>", { desc = "toggle terminal" })

-- exit terminal mode with `jj`
vim.keymap.set("t", "jj", [[<c-\><c-n>]], { noremap = true, silent = true })

-- smart h: go to top of screen or jump 10 lines up
-- H: Move to top of visible screen
vim.keymap.set("n", "H", "H", { noremap = true, silent = true })

-- L: Move to bottom of visible screen
vim.keymap.set("n", "L", "L", { noremap = true, silent = true })

-- J: Jump 10 lines down
vim.keymap.set("n", "J", "10j", { noremap = true, silent = true })

-- K: Jump 10 lines up
vim.keymap.set("n", "K", "10k", { noremap = true, silent = true })

-- Resize horizontal ToggleTerm window
local function resize_term(amount)
  local terminals = require("toggleterm.terminal").get_all()
  for _, term in pairs(terminals) do
    if term.direction == "horizontal" and term:is_open() then
      term.window.height = term.window.height + amount
      vim.api.nvim_win_set_height(term.window.window_id, term.window.height)
    end
  end
end

vim.keymap.set("n", "<leader>+", function() resize_term(2) end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ľ", function() resize_term(-2) end, { noremap = true, silent = true })

