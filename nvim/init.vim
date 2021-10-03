set clipboard=unnamedplus
set mouse=a

" known issues:
" operators dont allow spaces - fixed here https://github.com/tree-sitter/tree-sitter-cpp/issues/110

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

" signature help with lsp
Plug 'ray-x/lsp_signature.nvim'

" lsp default configurations
Plug 'neovim/nvim-lspconfig'

" nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'

call plug#end() " }}}

lua << EOF
require'gitsigns'.setup()

require'cmp'.setup{ -- {{{
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'buffer' },
  },
}

require "lsp_signature".setup()

require'lspconfig'.ccls.setup{
on_attach = function(client, bufnr) -- {{{
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end, -- }}}

-- nvim-cmp
capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
} -- }}}
EOF

" treesitter-highlight {{{
lua << EOF
highlight_setup = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- end on 'syntax' being enabled (like for indentation).
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

" treesitter overall {{{
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = highlight_setup,
  incremental_selection = incremental_selection_setup,
  indent = indent_setup,
}
EOF
" }}}

set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

set shiftwidth=4 tabstop=4 expandtab
au filetype vim set fdm=marker
