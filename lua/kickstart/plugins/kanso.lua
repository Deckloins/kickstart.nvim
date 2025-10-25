return {
  'webhooked/kanso.nvim',
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('kanso').setup {
      commentStyle = { italic = false }, -- Disable italics in comments
      background = {
        dark = 'mist',
      },
      foreground = 'default',
    }
    -- Load the colorscheme here.
    vim.cmd.colorscheme 'colorscheme kanso'
  end,
}
