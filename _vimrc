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

" autoindent        Match indent level from previous line
" expandtab         Uses spaces instead of tab upon a <Tab> keystroke
" smarttab          Uses shiftwidth at the start of lines instead of tabstop
" tabstop           changes the nunber of spaces use to display a tab character
" shiftwidth        Number of spaces to move by when indenting/outdenting
" formatoptions     each letter represents a formatting rule (see help: fo-table)
autocmd FileType * setlocal tabstop=4 shiftwidth=4
autocmd BufEnter *.py setlocal autoindent shiftwidth=4 tabstop=4 smarttab expandtab formatoptions=croql
autocmd BufEnter *.conf setlocal autoindent shiftwidth=4 tabstop=4 smarttab noexpandtab formatoptions=croql
autocmd BufRead,BufNewFile *.as setlocal filetype=actionscript
autocmd BufEnter *.json setlocal filetype=javascript autoindent shiftwidth=4 tabstop=4 smarttab expandtab formatoptions=croql
autocmd BufRead,BufNewFile .bash_aliases*,.bash_prompt* setlocal filetype=sh

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
set wildignore+=*.o,*.obj,.git,*.pyc,*.sqlite,*.sqlite3,env

" Disable text wrapping
set nowrap
" Wrap toggle on/off
map <leader>w :set wrap!<bar>set wrap?<CR>

" Enable search highlighting
set hlsearch
" Search highlighting toggle on/off
map <leader>h :set hlsearch!<bar>set hlsearch?<CR>

" Show red background for code over 80 chars long
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/
" A vertical line highlighting long lines
if exists("+colorcolumn")
    set colorcolumn=80,120
    hi colorcolumn ctermbg=black guibg=#383838
endif

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

" Map Alt-L for NerdTree
map <leader>f :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc','env','migrations']

" Toggle Gundo (list of recent edits you can revert)
map <leader>g :GundoToggle<CR>

" TaskList of TODOs and FIXMEs
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

if has("win32")
    map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
    set guifont=dejavu_sans_mono:h11
endif

" Remove trailing whitespace
command! NoTrails %s/\s\+$//
" Alternative method of removing trailing whitespace
" nnoremap<leader>ws :%s/\s\+$//<cr>:let @/=''<CR>

" Add the virtualenv's site-packages to vim path
python << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir,
    'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
