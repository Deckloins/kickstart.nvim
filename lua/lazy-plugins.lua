require('lazy').setup {

  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  require 'kickstart.plugins.which-key',
  require 'kickstart.plugins.telescope',

  require 'kickstart.plugins.lspconfig',
  require 'kickstart.plugins.conform',
  require 'kickstart.plugins.blink-cmp',

  -- NOTE: Colorschemes
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  require 'kickstart.plugins.kanso',
  require 'kickstart.plugins.gruvbox-material',

  require 'kickstart.plugins.todo-comments',

  require 'kickstart.plugins.mini',

  require 'kickstart.plugins.treesitter',

  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns',

  { import = 'custom.plugins' },

  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search

  {
    ui = {
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  },
}
