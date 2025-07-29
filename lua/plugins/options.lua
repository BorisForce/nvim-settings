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

