-- [[ init.lua ]]

require("plugins").setup() -- Plugins

vim.cmd [[
" need 'lyokha/vim-xkbswitch' installed
" mac use vim-xkbswitch enable
if has('mac')
    let g:XkbSwitchEnabled = 1
    autocmd BufEnter * let b:XkbSwitchILayout = 'us'
endif

" -------------------------------------------------------------------------------------------------
" vimspector debuger settings
" -------------------------------------------------------------------------------------------------
let g:vimspector_enable_mappings = 'HUMAN'
" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

]]
