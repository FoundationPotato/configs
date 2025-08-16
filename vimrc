set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set nocompatible
set nobackup
set nowrap
set incsearch
set ignorecase
set showcmd
set showmode
set showmatch
set hlsearch

set path+=**
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set termguicolors

filetype on
filetype plugin on
filetype indent on

let g:netrw_banner=0

syntax on

" PLUGINS ------------------------------------------

call plug#begin('~/.vim/plugged')

Plug 'menisadi/kanagawa.vim'
Plug 'neoclide/coc.vim', {'branch': 'release'}

call plug#end()

" VIMSCRIPT --------------------------------------


" enable code folding
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" STATUSLINE --------------------------------------
set statusline=
set statusline+=\ %F\ %M\ %Y\ %R
set statusline+=%=
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%
set laststatus=2
