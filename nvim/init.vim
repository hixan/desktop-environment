set clipboard=unnamedplus
set mouse=a

call plug#begin('~/.config/nvim/plugged') " {{{
" Git diffs in margin
Plug 'nvim-lua/plenary.nvim' " MIT license
Plug 'lewis6991/gitsigns.nvim' " MIT license

" tim popes awesome plugins " all are licensed the same as vim
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

" easy alignment of comments, code, etc
Plug 'junegunn/vim-easy-align'

call plug#end() " }}}

lua << EOF
require'gitsigns'.setup()
EOF


