return {
  {
    -- `lazydev` configures lua lsp for your neovim config, runtime and plugins
    -- used for completion, annotations and signatures of neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- main lsp configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- automatically install lsps and related tools to stdpath for neovim
      -- mason must be loaded before its dependents so we need to set it up here.
      -- note: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'whoissethdaniel/mason-tool-installer.nvim',

      -- useful status updates for lsp.
      { 'j-hui/fidget.nvim', opts = {} },

      -- allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- if you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  this function gets run when an lsp attaches to a particular buffer.
      --    that is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('lspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- note: remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- in this case, we create a function that lets us more easily define mappings specific
          -- for lsp related items. it sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'lsp: ' .. desc })
          end

          -- rename the variable under your cursor.
          --  most language servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[r]e[n]ame')

          -- execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your lsp for this to activate.
          map('gra', vim.lsp.buf.code_action, '[g]oto code [a]ction', { 'n', 'x' })

          -- find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')

          -- jump to the implementation of the word under your cursor.
          --  useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[g]oto [i]mplementation')

          -- jump to the definition of the word under your cursor.
          --  this is where a variable was first declared, or where a function is defined, etc.
          --  to jump back, press <c-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')

          -- warn: this is not goto definition, this is goto declaration.
          --  for example, in c this would take you to the header.
          map('grd', vim.lsp.buf.declaration, '[g]oto [d]eclaration')

          -- fuzzy find all the symbols in your current document.
          --  symbols are things like variables, functions, types, etc.
          map('go', require('telescope.builtin').lsp_document_symbols, 'open document symbols')

          -- fuzzy find all the symbols in your current workspace.
          --  similar to document symbols, except searches over your entire project.
          map('gw', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'open workspace symbols')

          -- jump to the type of the word under your cursor.
          --  useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[g]oto [t]ype definition')

          -- this function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.client
          ---@param method vim.lsp.protocol.method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- the following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    see `:help cursorhold` for information about when this is executed
          --
          -- when you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'cursorhold', 'cursorholdi' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'cursormoved', 'cursormovedi' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('lspdetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- the following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- this may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textdocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[t]oggle inlay [h]ints')
          end
        end,
      })

      -- diagnostic config
      -- see :help vim.diagnostic.opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.E] = '󰅚 ',
            [vim.diagnostic.severity.W] = '󰀪 ',
            [vim.diagnostic.severity.I] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.E] = diagnostic.message,
              [vim.diagnostic.severity.W] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- enable the following language servers
      --  feel free to add/remove any lsps that you want here. they will automatically be installed.
      --
      --  add any additional override configuration in the following tables. available keys are:
      --  - cmd (table): override the default command used to start the server
      --  - filetypes (table): override the default list of associated filetypes for the server
      --  - capabilities (table): override fields in capabilities. can be used to disable certain lsp features.
      --  - settings (table): override the default settings passed when initializing the server.
      --        for example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        pyright = {},
        rust_analyzer = {},
        -- ... etc. see `:help lspconfig-all` for a list of all the pre-configured lsps
        --
        -- some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- but for many setups, the lsp (`ts_ls`) will work just fine
        -- ts_ls = {},
        --
        ansiblels = {},
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            lua = {
              completion = {
                callsnippet = 'replace',
              },
              -- you can toggle below to ignore lua_ls's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' }, global = { 'vim' } },
            },
          },
        },
      }

      -- ensure the servers and tools above are installed
      --
      -- to check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :mason
      --
      -- you can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- you can add other tools here that you want mason to install
      -- for you, so that they are available from within neovim.
      local ensure_installed = vim.tbl_keys(servers or {})

      require('mason-tool-installer').setup {
        ensure_installed = vim.list_extend(ensure_installed, {
          'stylua', -- format tool
        }),
      }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- this handles overriding only values explicitly passed
            -- by the server configuration above. useful when disabling
            -- certain features of an lsp (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
