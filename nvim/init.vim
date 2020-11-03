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
Plug 'davidhalter/jedi-vim'
" Git diffs in margin
Plug 'airblade/vim-gitgutter'

"
" python folding
Plug 'tmhedberg/SimpylFold'

" python docstrings
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }

" jupyter console integration
Plug 'jupyter-vim/jupyter-vim'

" jupyter notebook integration
Plug 'goerz/jupytext.vim'

" surround text objects with quotes, brackets, etc
Plug 'tpope/vim-surround'

" pywal integration with nvim
Plug 'dylanaraps/wal.vim'

" easy alignment of comments, code, etc
Plug 'junegunn/vim-easy-align'

" style guides and syntax errors
Plug 'nvie/vim-flake8'

" R-lang in vim!
"Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
call plug#end()

" enable pywal colorscheme
colorscheme wal

" line numbers
set rnu
set nu

" better leader
let mapleader="\<Space>"
let maplocalleader=","

" centered cursor
set scrolloff=9999

" wrap on whitespace
set nolist wrap linebreak breakat&vim

"#################### ALL ######################################
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

nmap <leader>o :only<CR>

" git diffs in modeline
set updatetime=100

"################### Jupyter Notebook ##########################
" jupytext to open as .py format
let g:jupytext_fmt = 'py'
let g:jupytext_to_ipynb_opts = '--to=ipynb --update'

" overwrite default configs
let g:jupyter_mapkeys = 0

" Run current file
nnoremap <buffer> <silent> <localleader>R :JupyterRunFile<CR>
nnoremap <buffer> <silent> <localleader>I :PythonImportThisFile<CR>

" Change to directory of current file
nnoremap <buffer> <silent> <localleader>d :JupyterCd %:p:h<CR>

" Send a selection of lines
nnoremap <buffer> <silent> <localleader>C :JupyterSendCell<CR>
nnoremap <buffer> <silent> <localleader>. :JupyterSendRange<CR>
nmap     <buffer> <silent> <localleader>c <Plug>JupyterRunTextObj
vmap     <buffer> <silent> <localleader>c <Plug>JupyterRunVisual

" clear the output terminal screen
nnoremap <buffer> <silent> <localleader>l :norm oprint('\033[2J]')<ESC>:JupyterSendRange<CR>dd

nnoremap <buffer> <silent> <localleader>U :JupyterUpdateShell<CR>

" Debugging maps
nnoremap <buffer> <silent> <localleader>b :PythonSetBreak<CR>

"###################### R files ################################
" fix R indentation
let r_indent_align_args = 0
" R-lang set tab width
autocmd filetype r setlocal tabstop=2 shiftwidth=2

"#################### Python Files ############################
" enable deoplete (completion help)
let g:deoplete#enable_at_startup = 1

" enable jedi keybindings (things like code jumping etc)
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 1



