call pathogen#runtime_append_all_bundles()
call pathogen#infect()
call pathogen#helptags()

syntax on
set guifont=menlo_for_powerline:h10
set linespace=4

colorscheme solarized
let g:solarized_style="dark"
let g:solarized_contrast="high"
set background=dark

if has('gui_running')
	set guioptions=egmrt
	set guioptions-=r
	set guioptions-=L
else
	let g:solarized_termcolors=256
endif

filetype on
filetype plugin indent on

set nocompatible
set modelines=0

set tabstop=2
set shiftwidth=2
set softtabstop=2
set noexpandtab
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set undofile

let mapleader=","

nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
nnoremap <tab> %

set wrap
set formatoptions=qrn1

set list
set listchars=tab:›\ ,trail:·,eol:↴

nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

nnoremap ; :

inoremap jj <ESC>

nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

autocmd vimenter * NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let NERDTreeShowHidden=1
let g:Powerline_symbols='fancy'

" Use soft tabs for the following
autocmd bufnewfile,bufread *.rb,[rR]akefile,*.rake set expandtab
