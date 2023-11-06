-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  --  The configuration is done below. Search for lspconfig to find it below.
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',

      -- the null-ls replacement linter
      'mfussenegger/nvim-lint',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Adds LSP completion
      'hrsh7th/cmp-nvim-lsp',
      -- Adds path completion
      'hrsh7th/cmp-path',
      -- Adds buffer completion
      'hrsh7th/cmp-buffer',

      -- command line completion
      'hrsh7th/cmp-cmdline',
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {},
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',     opts = {} },

  {
    'folke/trouble.nvim',
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    }
  },

  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',

  'ruanyl/coverage.vim',

  { 'nvim-lualine/lualine.nvim' },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {
      indent = {
        char = '┊',
      }
    },
  },

  {
    "rockyzhang24/arctic.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    name = "arctic",
    branch = "main",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme my-arctic")
    end
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  "ThePrimeagen/harpoon",
  'ThePrimeagen/git-worktree.nvim',

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  { "HiPhish/rainbow-delimiters.nvim" },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
  },

  { "mbbill/undotree" },

  { 'ibhagwan/smartyank.nvim' },

  "nvim-tree/nvim-web-devicons",

  'rcarriga/nvim-notify',

  'ThePrimeagen/vim-be-good',

  "petertriho/nvim-scrollbar",

  {
    'mrjones2014/smart-splits.nvim',
    lazy = false
  },

  {
    "saimo/peek.nvim",
    event = { "BufRead", "BufNewFile" },
    build = "deno task --quiet build:fast",
  },
}, {})
