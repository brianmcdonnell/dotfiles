filetype off
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Set colors depending on gvim or vim
if has("gui_running")
    colorscheme desert
else
    colorscheme torte
endif

" Enable syntax highlighting
syntax on
" Filtype detection, load plugin files, load indent files
filetype plugin indent on

autocmd BufEnter *.py set ai sw=4 ts=4 sta et fo=croql
autocmd BufRead,BufNewFile *.as set filetype=actionscript
autocmd FileType * set tabstop=4|set shiftwidth=4|set expandtab
au! BufRead,BufNewFile *.json set filetype=javascript foldmethod=syntax 
au BufNewFile,BufRead .bash_aliases*,.bash_prompt* call SetFileTypeSH("bash")


" Keystroke namespace under which to map global user-defined commands.
let mapleader = ","

" Keystroke namespace used for filetype-specific commands
let maplocalleader = "\\"

" Alt-arrows to navigate between buffers
map <A-left> <C-W>h
map <A-right> <C-W>l
map <A-up> <C-W>k
map <A-down> <C-W>j
map <C-Tab> <Esc>:bnext!<CR>
map <C-S-Tab> <Esc>:bprevious!<CR>

" Generally ignore these file types in file listings.
set wildignore+=*.o,*.obj,.git,*.pyc

" Disable text wrapping
set nowrap
" Wrap toggle on/off
map <leader>w :set wrap!<bar>set wrap?<CR>

" Enable search highlighting
set hlsearch
" Search highlighting toggle on/off
map <leader>h :set hlsearch!<bar>set hlsearch?<CR>

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
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/
" A vertical line highlighting long lines
set colorcolumn=80
hi colorcolumn ctermbg=black guibg=#383838

" Map Alt-L for NerdTree
map <leader>f :NERDTreeToggle<CR>
" map <ì> <Esc>:NERDTreeToggle<CR>
" map <A-l> <Esc>:NERDTreeToggle<CR>

" Toggle Gundo
map <leader>g :GundoToggle<CR>

" ,td for TaskList
map <leader>td <Plug>TaskList

" Supertab code completion
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

" Validate code against PEP8
let g:pep8_map='<leader>8'

" Jump to definition
map <leader>d :RopeGotoDefinition<CR>
" Rename occurances of...
map <leader>r :RopeRename<CR>

let g:pyflakes_use_quickfix = 0

" Fuzzy search in code
nmap <leader>a <Esc>:Ack!

" Show tabs as arrows and trailing spaces as dots
if has("win32")
    set list listchars=tab:»\ ,trail:·
else
    set list listchars=tab:â†’\ ,trail:Â·
endif

let NERDTreeIgnore=['\.pyc']
if has("win32")
    map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
    set guifont=dejavu_sans_mono:h11
endif

" Remove trailing whitespace
command! NoTrails %s/\s\+$//
" Alternative method of removing trailing whitespace
" nnoremap<leader>ws :%s/\s\+$//<cr>:let @/=''<CR>
