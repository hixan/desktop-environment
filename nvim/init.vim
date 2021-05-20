set clipboard=unnamedplus
set mouse=a
" statusline {{{
set laststatus=2
set statusline=
set statusline+=%f
set statusline+=\%m
set statusline+=\ %y
set statusline+=\ pos:\ %l,%c
set statusline+=\ %{coc#status()}
"set statusline+=\ %{kite#statusline()}
set statusline+=%=  " switch to the right side
set statusline+=\ lines:\ %L
set statusline+=\ b:\ %n
" }}}

call plug#begin('~/.config/nvim/plugged') " {{{

" python syntax highlighting
"Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" python autocompletion handled by kite
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Git diffs in margin
Plug 'airblade/vim-gitgutter'

" python folding
"Plug 'tmhedberg/SimpylFold'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'

" python pep-8 indentation
Plug 'Vimjas/vim-python-pep8-indent'

" jupyter qtconsole integration
Plug 'jupyter-vim/jupyter-vim'

" jupyter notebook integration
Plug 'goerz/jupytext.vim'

" surround text objects with quotes, brackets, etc
Plug 'tpope/vim-surround'

" easy alignment of comments, code, etc
Plug 'junegunn/vim-easy-align'
" R-lang in vim!
"Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}

" git for vim
Plug 'tpope/vim-fugitive'

" latex in vim
Plug 'lervag/vimtex'

" parameter text objects
Plug 'PeterRincker/vim-argumentative'

" bracked highlighting
Plug 'frazrepo/vim-rainbow'

" gruvbox colorscheme
Plug 'lifepillar/vim-gruvbox8'

" nvim in firefox
Plug 'glacambre/firenvim', {'do': {_ -> firenvim#install(0)}}

call plug#end() " }}}

"####################### ALL ###############################################{{{

" better leader
let mapleader="\<Space>"
let maplocalleader=","

" reload vimrc
nnoremap <silent> <leader>r :so $MYVIMRC<CR>

" gruvbox colorscheme
colorscheme gruvbox8
set background=dark

" rainbow brackets
let g:rainbow_active = 1

" command to send call output to specified tty (termkey)
function! ToTTY(call, termkey) " {{{
	echom 'calling "' . a:call . '" in terminal "' . a:termkey . '"'
	" save root of git repo and relative wd
	" if not in repository, run from current location and save nothing to
	" prefix.
	let root = trim(system('git rev-parse --show-toplevel 2>/dev/null || pwd'))
	let prefix = trim(system('git rev-parse --show-prefix 2>/dev/null'))

	" save tty call (with double quote)
	let ttycall = 'to-tty ' . a:termkey . ' -c '
	let totcall = 'cd "' . root . '";' .
		\'echo -e "\n\u001b[43mBEGIN OUTPUT\u001b[0m\u001b[32;1m ' . a:call . '\u001b[0m"'
		\. '&& ' . a:call . '; ' .
		\'echo -e "\u001b[43mEND OUTPUT\u001b[0m\n";' .
		\'cd "' . prefix . '"'
	call system(ttycall . "'" . totcall . "'")
endfunction " }}}

" run previous call
nnoremap <silent> <localleader>p :w<CR>
			\:silent call ToTTY($call, 'i3')<CR>

" centered cursor
set scrolloff=9999

" wrap on whitespace
set nolist wrap linebreak breakat&vim

" no highlighting
nnoremap <silent> <leader>h :noh<CR>

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
"hi! link SignColumn LineNr

" change folded color (to be different from comments)
hi Folded ctermfg=10
hi Folded ctermbg=2

" easy align
xmap <leader>a <Plug>(EasyAlign)

" tab navigation
nmap <leader>tn :tabNext<CR>
nmap <leader>tp :tabprevious<CR>

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

function! PythonFoldText() " {{{

	let COLUMNWIDTH=80

	let fs = v:foldstart

	" set rv to all decorators (without '@') and line to the first level
	" that is not a decorator.
	let line = getline(fs)
	let rv = ''
	while substitute(line, '^\s*\(.*\)\s*$', '\1', '')[0] == "@"
		" flag for custom return value
		let rv .= ' ' . substitute(line, '^\s*@\(.*\)\>.*$', '\1', '')
		let fs += 1
		let line = getline(fs)
	endwhile

	" check for try/catch blocks
	if substitute(line, getline(fs), '^\s*\(.*\)\s*$', '\1', '')[:4] == 'try:'
		let fs += 1
		let line = substitute(line, getline(fs), '^\(\s*.*\)\s*$', '\1', '') . substitute(getline(fs), '^\s*\(.*\)\s*$', '\1', '')
	end

	" add number of flded lines
	let lnum =  printf('%d', v:foldend - v:foldstart + 1)

	" remove quote comments
	let line = substitute(line, "['".'"]\{3\}', '', '')

	let prefix = ''
	let suffix = rv . ' ' . lnum
	let lpref = len(prefix)
	let lsuff = len(suffix)
	let mlinel = min([COLUMNWIDTH - lpref - lsuff - len(lnum), 60])
	" add next lines until too long
	while len(line) < mlinel && fs < v:foldend
		let fs += 1
		let toadd = substitute(getline(fs), '^\s*\(.*\)\s*$', '\1', '')
		if toadd != ''
			let last = line[len(line)-1]
			if last == ':' || last == ',' 
				let line .= ' ' . toadd
				continue
			end
			if last == '[' || last == '(' || last == '{'
				let line .= toadd
				continue
			else
				let line .= '; ' . toadd
				continue
			end
		end
	endwhile
	let line = line[:mlinel]
	let lline = len(line)
	return prefix . line . repeat(' ', COLUMNWIDTH - lpref - lline - lsuff) . suffix

endfunction " }}}

function! SetPythonOptions() " {{{

	" keybind functions {{{
	function! RunTests()
		return 'pytest -v --doctest-modules --disable-warnings'
	endfunction
	function! RunTestLocal()
		norm 0,s/^def\W\+\(\w\+\)/\=setreg('q', submatch(1))/n
		return 'pytest -v --doctest-modules --disable-warnings '
			\. expand('%') . '::' . @q
	endfunction
	function! RunFile()
		return "python " . expand('%:p')
	endfunction
	function! RunTypeCheck()
		return "mypy --ignore-missing-imports --follow-imports=normal "
			\.expand('%:p')
	endfunction
	" }}}


	" without setting $call {{{
	" run tests
	nmap <buffer> <silent> <localleader>t :w<CR>
		\:silent call ToTTY(RunTests(), 'i3')<CR>

	" run local tests
	nmap <buffer> <silent> <localleader>T :w<CR>
		\:silent call ToTTY(RunTestLocal(), 'i3')<CR>

	" run python file
	nmap <buffer> <silent> <localleader>r :w<CR>
		\:silent call ToTTY(RunFile(), 'i3')<CR>
	
	" run type checking
	nmap <buffer> <silent> <localleader>m :w<CR>
		\:silent call ToTTY(RunTypeCheck(), 'i3')<CR>
	" }}}

	" with setting $call {{{
	" run all python tests
	nmap <buffer> <silent> <localleader>gt :w<CR>
		\:let $call = RunTests()<CR>
		\:call ToTTY($call, 'i3')<CR>

	" run current function
	nmap <buffer> <silent> <localleader>gT :w<CR>
		\:let $call = RunTestLocal()<CR>
		\:call ToTTY($call, 'i3')<CR>

	" run python file
	nmap <buffer> <silent> <localleader>gr :w<CR>
		\:let $call = RunFile()<CR>
		\:call ToTTY($call, 'i3')<CR>

	" run type checking
	nmap <buffer> <silent> <localleader>gm :w<CR>
		\:let $call = RunTypeCheck()<CR>
		\:call ToTTY($call, 'i3')<CR>
	" }}}

	 " highlight 80 column limit
	 setlocal colorcolumn=80

	 " folding from TreeSitter
	 setlocal foldmethod=expr
	 setlocal foldexpr=nvim_treesitter#foldexpr()
	 " my folding function to handle decorators
	 setlocal foldtext=PythonFoldText()
	 " reset folding
	 nnoremap <buffer> <silent> <localleader>x :w<CR>:e<CR>

 endfunction " }}}

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
