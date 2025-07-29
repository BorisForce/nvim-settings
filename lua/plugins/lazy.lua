-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Colorscheme
  { "catppuccin/nvim", as = "catppuccin" },

  -- Fuzzy Finder
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },

  -- File Tree
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
  },

  -- Auto Session
 {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Downloads" },
      auto_session_enable_last_session = true,      -- reopen last session automatically
      auto_restore_enabled = true,                  -- restore buffers, windows, etc.
      pre_save_cmds = { "NvimTreeClose" },          -- optional: close NvimTree before saving session
    })
  end,
},

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Mason + LSP + Pyright
 
 

  {
  "williamboman/mason.nvim",
  lazy = false,
  build = ":MasonUpdate",
  config = true,
},

{
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local mason_lspconfig = require("mason-lspconfig")
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local util = require("lspconfig/util")

    mason_lspconfig.setup({
      ensure_installed = { "pyright", "lua_ls" },
    })

    -- Manually setup Pyright
    lspconfig.pyright.setup({
      capabilities = capabilities,
      before_init = function(_, config)
        config.settings = config.settings or {}
        config.settings.python = config.settings.python or {}
        config.settings.python.pythonPath = "/Users/borisgerat/miniforge3/bin/python"
      end,
    })

    -- Manually setup other servers if needed
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
    })
  end,
},
-- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
        }),
        sources = {
          { name = "nvim_lsp" },
        },
      })
    end,
  },
{
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({})
  end,
},


{
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
      },
    })
  end,
}

,
{
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      direction = "horizontal",
      -- dynamic size each time it's opened
      size = function(term)
        if term.direction == "horizontal" then
          return math.floor(vim.o.lines * 0.3) -- 30% height
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4) -- 40% width if vertical
        end
      end,
      open_mapping = [[<C-\>]],
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = false, -- 💡 key to allow size to re-evaluate each time
    })
  end,
},


{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "python", "lua", "bash", "json", "markdown" }, -- add what you need
      highlight = {
        enable = true, -- <-- this turns on highlighting
      },
    })
  end,
},

{
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify"
  },
  config = function()
    require("noice").setup({
      lsp = { progress = { enabled = true } },
      messages = { enabled = true },
      cmdline = { enabled = true },
      popupmenu = { enabled = true },
    })
  end
},

{
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "BufReadPre",
  config = function()
    require("ibl").setup({
      indent = {
        char = "│", -- alternatives: "┊", "┆", "▏", "▎"
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
    })
  end,
}







}) 



