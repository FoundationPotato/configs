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
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

call plug#end()
]])

-- Appearance
vim.cmd.colorscheme "catppuccin-macchiato"

-- Diagnostics
vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    wrap = true,
})

-- LSP
local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
  local buf_map = function(mode, lhs, rhs)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, {noremap=true, silent=true})
  end

  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  -- hover docs
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap=true, silent=true})
end
-- trigger omnifunc on '.' and 'C-n'
vim.keymap.set({'i'}, '<C-n>', '<C-x><C-o>', {noremap=true})
vim.api.nvim_set_keymap('i', '.', '.<C-x><C-o>', {noremap=true})
vim.api.nvim_set_keymap('i', '<Tap>', 'pumvisible() ? "<C-n>" : "<Tab>"', {expr=true, noremap=true})
vim.api.nvim_set_keymap('i', '<S-Tap>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', {expr=true, noremap=true})


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

-- Statusline
local function status_line() 
  local mode = "%-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}"
  local file_name = "%-.16t"
  local buf_nr = "[%n]"
  local modified = " %-m"
  local file_type = " %y"
  local right_align = "%="
  local line_no = "%10([%l/%L%)]"
  local pct_thru_file = "%5p%%"

  return string.format(
    "%s%s%s%s%s%s%s%s",
    mode,
    file_name,
    buf_nr,
    modified,
    file_type,
    right_align,
    line_no,
    pct_thru_file
  )
end

vim.opt.statusline = status_line()

-- Treesitter
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
}
