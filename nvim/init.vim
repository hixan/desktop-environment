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

" treesitter-highlight {{{
lua << EOF
highlight_setup = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
}
EOF
" }}}

" treesitter-incremental-selection {{{
lua << EOF
incremental_selection_setup = {
  enable = true,
  keymaps = {
    init_selection = "gn",
    node_incremental = "g=",
    scope_incremental = "g+",
    node_decremental = "g-",
  },
}
EOF
" }}}

" treesitter-indent {{{
lua << EOF
indent_setup = {
  enable = true,
}
EOF
" }}}

" custom folding query for cpp {{{
lua << EOF
vim.treesitter.set_query("cpp", "folds", [[
    (function_definition) @fold
]])
EOF
" }}}

lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = highlight_setup,
  incremental_selection = incremental_selection_setup,
  indent = indent_setup,
}

EOF

set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

set shiftwidth=4 tabstop=4 expandtab

au filetype vim set fdm=marker
