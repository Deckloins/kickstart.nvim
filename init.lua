--[[
    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

--]]

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
-- NOTE: Here is where you install your plugins.
require 'lazy-plugins'

-- TODO: Ajouter le texte en dessous au fichier lazy-plugins.lua
-- {
--     ui = {
--       -- If you are using a Nerd Font: set icons to an empty table which will use the
--       -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
--       icons = vim.g.have_nerd_font and {} or {
--         cmd = '⌘',
--         config = '🛠',
--         event = '📅',
--         ft = '📂',
--         init = '⚙',
--         keys = '🗝',
--         plugin = '🔌',
--         runtime = '💻',
--         require = '🌙',
--         source = '📄',
--         start = '🚀',
--         task = '📌',
--         lazy = '💤 ',
--       },
--     },
--   }

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
