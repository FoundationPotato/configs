-- Basic settings
vim.opt.number = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.cmd("set path+=**")

-- Plugins
vim.cmd([[
call plug#begin('~/.vim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

call plug#end()
colorscheme kanagawa-wave
]])

local lspconfig = require("lspconfig")

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lspconfig").ols.setup({
  cmd = { "ols" },
  filetypes = { "odin" },
  root_dir = require("lspconfig").util.root_pattern("ols.json", ".git"),
  capabilities = capabilities,
})


require("nvim-treesitter.configs").setup {
    ensure_installed = { "odin", "lua", "c", "go", "rust" },
    highlight = {
        enable = true,
    },
}

require("nvim-tree").setup()

require("lualine").setup {
    options = {
        theme = "auto"
    }
}

-- Autocompletion setup (NO snippet support)
local cmp = require("cmp")
cmp.setup({
  completion = {
    autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }),
  experimental = {
    ghost_text = true,
  },
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
