vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.winborder = "rounded"
vim.opt.swapfile = false
vim.opt.pumheight = 10

vim.cmd("set path+=**")
vim.g.netrw_banner = 0

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.scrolloff = 109
vim.o.splitright = true

-- Key maps
vim.keymap.set({'n', 'i'}, '<C-h>', '<C-w>h')
vim.keymap.set({'n', 'i'}, '<C-j>', '<C-w>j')
vim.keymap.set({'n', 'i'}, '<C-k>', '<C-w>k')
vim.keymap.set({'n', 'i'}, '<C-l>', '<C-w>l')

vim.keymap.set({'i'}, '<C-Space>', '<C-x><C-o>')

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
})

-- LSP

-- Go
vim.lsp.enable('gopls')

require("lspconfig")["gopls"].setup({
	on_attach = function(client, bufnr)
      vim.lsp.completion.enable(true, client.id, bufnr, {
		autotrigger = true,
		convert = function(item)
          return { abbr = item.label:gsub("%b()", "") }
		end,
      })
      vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
    end
})

-- Odin
vim.lsp.enable('ols')

require("lspconfig")["ols"].setup({
	on_attach = function(client, bufnr)
      vim.lsp.completion.enable(true, client.id, bufnr, {
		autotrigger = true,
		convert = function(item)
          return { abbr = item.label:gsub("%b()", "") }
		end,
      })
      vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
    end
})

-- C/C++
vim.lsp.enable('clangd')

require("lspconfig")["clangd"].setup({
	on_attach = function(client, bufnr)
      vim.lsp.completion.enable(true, client.id, bufnr, {
		autotrigger = true,
		convert = function(item)
          return { abbr = item.label:gsub("%b()", "") }
		end,
      })
      vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
    end
})

-- Lua
-- vim.lsp.enable('lua_ls')
--
-- require("lspconfig")["lua_ls"].setup({
-- 	on_attach = function(client, bufnr)
--       vim.lsp.completion.enable(true, client.id, bufnr, {
-- 		autotrigger = true,
-- 		convert = function(item)
--           return { abbr = item.label:gsub("%b()", "") }
-- 		end,
--       })
--       vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
--     end
-- })

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
