set clipboard=unnamedplus
set mouse=a
" statusline {{{
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
" }}}

call plug#begin('~/.config/nvim/plugged') " {{{

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
"Plug 'junegunn/vim-easy-align'

" R-lang in vim!
"Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
call plug#end() " }}}

"####################### ALL ###############################################{{{

" better leader
let mapleader="\<Space>"
let maplocalleader=","

" centered cursor
set scrolloff=9999

" wrap on whitespace
set nolist wrap linebreak breakat&vim


" line numbers
set rnu
set nu

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
" }}}
"####################### Jupyter Notebook ##################################{{{
" jupytext to open as .py format
let g:jupytext_fmt = 'py'
let g:jupytext_to_ipynb_opts = '--to=ipynb --update'

" overwrite default configs
let g:jupyter_mapkeys = 0

function! SetJupyterOptions()
	" Run current file
	nnoremap <buffer> <silent> <localleader>R :JupyterRunFile<CR>
	"nnoremap <buffer> <silent> <localleader>I :PythonImportThisFile<CR>

	" Send a selection of lines
	nmap     <buffer> <silent> <localleader>c <Plug>JupyterRunTextObj
	vmap     <buffer> <silent> <localleader>c <Plug>JupyterRunVisual

	" clear the output terminal screen
	nnoremap <buffer> <silent> <localleader>l :norm oprint('\033[2J]')<ESC>:JupyterSendRange<CR>dd

	nnoremap <buffer> <silent> <localleader>U :JupyterUpdateShell<CR>

	" Debugging maps
	nnoremap <buffer> <silent> <localleader>b :PythonSetBreak<CR>
endfunction

call SetJupyterOptions()
" }}}
"####################### R files ###########################################{{{
" fix R indentation
let r_indent_align_args = 0
" R-lang set tab width
autocmd filetype r setlocal tabstop=2 shiftwidth=2

" }}}
"####################### Python Files ######################################{{{

function! ToTTY(call, termkey)
	" echom 'calling "' . a:call . '" in terminal "' . a:termkey . '"'
	" save root of git repo and relative wd
	" if not in repository, run from current location and save nothing to
	" prefix.
	let root = system('git rev-parse --show-toplevel 2>/dev/null || pwd')
	let prefix = system('git rev-parse --show-prefix 2>/dev/null')

	" save tty call (with double quote)
	let ttycall = 'to-tty ' . a:termkey . ' -c "'
	call system('cd ' . root . ';' .
				\ttycall . "echo -e '\n\n\n\n'" . '";' .
				\ttycall . a:call . '";' .
				\'cd "' . prefix . '";' .
				\ttycall . "echo -e '\n\n\n\n'" . '";')
endfunction

function! SetPythonOptions()
	" run all python tests
	 nnoremap <buffer> <silent> <localleader>t :w<CR>
				 \:let $call = 'pytest -v'<CR>
				 \:silent call ToTTY($call, 'i3')<CR>

	 " run current function
	 nnoremap <buffer> <silent> <localleader>T :w<CR>
				 \:silent 0,s/^def\W\+\(\w\+\)/\=setreg('q', submatch(1))/n<CR>
				 \:let $call="pytest -v " . $prefix . expand('%') . "::" . @q<CR>
				 \:call ToTTY($call, 'i3')<CR>

	 " run python file
	 nnoremap <buffer> <silent> <localleader>r :w<CR>
				 \:let $call="python " . expand('%:p')<CR>
				 \:call ToTTY($call, 'i3')<CR>

	 " run previous call
	 nnoremap <buffer> <silent> <localleader>p :w<CR>
				 \:call ToTTY($call, 'i3')<CR>
 endfunction

autocmd filetype python call SetPythonOptions()

" }}}
"####################### Javascript ########################################{{{
" javascript folding
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

" conceal for javascript
let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
"let g:javascript_conceal_underscore_arrow_function = "🞅"
autocmd FileType javascript setlocal conceallevel=1

" }}}
"####################### JSON ##############################################{{{
autocmd FileType json setlocal cole=3
"}}}
"####################### vimscript #########################################{{{
autocmd filetype vim set foldmethod=marker
"}}}
