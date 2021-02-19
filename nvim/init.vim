set clipboard=unnamedplus
set mouse=a
" statusline
" statusline
set laststatus=2
set statusline=
set statusline+=%f
set statusline+=\%m
set statusline+=\ %y
set statusline+=\ pos:\ %l,%c
"set statusline+=\ %{coc#status()}
set statusline+=\ %{kite#statusline()}
set statusline+=%=  " switch to the right side
set statusline+=\ lines:\ %L
set statusline+=\ b:\ %n

call plug#begin('~/.config/nvim/plugged')

" python syntax highlighting
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" python autocompletion handled by kite

" Git diffs in margin
Plug 'airblade/vim-gitgutter'

" python folding
Plug 'tmhedberg/SimpylFold'

" jupyter qtconsole integration
Plug 'jupyter-vim/jupyter-vim'

" jupyter notebook integration
Plug 'goerz/jupytext.vim'

" surround text objects with quotes, brackets, etc
Plug 'tpope/vim-surround'

" easy alignment of comments, code, etc
Plug 'junegunn/vim-easy-align'

" style guides and syntax errors
Plug 'nvie/vim-flake8'

" R-lang in vim!
"Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
call plug#end()

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
" git diffs highlight color (same as line number settings)
hi! link SignColumn LineNr
" change folded color (to be different from comments)
hi Folded ctermfg=1
hi Folded ctermbg=4

" kite settings
set completeopt+=menuone   " Show the completions UI even with only 1 item
set completeopt-=preview   " Show the documentation preview window
set completeopt+=longest   " Insert the longest common text
set completeopt-=noinsert  " Don't insert text automatically
set completeopt+=noselect  " Don't highlight the first completion automatically

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

" run all python tests
 autocmd filetype python nnoremap <buffer> <silent> <localleader>t :w<CR> :silent !
			 \a=$(pwd);
			 \cd $(git rev-parse --show-toplevel);
			 \to_tty -i i3 -c "echo -e '\n\n\n\n'; pytest -v";
			 \cd $a<CR>
 " save working directory
 " go to git repository root
 " use to_tty to run the test suite and output to the target tty
 " change back to the original wd
 
 " run current function
 autocmd filetype python nnoremap <buffer> <silent> <localleader>T :w<CR> 
			 \:0,s/def\W\+\(.*\)\>/\=setreg('q', submatch(1))/n<CR>
			 \:let $function=@q<CR>
			 \:silent !
			 \prefix=$(git rev-parse --show-prefix);
			 \filename="$prefix"%;
			 \cd $(git rev-parse --show-toplevel);
			 \to_tty -i i3 -c "echo -e '\n\n\n\n'; pytest -v $filename::$function";
			 \cd $prefix<CR>
 " explanation:
 " find previous match for the regex and set group 1 to be in the q register
 " export that to the environment variable $function
 " start silent execution of an external command
 " save current relative path
 " set the filename to be the relative path and the current file name
 " cd to the root of the git repo
 " run the pytest function and send to tty
 " cd back to the saved location

 " run python file
 autocmd filetype python nnoremap <buffer> <silent> <localleader>r :w<CR> :silent !
			 \to_tty -i i3 -c "python %"
			 \<CR>

"###################### Javascript #############################
" javascript folding
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

" conceal for javascript
let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
"let g:javascript_conceal_underscore_arrow_function = "🞅"

set conceallevel=1
