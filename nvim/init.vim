" Non spacevim setup
set clipboard=unnamedplus
call plug#begin('~/.config/nvim/plugged')
"
" python syntax highlighting
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
"
" python autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
"
" python folding
Plug 'tmhedberg/SimpylFold'
"
" python docstrings
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }
"
" surround text objects with quotes, brackets, etc
Plug 'tpope/vim-surround'

" pywal integration with nvim
Plug 'dylanaraps/wal.vim'

" easy alignment of comments, code, etc
Plug 'junegunn/vim-easy-align'

" jupyter notebook integration
Plug 'goerz/jupytext.vim'
call plug#end()

" jupytext to open as .py format
let g:jupytext_fmt = 'py'

" enable pywal colorscheme
colorscheme wal

" enable deoplete
let g:deoplete#enable_at_startup = 1

" better leader
let mapleader=","

" line numbers
set rnu
set nu

" centered cursor
set scrolloff=9999

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


