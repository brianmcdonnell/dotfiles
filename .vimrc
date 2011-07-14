syntax on
colorscheme desert
set nowrap

" Alt-arrows to navigate between buffers
map <A-left> <C-W>h
map <A-right> <C-W>l
map <A-up> <C-W>k
map <A-down> <C-W>j
map <C-Tab> <Esc>:bnext!<CR>
map <C-S-Tab> <Esc>:bprevious!<CR>

" Map Alt-L for NerdTree
map <A-l> <Esc>:NERDTreeToggle<CR>

" Load plugins for filetypes
filetype plugin indent on
" Load indent file for filetypes
" filetype indent on

" autocmd BufEnter *.py set ai sw=4 ts=4 sta et fo=croql
autocmd BufRead,BufNewFile *.as set filetype=actionscript
autocmd FileType * set tabstop=4|set shiftwidth=4|set expandtab

" Enable code folding
set foldmethod=indent
set foldlevel=99

" Show tabs as arrows and trailing spaces as dots
set list listchars=tab:→\ ,trail:·

let NERDTreeIgnore=['\.pyc']
if has("win32")
    map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
endif

" Case-insensitive searches
set ignorecase

" Enable backspace
set bs=2

" Turn on line numbers
set number

" Mouse enabled in all modes
set mouse=a

" Toggle line numbers and fold column for easy copying:
nnoremap <F2> :set nonumber!<CR> 

if has("gui_running")
  colorscheme desert
else
  set background=dark
endif

" Remove trailing whitespace
command! NoTrails %s/\s\+$//
