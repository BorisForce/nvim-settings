-- Lua configuration for Neovim: ToggleTerm with internal and external execution
local Terminal = require("toggleterm.terminal").Terminal
local builtin = require("telescope.builtin")
local api = require("nvim-tree.api")

-- Telescope & NvimTree keymaps
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep,  { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers,    { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags,  { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>e',  api.tree.toggle,    { desc = 'Toggle NvimTree' })
vim.keymap.set('n', '<leader>z',  api.tree.change_root_to_parent, { desc = 'NvimTree up' })

-- Basic keymaps
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit buffer' })
vim.keymap.set('i', 'jj',          '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('n', '<D-a>',       'ggVG',  { noremap = true, silent = true, desc = 'Select all' })

-- Internal ToggleTerm setup
local internal_term = Terminal:new({
  direction       = 'horizontal',
  close_on_exit   = false,
  hidden          = false,
  start_in_insert = true,
  id              = 99,
})

-- External Kitty log-based runner with runtime logging
local log_file = "/tmp/neovim_pyterm.log"
_G.run_in_external_terminal = false
_G.kitty_job_id = nil

-- Helper to write log separator
local function log_separator()
  local sep = string.rep("-", 40)
  local header = {sep, "Timestamp: " .. os.date(), sep}
  vim.fn.writefile(header, log_file, "a")
end

-- Auto-close Kitty on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if _G.kitty_job_id then
      vim.fn.jobstop(_G.kitty_job_id)
    end
  end,
})

-- Toggle execution mode (internal vs external)
vim.keymap.set('n', '<leader>R', function()
  _G.run_in_external_terminal = not _G.run_in_external_terminal
  print('Execution mode: ' .. (_G.run_in_external_terminal and 'External (Kitty)' or 'Internal (ToggleTerm)'))
end, { desc = 'Toggle execution mode' })

-- Run current Python script
vim.keymap.set('n', '<leader>r', function()
  local file = vim.fn.expand('%:p')
  local cwd  = vim.fn.getcwd()
  local external_cmd = string.format("{ time -p python3 %s; } 2>&1 >> %s", file, log_file)

  if _G.run_in_external_terminal then
    if not _G.kitty_job_id then
      -- First external run: clear log, add header, launch Kitty tail
      vim.fn.writefile({}, log_file)
      log_separator()
      _G.kitty_job_id = vim.fn.jobstart({
        'kitty',
        '--title', 'pyterm',
        '--directory', cwd,
        '--hold',
        'bash', '-lc', 'tail -f ' .. log_file
      }, { detach = true })
      print('🔄 Kitty launched tailing log: ' .. log_file)
    end
    -- External: append separator and run script with runtime into log
    log_separator()
    vim.fn.jobstart({ 'bash', '-lc', external_cmd }, { detach = true })
    print('🔗 Appended output and runtime of ' .. file .. ' to log')
  else
    -- Internal: open or reuse pane, send python command
    if not internal_term:is_open() then
      internal_term:open()
    end
    internal_term:send('python3 ' .. file)
    vim.defer_fn(function()
      vim.cmd('stopinsert')
      vim.cmd('wincmd p')
    end, 100)
  end
end, { desc = 'Run Python script' })

-- Toggle internal terminal pane
vim.keymap.set('n', '<leader>t', function()
  internal_term:toggle()
end, { desc = 'Toggle internal terminal' })

-- Open internal terminal in a right-hand vertical split
vim.keymap.set('n', '<leader>T', function()
  vim.cmd('vsplit | wincmd l')
  internal_term:open()
  vim.defer_fn(function()
    vim.cmd('wincmd h')
  end, 100)
end, { desc = 'Move terminal to right split' })

