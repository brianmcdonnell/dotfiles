syntax on
colorscheme desert

" Alt-arrows to navigate between buffers
map <A-left> <C-W>h
map <A-right> <C-W>l
map <A-up> <C-W>k
map <A-down> <C-W>j
map <C-Tab> <Esc>:bnext!<CR>
map <C-S-Tab> <Esc>:bprevious!<CR>

" Map Alt-L for NerdTree
map <A-l> <Esc>:NERDTreeToggle<CR>

" autocmd BufEnter *.py set ai sw=4 ts=4 sta et fo=croql
autocmd FileType * set tabstop=2|set shiftwidth=2|set noexpandtab
autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab
set softtabstop=4   " makes the spaces feel like real tabs
autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(

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
":set foldcolumn=0<CR>

if has("gui_running")
  colorscheme desert
else
  set background=dark
endif
