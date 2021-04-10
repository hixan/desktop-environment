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
Plug 'kiteco/vim-plugin'

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

" git for vim
Plug 'tpope/vim-fugitive'

" latex in vim
Plug 'lervag/vimtex'
call plug#end() " }}}

"####################### ALL ###############################################{{{

" command to send call output to specified tty (termkey)
function! ToTTY(call, termkey) " {{{
	echom 'calling "' . a:call . '" in terminal "' . a:termkey . '"'
	" save root of git repo and relative wd
	" if not in repository, run from current location and save nothing to
	" prefix.
	let root = system('git rev-parse --show-toplevel 2>/dev/null || pwd')
	let prefix = system('git rev-parse --show-prefix 2>/dev/null')

	" save tty call (with double quote)
	let ttycall = 'to-tty ' . a:termkey . ' -c "'
	call system('cd ' . root . ';' .
		\ttycall . "echo -e '\n\u001b[43mBEGIN OUTPUT\u001b[0m' && " .
		\a:call . ';' .
		\"echo -e '\u001b[43mEND OUTPUT\u001b[0m\n';" . '";' .
		\'cd "' . prefix . '";')
endfunction " }}}

" better leader
let mapleader="\<Space>"
let maplocalleader=","

 " run previous call
 nnoremap <buffer> <silent> <localleader>p :w<CR>
			 \:call ToTTY($call, 'i3')<CR>

" centered cursor
set scrolloff=9999

" wrap on whitespace
set nolist wrap linebreak breakat&vim

" no highlighting
nnoremap <buffer> <silent> <localleader>h :noh<CR>

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

" next git hunk
nmap <leader>gn <Plug>(GitGutterNextHunk)
nmap <leader>gp <Plug>(GitGutterPrevHunk)
nmap <leader>gg <Plug>(GitGutterPreviewHunk)
nmap <leader>gd <Plug>(GitGutterUndoHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)
let g:gitgutter_preview_win_floating = 0

" git diffs highlight color (same as line number settings)
hi! link SignColumn LineNr

" change folded color (to be different from comments)
hi Folded ctermfg=10
hi Folded ctermbg=2

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
let g:jupytext_to_ipynb_opts = '--to=ipynb' " --update'

" overwrite default configs
let g:jupyter_mapkeys = 0

function! SetJupyterOptions()
	" Run current file
	nnoremap <buffer> <silent> <localleader>R :JupyterRunFile<CR>
	"nnoremap <buffer> <silent> <localleader>I :PythonImportThisFile<CR>

	" Send a selection of lines
	nmap     <buffer> <silent> <localleader>c <Plug>JupyterRunTextObj
	vmap     <buffer> <silent> <localleader>c <Plug>JupyterRunVisual

	" send the current statement (approximately)
	nmap	 <buffer> <silent> <localleader>. :norm mtV%,c<CR><ESC>:norm `t<CR>
	" send the current block of code
	nmap	 <buffer> <silent> <localleader>' :norm mtVip,c<CR><ESC> :norm `t<CR>


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
"
" TODO send buffer to python command instead of saving file and sending file.
" This will support running .ipynb files in jupyter mode.

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
autocmd FileType json set foldmethod=syntax
"}}}
"####################### vimscript #########################################{{{
autocmd filetype vim set foldmethod=marker
"}}}
"####################### Latex #############################################{{{
"nmap <localleader>x :echom GetSelection()<CR>
function! GetSelection()
	" https://stackoverflow.com/a/1534347
	try
		let a_save = @a
		normal! gv"ay
		return @a
	finally
		let @a = a_save
	endtry
endfunction

function! SetLatexOptions()
	let g:vimtex_view_method='zathura'
	let g:vimtex_quickfix_mode=0
	set conceallevel=2
	let g:tex_conceal='abdmg'
endfunction
autocmd filetype tex,latex call SetLatexOptions()
"}}}
