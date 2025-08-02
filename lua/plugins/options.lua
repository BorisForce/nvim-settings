vim.cmd("colorscheme catppuccin-mocha") -- set color theme

vim.opt.termguicolors = true --bufferline
require("bufferline").setup{} --bufferline

-- In lua/plugins/options.lua or init.lua
vim.cmd("syntax on")



require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
})

vim.schedule(function()
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { fg = "#ffffff", bg = "#1e1e2e" })
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#ffffff", bg = "#1e1e2e" })
end)


vim.opt.wrap = false
vim.opt.linebreak = false
vim.opt.textwidth = 0
vim.opt.formatoptions:remove({ "t", "c", "r", "o" })

vim.api.nvim_create_augroup("NoWrapAll", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = "NoWrapAll",
  pattern = "*",
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = false
    vim.opt_local.textwidth = 0
    vim.opt_local.formatoptions:remove({ "t", "c", "r", "o" })
  end,
})


