set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim


call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'git://git.wincent.com/command-t.git'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}


Plug 'ycm-core/YouCompleteMe'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'jiangmiao/auto-pairs'
Plug '907th/vim-auto-save'
Plug 'tpope/vim-commentary'
Plug 'christoomey/vim-system-copy'
Plug 'mbbill/undotree'
Plug 'vim-syntastic/syntastic'
Plug 'frazrepo/vim-rainbow'
Plug 'easymotion/vim-easymotion'
"Plug 'bronson/vim-trailing-whitespace'
Plug 'wadackel/vim-dogrun'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'
Plug 'puremourning/vimspector'

Plug 'morhetz/gruvbox'
call plug#end()


syntax on

set relativenumber
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
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set wildmenu
set wildmode=full

colorscheme onehalfdark

hi Normal guibg=NONE
"hi Normal guibg=NONE ctermbg=NONE
let g:lightline={'colorscheme':'onehalfdark'}
let g:rainbow_active= 1
let g:auto_save = 0
let g:auto_save_in_insert_mode = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:ycm_show_diagnostics_ui = 0  "Yoksa YCM syntax checkeri bozuyo

let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let  mapleader=" "


map <F8> :w <CR> :!gcc % -o %< && clear && ./%< <CR>
map <C-n> :NERDTreeToggle<CR>
nnoremap <F5> :UndotreeToggle<cr>
nnoremap <leader>m :update <CR>:!make<CR>
inoremap <C-Y> <Esc>klyiwjPa
nnoremap <C-Y> <Esc>klyiwjPa<ESC>
