vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.wrap = false
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.guicursor = "n-v-i-c:block-Cursor"

vim.g.netrw_banner = 0
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.scrolloff = 10
vim.o.splitright = true

vim.o.complete = ".,o"
vim.o.completeopt = "menu,menuone,popup,fuzzy,noinsert,noselect"
vim.o.autocomplete = true
vim.o.pumheight = 7

vim.o.updatetime = 200

vim.g.mapleader = "#"

-- Key maps
vim.keymap.set({'n', 'i'}, '<C-h>', '<C-w>h')
vim.keymap.set({'n', 'i'}, '<C-j>', '<C-w>j')
vim.keymap.set({'n', 'i'}, '<C-k>', '<C-w>k')
vim.keymap.set({'n', 'i'}, '<C-l>', '<C-w>l')

vim.keymap.set('n', '<leader>f', ':Files<CR>')
vim.keymap.set('n', '<leader>b', ':Buffers<CR>')
vim.keymap.set('n', '<leader>n', ':noh<CR>')

vim.keymap.set('n', '<leader>\\', ':vsplit<CR>')
vim.keymap.set('n', '<leader>-', ':split<CR>')
vim.keymap.set('n', '<leader>x', ':close<CR>')
vim.keymap.set('n', '<leader>o', ':only<CR>')
vim.keymap.set({'v', 'n'}, "<leader>y", '"*y')
vim.keymap.set({'v', 'n'}, "<leader>p", '"*p')

-- yank to clipboard
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y')

-- Edit nvim config
vim.api.nvim_create_user_command('EditNvimConfig', function()
    vim.cmd('edit ~/.config/nvim/init.lua')
end, {})

-- Edit shell config
vim.api.nvim_create_user_command('EditShellConfig', function()
    vim.cmd('edit ~/.bashrc')
end, {})

-- Edit wezterm config
vim.api.nvim_create_user_command('EditWeztermConfig', function()
    vim.cmd('edit ~/.wezterm.lua')
end, {})

-- Plugins
vim.pack.add({
'https://github.com/neovim/nvim-lspconfig',
'https://github.com/junegunn/fzf',
'https://github.com/junegunn/fzf.vim',
'https://github.com/nvim-lualine/lualine.nvim',
'https://github.com/vague-theme/vague.nvim',
})

-- Appearance
vim.cmd.colorscheme('vague')

require('lualine').setup()

-- Diagnostics
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  signs = true,
  float = {
    border = "rounded",
    source = true,
  },
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {focus = false})
  end,
})

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {buffer = bufnr, desc = desc})
        end

        map('n', 'K', vim.lsp.buf.hover, 'LSP Hover')
        map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
        map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
        map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
        map('n', 'gr', vim.lsp.buf.references, 'References')
    end,
})

-- lua
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
          vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library',
          -- '${3rd}/busted/library',
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = vim.api.nvim_get_runtime_file('', true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

vim.lsp.enable('lua_ls')

-- Go
vim.lsp.enable('gopls')

-- Odin
vim.lsp.enable('ols')

-- C/C++
vim.lsp.enable('clangd')

-- Rust
vim.lsp.enable('rust_analyzer')

-- Zig
vim.lsp.enable('zls')

-- commands
