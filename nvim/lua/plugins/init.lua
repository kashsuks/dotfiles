return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfigw",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  },

  { 
    "wakatime/vim-wakatime", 
    lazy = false 
  },
{
  "kashsuks/blueberry.nvim",
  lazy = false,
  priority = 1000, -- Load after NvChad
  opts = {
    theme = "dark",
    transparent = true,
  },
  config = function(_, opts)
    require("blueberry").setup(opts)
    -- Force apply after NvChad loads
    vim.schedule(function()
      vim.cmd("colorscheme blueberry")
    end)
  end,
  keys = {
    { "<leader>tt", "<cmd>BlueberryToggle<cr>", desc = "Toggle Blueberry theme" },
  },
},

  {
    'nvim-telescope/telescope.nvim', tag = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
      require('telescope.builtin').find_files()
    end
  }

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}