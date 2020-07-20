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

" autoindent        Match indent level from previous line
" expandtab         Uses spaces instead of tab upon a <Tab> keystroke
" smarttab          Uses shiftwidth at the start of lines instead of tabstop
" tabstop           changes the nunber of spaces use to display a tab character
" shiftwidth        Number of spaces to move by when indenting/outdenting
" formatoptions     each letter represents a formatting rule (see help: fo-table)
autocmd FileType * setlocal tabstop=4 shiftwidth=4 formatoptions=croql
autocmd BufEnter *.py setlocal autoindent shiftwidth=4 tabstop=4 smarttab expandtab
autocmd BufEnter *.js setlocal autoindent shiftwidth=2 tabstop=2 smarttab expandtab
autocmd BufEnter *.html setlocal autoindent shiftwidth=2 tabstop=2 smarttab expandtab

" Alt-arrows to navigate between buffers
map <A-left> <C-W>h
map <A-right> <C-W>l
map <A-up> <C-W>k
map <A-down> <C-W>j
" Ctrl-tab through buffers
map <C-Tab> <Esc>:bnext!<CR>
map <C-S-Tab> <Esc>:bprevious!<CR>

colorscheme monokai
if exists("+colorcolumn")  " A vertical line highlighting long lines
    set colorcolumn=80,120
    hi colorcolumn ctermbg=black guibg=#383838
endif

syntax on  " Enable syntax highlighting
set bs=2  " Enable backspace
set mouse=a  " Mouse enabled in all modes
let mapleader = ","
let maplocalleader = "\\"
set noswapfile
set nowrap  " Disable text wrapping
" Wrap toggle on/off
map <leader>w :set wrap!<bar>set wrap?<CR>
set foldmethod=indent  " Folding should apply to indented blocks
set foldlevel=99  " Fold any blocks deeper than 99 when opening file
set number  " Turn on line numbers
" Toggle line numbers and fold column for easy copying
nnoremap <F2> :set nonumber!<CR>
set hlsearch  " Enable search highlighting
" Search highlighting toggle on/off
map <leader>h :set hlsearch!<bar>set hlsearch?<CR>
set ignorecase  " Case-insensitive searches
set showmatch  " Show the matching part of the pair for [] {} and ()
set splitbelow  " Open new buffer below
set splitright  " Open new buffer to the right
" Show tabs as arrows and trailing spaces as dots
set list listchars=tab:→\ ,trail:·
command! NoTrails %s/\s\+$//  " Remove trailing whitespace
" Toggle showing whitespace as listchars
noremap <leader>l :set list!<CR>
set wildignore+=*.o,*.obj,.git,*.pyc,*.sqlite,*.sqlite3,tags  " Generally ignore these file types in file listings.
set completeopt=menu

" Map Alt-L for NerdTree
map <leader>f :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc','env','migrations']

if executable('ag')
    let g:ctrlp_user_command='ag %s --files-with-matches --nocolor --hidden -g ""'
    let g:ctrlp_use_caching=0
endif

let g:pep8_map='<leader>8'  " Validate code against PEP8
" Fuzzy search in code
nmap <leader>a <Esc>:Ack!

function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
map <leader>D :call DeleteHiddenBuffers()<CR>
