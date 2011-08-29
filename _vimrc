filetype off
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Set colors depending on gvim or vim
if has("gui_running")
  colorscheme desert
else
  "set background = black
endif

" Enable syntax highlighting
syntax on
" Filtype detection, load plugin files, load indent files
filetype plugin indent on

autocmd BufEnter *.py set ai sw=4 ts=4 sta et fo=croql
autocmd BufRead,BufNewFile *.as set filetype=actionscript
autocmd FileType * set tabstop=4|set shiftwidth=4|set expandtab

" Keystroke namespace under which to map user-defined commands.
let mapleader = ","

" Alt-arrows to navigate between buffers
map <A-left> <C-W>h
map <A-right> <C-W>l
map <A-up> <C-W>k
map <A-down> <C-W>j
map <C-Tab> <Esc>:bnext!<CR>
map <C-S-Tab> <Esc>:bprevious!<CR>

" Disable text wrapping
set nowrap

" Enable code folding
set foldmethod=indent
set foldlevel=99

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

" Show red background for code over 80 chars long
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" Map Alt-L for NerdTree
map <A-l> <Esc>:NERDTreeToggle<CR>

" Toggle Gundo
map <leader>g :GundoToggle<CR>

" ,td for TaskList
map <leader>td <Plug>TaskList

" Show tabs as arrows and trailing spaces as dots
" set list listchars=tab:→\ ,trail:·

let NERDTreeIgnore=['\.pyc']
if has("win32")
    map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
endif

" Remove trailing whitespace
command! NoTrails %s/\s\+$//
" Alternative method of removing trailing whitespace
" nnoremap<leader>ws :%s/\s\+$//<cr>:let @/=''<CR>
