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
}
