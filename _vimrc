set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'mileszs/ack.vim'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'sjl/splice.vim'
Plugin 'derekwyatt/vim-scala'
Plugin 'sickill/vim-monokai'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


" Set colors depending on gvim or vim
if has("gui_running")
    colorscheme monokai
else
    colorscheme monokai
endif

" Maximize GVim on start
if has("gui_running")
  set lines=999 columns=999
endif

" Enable syntax highlighting
syntax on
" Filtype detection, load plugin files, load indent files
filetype plugin indent on

" Enable code folding
set foldmethod=indent
set foldlevel=99

set noswapfile

" autoindent        Match indent level from previous line
" expandtab         Uses spaces instead of tab upon a <Tab> keystroke
" smarttab          Uses shiftwidth at the start of lines instead of tabstop
" tabstop           changes the nunber of spaces use to display a tab character
" shiftwidth        Number of spaces to move by when indenting/outdenting
" formatoptions     each letter represents a formatting rule (see help: fo-table)
autocmd BufNewFile,BufRead *.gyp set filetype=python
autocmd BufNewFile,BufRead *.gypi set filetype=python
autocmd FileType * setlocal tabstop=4 shiftwidth=4
autocmd BufEnter *.py setlocal autoindent shiftwidth=4 tabstop=4 smarttab expandtab formatoptions=croql
autocmd BufEnter *.js setlocal autoindent shiftwidth=4 tabstop=4 smarttab expandtab formatoptions=croql
autocmd BufEnter *.conf setlocal filetype=conf autoindent shiftwidth=4 tabstop=4 smarttab expandtab nolist formatoptions=croql
autocmd BufEnter *.xml setlocal filetype=xml autoindent shiftwidth=4 tabstop=4 smarttab expandtab nolist formatoptions=croql
autocmd BufRead,BufNewFile *.as setlocal filetype=actionscript
autocmd BufEnter *.json setlocal filetype=javascript autoindent shiftwidth=4 tabstop=4 smarttab expandtab formatoptions=croql
autocmd BufEnter *.go setlocal filetype=javascript autoindent shiftwidth=4 tabstop=4 smarttab expandtab formatoptions=croql
autocmd BufRead,BufNewFile .bash_aliases*,.bash_prompt* setlocal filetype=sh
autocmd FileType c setlocal foldmethod=syntax
autocmd BufEnter *.html setlocal autoindent shiftwidth=4 tabstop=4 smarttab expandtab formatoptions=croql
autocmd BufEnter *.xhtml setlocal autoindent shiftwidth=4 tabstop=4 smarttab expandtab formatoptions=croql
autocmd BufEnter htmldjango setlocal autoindent shiftwidth=4 tabstop=4 smarttab expandtab formatoptions=croql

" Keystroke namespace under which to map global user-defined commands.
let mapleader = ","

" Keystroke namespace used for filetype-specific commands
let maplocalleader = "\\"

" Cursor lands below when doing a split
set splitbelow
" Cursor lands to the right when doing a vsplit
set splitright

" Alt-arrows to navigate between buffers
map <A-left> <C-W>h
map <A-right> <C-W>l
map <A-up> <C-W>k
map <A-down> <C-W>j
map <C-Tab> <Esc>:bnext!<CR>
map <C-S-Tab> <Esc>:bprevious!<CR>

" Generally ignore these file types in file listings.
set wildignore+=*.o,*.obj,.git,*.pyc,*.sqlite,*.sqlite3,tags

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
let NERDTreeIgnore=['\.pyc','env','migrations', '_trial_temp']

if executable('ag')
    let g:ctrlp_user_command='ag %s --files-with-matches --nocolor --hidden -g ""'
    let g:ctrlp_use_caching=0
endif

" Validate code against PEP8
let g:pep8_map='<leader>8'

" Fuzzy search in code
nmap <leader>a <Esc>:Ack!

" Show tabs as arrows and trailing spaces as dots
if has("win32")
    set list listchars=tab:»\ ,trail:·
else
    set list listchars=tab:â†’\ ,trail:Â·
endif
noremap <leader>l :set list!<CR>

if has("win32")
    map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
    set guifont=dejavu_sans_mono:h11
endif

" Remove trailing whitespace
command! NoTrails %s/\s\+$//
" Alternative method of removing trailing whitespace
" nnoremap<leader>ws :%s/\s\+$//<cr>:let @/=''<CR>

function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
map <leader>D :call DeleteHiddenBuffers()<CR>

set completeopt=menu
