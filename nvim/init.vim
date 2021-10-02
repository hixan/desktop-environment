set clipboard=unnamedplus
set mouse=a

call plug#begin('~/.config/nvim/plugged') " {{{
" python folding
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'

" surround text objects with quotes, brackets, etc
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-fugative'
" easy alignment of comments, code, etc
" Plug 'junegunn/vim-easy-align'
call plug#end() " }}}

au filetype vim set fdm=marker
