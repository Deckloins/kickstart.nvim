-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'catgoose/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {
      rgb_fn = true,
      css = true,
      css_fn = true,
      xterm = true,
    },
  },
  require 'custom.plugins.nvim-surround',

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    'mrcjkb/rustaceanvim',
    lazy = false,
    ft = { 'rust' },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set('n', '<leader>cR', function()
              vim.cmd.RustLsp 'codeAction'
            end, { desc = 'Code Action', buffer = bufnr })
            vim.keymap.set('n', '<leader>dr', function()
              vim.cmd.RustLsp 'debuggables'
            end, { desc = 'Rust Debuggables', buffer = bufnr })
          end,
          default_settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              -- Add clippy lints for Rust if using rust-analyzer
              checkOnSave = diagnostics == 'rust-analyzer',
              -- Enable diagnostics if using rust-analyzer
              diagnostics = {
                enable = diagnostics == 'rust-analyzer',
              },
              procMacro = {
                enable = true,
              },
              files = {
                excludeDirs = {
                  '.direnv',
                  '.git',
                  '.github',
                  '.gitlab',
                  'bin',
                  'node_modules',
                  'target',
                  'venv',
                  '.venv',
                },
              },
            },
          },
        },
      }
    end,
  },

  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
      completion = {
        crates = { enabled = true },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}
