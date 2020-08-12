" Non spacevim setup
set clipboard=unnamedplus
call plug#begin('~/.config/nvim/plugged')
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'tmhedberg/SimpylFold'
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }
Plug 'tpope/vim-surround'
Plug 'dylanrapas/wal.vim'
call plug#end()

let g:deoplete#enable_at_startup = 1
let mapleader=","
set rnu
set nu
set scrolloff=9999






