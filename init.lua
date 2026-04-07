vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.wrap = false
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.completeopt = { "menu", "menuone", "popup", "fuzzy", "noinsert", "noselect" }
vim.opt.winborder = "rounded"
vim.opt.swapfile = false
vim.opt.pumheight = 10
vim.opt.list = true
vim.opt.listchars = {
    tab = '> ',
    space = '·',
    trail = '·',
}

vim.g.netrw_banner = 0

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.scrolloff = 10
vim.o.splitright = true

vim.o.updatetime = 200

vim.g.mapleader = "#"

-- Key maps
vim.keymap.set({'n', 'i'}, '<C-h>', '<C-w>h')
vim.keymap.set({'n', 'i'}, '<C-j>', '<C-w>j')
vim.keymap.set({'n', 'i'}, '<C-k>', '<C-w>k')
vim.keymap.set({'n', 'i'}, '<C-l>', '<C-w>l')

vim.keymap.set('n', '<leader>t', ':ToggleHeaderSource<CR>')
vim.keymap.set('n', '<leader>e', ':GoErrBlock<CR>')
vim.keymap.set('n', '<leader>f', ':Files<CR>')
vim.keymap.set('n', '<leader>b', ':Buffers<CR>')
vim.keymap.set('n', '<leader>n', ':noh<CR>')

vim.keymap.set('n', '<leader>\\', ':vsplit<CR>')
vim.keymap.set('n', '<leader>-', ':split<CR>')
vim.keymap.set('n', '<leader>x', ':close<CR>')
vim.keymap.set('n', '<leader>o', ':only<CR>')
vim.keymap.set({'v', 'n'}, "<leader>y", '"*y')
vim.keymap.set({'v', 'n'}, "<leader>p", '"*p')

-- Edit nvim config
vim.api.nvim_create_user_command('EditNvimConfig', function()
    vim.cmd('edit ~/.config/nvim/init.lua')
end, {})

-- Edit shell config
vim.api.nvim_create_user_command('EditShellConfig', function()
    vim.cmd('edit ~/.bashrc')
end, {})

-- Plugins
vim.pack.add({
'https://github.com/neovim/nvim-lspconfig',
'https://github.com/nvim-treesitter/nvim-treesitter',
'https://github.com/junegunn/fzf',
'https://github.com/junegunn/fzf.vim',
'https://github.com/hrsh7th/nvim-cmp',
'https://github.com/hrsh7th/cmp-nvim-lsp',
'https://github.com/nvim-lualine/lualine.nvim',
'https://github.com/navarasu/onedark.nvim',
})

-- Appearance
require('onedark').setup {
    style = 'dark'
}
require('onedark').load()

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

-- lua
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
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'odin' },
  callback = function() vim.treesitter.start() end,
})

-- commands

vim.api.nvim_create_user_command("ToggleHeaderSource", function()
  local filename = vim.fn.expand("%:t:r")   -- basename without extension
  local ext = vim.fn.expand("%:e")          -- extension
  local current_dir = vim.fn.expand("%:p:h") -- current file's directory

  -- Directories to search.
  -- Add your project-specific include/source paths here.
  local search_dirs = {
    current_dir,
    current_dir .. "/..",
    current_dir .. "/../include",
    current_dir .. "/../src",
    "include",
    "src",
  }

  local candidates = {}
  if vim.tbl_contains({ "cpp", "cc", "c" }, ext) then
    candidates = { ".h", ".hpp", ".hh" }
  elseif vim.tbl_contains({ "h", "hpp", "hh" }, ext) then
    candidates = { ".cpp", ".cc", ".c" }
  end

  for _, dir in ipairs(search_dirs) do
    for _, e in ipairs(candidates) do
      local try = dir .. "/" .. filename .. e
      if vim.fn.filereadable(try) == 1 then
        vim.cmd("edit " .. try)
        return
      end
    end
  end

  print("No corresponding file found in search paths.")
end, {})


vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.api.nvim_create_user_command('GoErrBlock', function()
      local row = vim.api.nvim_win_get_cursor(0)[1]  -- current cursor line (1-indexed)
      local indent = vim.fn.indent(row)              -- get current line's indentation

      -- Build the block with correct indentation
      local lines = {
        string.rep(" ", indent) .. "if err != nil {",
        string.rep(" ", indent + vim.bo.shiftwidth), -- blank line (will have inner indent)
        string.rep(" ", indent) .. "}",
      }

      -- Insert lines after current line
      vim.api.nvim_buf_set_lines(0, row, row, false, lines)

      -- Move cursor to the middle blank line at correct indentation
      vim.api.nvim_win_set_cursor(0, { row + 2, indent + vim.bo.shiftwidth })
    end, { desc = "Insert Go error handling block" })
  end,
})
