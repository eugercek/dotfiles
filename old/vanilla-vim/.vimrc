set nocompatible
filetype off

syntax on

set number
set laststatus=2
set tabstop=4	  		"tab size
set softtabstop=4 "	<- one backspace will go on under t
set smartindent
set autoindent
set shiftwidth=4
set encoding=utf-8
set termguicolors
set t_Co=256
set nowrap
set smartcase
set incsearch
set undodir=~/.vim/undodir
set undofile
set scrolloff=10
set wildmenu
set wildmode=full

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"
