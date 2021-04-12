syntax on

set hidden
set encoding=utf-8   
set fileencoding=utf-8  
set noerrorbells
set splitbelow
set clipboard=unnamedplus               " Copy paste between vim and everything else
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number relativenumber
set nowrap
set ignorecase
set smartcase
set nobackup
set noswapfile
set nowritebackup
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
set mouse=a
set directory=$HOME/.config/nvim/swap_files//  
" set updatetime=300                      " Faster completion
set timeoutlen=500                      " By default timeoutlen is 1000 ms

au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm 

set colorcolumn=80
" highlight ColorColumn ctermbg=0 guibg=lightgrey


call plug#begin('~/.config/nvim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
" Plug 'lyuts/vim-rtags' " C++ navigation?
Plug 'mbbill/undotree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'liuchengxu/vim-which-key'
Plug 'luochen1990/rainbow'
Plug 'psliwka/vim-smoothie'
Plug 'machakann/vim-highlightedyank'
Plug 'airblade/vim-rooter'
Plug 'vim-airline/vim-airline' 
Plug 'jupyter-vim/jupyter-vim'
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'itchyny/calendar.vim'
" Plug '907th/vim-auto-save'

call plug#end()

source $HOME/.config/nvim/plug-config/highlightyank.vim
source $HOME/.config/nvim/plug-config/vim-commentary.vim
source $HOME/.config/nvim/plug-config/fzf.vim
source $HOME/.config/nvim/plug-config/coc.vim
source $HOME/.config/nvim/plug-config/rainbow.vim
source $HOME/.config/nvim/plug-config/airline.vim
source $HOME/.config/nvim/plug-config/jupyter-vim.vim
source $HOME/.config/nvim/plug-config/vimspector.vim
source $HOME/.config/nvim/plug-config/calendar.vim
source $HOME/.config/nvim/keys/keys.vim
source $HOME/.config/nvim/keys/which-key.vim
source $HOME/.cache/calendar.vim/credentials.vim

colorscheme gruvbox
set background=dark

if executable('rg')
    let g:rg_derive_root='true'
endif

let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_silent = 1  " do not display the auto-save notification


