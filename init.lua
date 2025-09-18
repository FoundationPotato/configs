vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.completeopt = { "menu", "menuone", "popup", "fuzzy", "noinsert", "noselect" }
vim.opt.winborder = "rounded"
vim.opt.swapfile = false
vim.opt.pumheight = 10

vim.cmd("set path+=**")
vim.g.netrw_banner = 0

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.scrolloff = 10
vim.o.splitright = true

vim.o.updatetime = 200

-- Key maps
vim.keymap.set({'n', 'i'}, '<C-h>', '<C-w>h')
vim.keymap.set({'n', 'i'}, '<C-j>', '<C-w>j')
vim.keymap.set({'n', 'i'}, '<C-k>', '<C-w>k')
vim.keymap.set({'n', 'i'}, '<C-l>', '<C-w>l')

-- Plugins
vim.cmd([[
call plug#begin('~/.vim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

Plug 'nvim-lualine/lualine.nvim'

Plug 'vague2k/vague.nvim'

call plug#end()
]])

-- Appearance
vim.cmd.colorscheme "vague"

require('lualine').setup()

-- Diagnostics
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  signs = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {focus = false})
  end,
})

-- LSP
local lspconfig = require('lspconfig')

-- Go
lspconfig.gopls.setup {
  on_attach = on_attach,
  filetypes = {"go", "gomod"},
  root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
  cmd = {"gopls"},
}

-- Odin
lspconfig.ols.setup {
  on_attach = on_attach,
  filetypes = {"odin"},
  cmd = {"ols"},
}

-- C/C++
lspconfig.clangd.setup {
  on_attach = on_attach,
  filetypes = {"c", "cpp", "h", "hpp"},
  cmd = {"clangd"},
}

-- nvim-cmp
local cmp = require('cmp')

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({select = true}),
  }),
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},
  }),
})

-- Treesitter
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
}
