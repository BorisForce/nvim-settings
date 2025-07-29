local M = {}

local terminal_window_title = "nvim-terminal"
local terminal_cmd = "kitty --title " .. terminal_window_title .. " -d " .. vim.fn.getcwd() .. " zsh"

function M.spawn_terminal()
  -- Start Kitty with title
  vim.fn.jobstart(terminal_cmd, { detach = true })
end

function M.send_to_terminal(cmd)
  -- Send command to specific kitty window
  local full_cmd = "kitty @ send-text --match title:^" .. terminal_window_title .. "$ '" .. cmd .. "\\n'"
  vim.fn.system(full_cmd)
end

function M.ensure_terminal_exists()
  local result = vim.fn.systemlist("kitty @ ls")
  for _, line in ipairs(result) do
    if line:find('"title": "' .. terminal_window_title .. '"') then
      return true
    end
  end
  M.spawn_terminal()
  vim.defer_fn(function() end, 500)
end

return M

