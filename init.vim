set number
set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=a
set noswapfile
set encoding=UTF-8
set termguicolors
set clipboard=unnamedplus


call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'ellisonleao/gruvbox.nvim'
Plug 'preservim/nerdtree'
Plug 'tribela/vim-transparent'
Plug 'ryanoasis/vim-devicons'
set encoding=UTF-8
Plug 'ryanoasis/nerd-fonts'
Plug 'olrtg/nvim-emmet'
Plug 'Pocco81/auto-save.nvim'
Plug 'vim-airline/vim-airline'

call plug#end()

colorscheme gruvbox

imap jk <ESC>
nnoremap ,<space> :nohlsearch<CR>
nnoremap <C-i> A<space>#<space>type:<space>ignore<esc>
nnoremap H :tabp<cr>
nnoremap L :tabn<cr>
nnoremap <F3> :source<space>~/.config/nvim/init.vim<cr>
nnoremap <C-b> :NERDTreeToggle<cr>
nnoremap <C-h> :!python3 %<cr>
nnoremap <C-a> ggVG


" Netrw file explorer settings
" let g:netrw_banner = 0 " hide banner above files
" let g:netrw_liststyle = 3 " tree instead of plain view
" let g:netrw_browse_split = 3 " vertical split window when Enter pressed on file

" turn off search highlight

lua << EOF
require("auto-save").setup {
	-- your config goes here
	-- or just leave it empty :)
}
-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
	vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
	-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
	-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
	-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
	-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'vsnip' }, -- For vsnip users.
  -- { name = 'luasnip' }, -- For luasnip users.
  -- { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
}),
matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require'lspconfig'.pyright.setup{
	capabilities = capabilities
}


require'lspconfig'.pyright.setup{}

-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gt", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", {})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF
