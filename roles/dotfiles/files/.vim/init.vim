" This must be first because it changes other options as a side effect
set nocompatible

" generate help text for plugins
silent! helptags ALL

set background=dark
colorscheme srcery

" For Neovim > 0.1.5 and Vim > patch 7.4.1799 - https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162
" Based on Vim patch 7.4.1770 (`guicolors` option) - https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd
" https://github.com/neovim/neovim/wiki/Following-HEAD#20160511
if (exists('+termguicolors'))
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" lightline stuff
set laststatus=2
let g:lightline = { 'colorscheme': 'srcery_drk' }

filetype plugin on 

" toggle fold level
nnoremap <s-tab> za
" force me to fold
set foldlevelstart=1

set tags=tags;
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set showcmd
set backspace=2

set number

syntax on

" highlight text over 80 chars long
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

set hidden
set colorcolumn=80  " absolute columns to highlight "
"set colorcolumn=+1,+21 " relative (to textwidth) columns to highlight "

" NO TABS!!!
syn match tab display "\t"
hi link tab Error

set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

set number
set magic
set mouse=a
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                    "    case-sensitive otherwise
set hlsearch      " highlight search terms
nmap <silent> <leader><leader> :nohlsearch<CR>
set incsearch     " show search matches as you type
set pastetoggle=<F2>

set t_Co=256

filetype plugin indent on

if has('mouse')
    set mouse=a
endif

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

"vim sign column color same as number col
highlight clear SignColumn

set fo+=ro


let g:clang_auto_select = 1
let g:clang_hl_errors = 1

if has("gui_running")
    set guioptions=egmrt
endif

let mapleader = ","
" remap ; to : so that ;w works
nnoremap ; :

let g:ctrlp_extensions = ['tag', 'line'] " 'funky']
let g:molokai_original = 1

set wildignore=*.swp,*.bak,*.pyc,*.class,*.jar,*.gif,*.png,*.jpg
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': [], 'passive_filetypes': [] }
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
" Use flake8
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_checker_args = '--ignore=E129'
let g:syntastic_check_on_open = 1
"let g:syntastic_cpp_checkers = ['gcc', 'ycm']
let g:syntastic_javascript_checkers = ['jshint']

let g:vim_isort_map = '<C-i>'

" golang
au BufRead,BufNewFile *.go set filetype=go

au FileType go nmap <Leader>i <Plug>(go-info)

au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <Leader>e <Plug>(go-rename)


let g:go_fmt_command = "goimports"

"other
au BufNewFile,BufRead *.jsx set filetype=javascript
au BufNewFile,BufRead *.thrift set filetype=thrift
au BufNewFile,BufRead *.yaml,*.yml set filetype=yaml
au BufNewFile,BufRead *.yaml,*.yml so ~/.config/nvim/pack/dtw/start/yaml.vim/colors/yaml.vim
au BufNewFile,BufRead *.coffee set filetype=coffeescript
au BufNewFile,BufRead *.scss set filetype=scss

autocmd Filetype javascript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype html setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype c setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype ruby setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType python nnoremap <leader>y :0,$!yapf --style='{based_on_style: pep8}'<Cr>
autocmd FileType yaml setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
autocmd Filetype coffeescript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype scss setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
" map <leader>t :!nosetests<cr>
" map <leader>T :!python ./defaults_test.py<cr>

map <c-J> <C-w><C-j>
map <c-K> <C-w><C-k>
map <c-l> <C-w><C-l>
map <c-h> <C-w><C-h>
map <leader>sv :source ~/.vimrc<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FSwitch settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Matches python files that do not end with _test.py
au BufEnter *.py let b:fswitchdst = 'py'
"au BufEnter *\(_test\)\@!.py let b:fswitchlocs = './tests' | let b:fswitchfnames='/$/_test/'
au BufEnter \(test_\)\@!*.py let b:fswitchlocs = './tests' | let b:fswitchfnames='/\v(.*)/\1_test/'
"au BufEnter test_*\.py let b:fswitchlocs = './tests' | let b:fswitchfnames='/.*/test_@!/'
" Matches python files that end with _test.py
au BufEnter *_test.py let b:fswitchlocs = 'reg:/tests//' | let b:fswitchfnames='/_test$//'
" Matches python files that begin with test_
au BufEnter test_*.py let b:fswitchlocs = 'reg:/tests//' | let b:fswitchfnames='/test_//'

nmap <silent> <Leader>of :FSHere<cr>
nmap <silent> <Leader>oL :FSSplitRight<cr>
nmap <silent> <Leader>oH :FSSplitLeft<cr>
nmap <silent> <Leader>oK :FSSplitAbove<cr>
nmap <silent> <Leader>oJ :FSSplitBelow<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMAND T SETTINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:CommandTMaxFiles = 1000000
" let g:CommandTFileScanner = 'watchman'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <expr> %% expand('%:h').'/'
map <leader>e :edit %%
map <leader>v :view %%

let g:pydoc_cmd = 'python -m pydoc' 

" Highlight words to avoid in tech writing
" =======================================
"
" obviously, basically, simply, of course, clearly,
" just, everyone knows, However, So, easy

" http://css-tricks.com/words-avoid-educational-writing/

highlight TechWordsToAvoid ctermbg=red ctermfg=white

" exclamation point will overwrite function definition
" this could hide other functions but prevents redefinition errors on 
" sourcing the vimrc file
function! MatchTechWordsToAvoid()
  match TechWordsToAvoid /\c\<\(obviously\|basically\|simply\|of\scourse\|clearly\|just\|everyone\sknows\|however\|so,\|easy\)\>/
endfunction

autocmd FileType call MatchTechWordsToAvoid()
autocmd BufWinEnter * call MatchTechWordsToAvoid()
autocmd InsertEnter * call MatchTechWordsToAvoid()
autocmd InsertLeave * call MatchTechWordsToAvoid()
autocmd BufWinLeave * call clearmatches()

" Clang format
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>k :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>k :ClangFormat<CR>

" Rustfmt
autocmd FileType rust vnoremap <buffer><Leader>k :!cargo fmt<CR>
autocmd FileType rust nnoremap <buffer><Leader>k :!cargo fmt<CR><CR>

" Racer
let g:racer_cmd = "/Users/dtw/.cargo/bin/racer"
let g:racer_experimental_completer = 1
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | fzf-tmux --height 10 " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

function! FuzzyBuffer()
    redir! >/tmp/vim_buffers
    buffers
    redir END
    redraw!
    call SelectaCommand("cat /tmp/vim_buffers | grep -o '\".*\"' | sed 's/\"//g'", "", ":buffer")
endfunction

function! FuzzyGitStatus()
    let cmd = "/bin/sh -c \"git status -z | tr '\0' '\n' | awk '{print $2}'\""
    call SelectaCommand(cmd, "", ":e")<cr>
endfunction

nnoremap <leader>m :call SelectaCommand("fd -H -I -t f", "", ":e")<cr>
" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>t :call SelectaCommand("fd -H -t f", "", ":e")<cr>
nnoremap <leader>b :call FuzzyBuffer()<cr>
nnoremap <leader>g :call FuzzyGitStatus()<cr>


" Quickfix keybind
nnoremap <Left> :cp<cr>
nnoremap <Right> :cn<cr>
nnoremap <Down> :cnf<cr>
nnoremap <Up> :cpf<cr>

" Linting setup for ALE
let g:ale_linters = {'scala': ['sbtserver']}
let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc

" Vim/Neovim Terminal settings
if has('nvim')
    set scrollback=100000
else
    set termwinscroll=999999
endif

" Neoterm Terminal settings
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <A-h> <C-\><C-N><C-w>h
    tnoremap <A-j> <C-\><C-N><C-w>j
    tnoremap <A-k> <C-\><C-N><C-w>k
    tnoremap <A-l> <C-\><C-N><C-w>l
    inoremap <A-h> <C-\><C-N><C-w>h
    noremap <A-j> <C-\><C-N><C-w>j
    inoremap <A-k> <C-\><C-N><C-w>k
    inoremap <A-l> <C-\><C-N><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
endif

" Neoterm settings and mappings
let g:neoterm_default_mod = 'vertical topleft'
let g:neoterm_autoscroll = 1

vnoremap <Leader>2 :TREPLSendSelection<cr>
nnoremap <Leader>2 :TREPLSendLine<cr>
nnoremap <Leader>0 :Ttoggle<cr>

" nvim-cmp
set completeopt=menu,menuone,noselect

" Initially copied right from the README
lua <<EOF
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
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
  -- cmp.setup.filetype('gitcommit', {
  --   sources = cmp.config.sources({
  --     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  --   }, {
  --     { name = 'buffer' },
  --   })
  -- })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  -- cmp.setup.cmdline(':', {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = cmp.config.sources({
  --     { name = 'path' }
  --   }, {
  --     { name = 'cmdline' }
  --   })
  -- })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require'lspconfig'.metals.setup{}

  require'lspconfig'.rust_analyzer.setup{
    settings = {
      rust = {
        build_on_save = false,
      },
    },
  }
  require'lspconfig'.solargraph.setup{}

EOF
" END nvim-cmp

" LSP bindings
" TODO instead of this maybe do something like 
" https://github.com/neovim/nvim-lspconfig/tree/2c70b7b0095b4bbe55aaf0dc27a2581d1cafe491#keybindings-and-completion
nnoremap <M-CR> :lua vim.lsp.buf.code_action()<CR>
vnoremap <M-CR> :lua vim.lsp.buf.range_code_action()<CR>
nnoremap <leader>K :lua vim.lsp.buf.hover()<CR>
vnoremap <leader>k :lua vim.lsp.buf.range_formatting()<CR>
nnoremap <leader>k :lua vim.lsp.buf.formatting()<CR>
" TODO improve this:
vnoremap <leader>rn :lua vim.lsp.buf.rename('') 
nnoremap gD :lua vim.lsp.buf.declaration()<CR>
nnoremap gd :lua vim.lsp.buf.definition()<CR>
" Not supported by metals / current lsp integration:
" autocmd FileType scala nnoremap gd :lua vim.lsp.buf.type_definition()<CR>
autocmd FileType scala nnoremap gr :lua vim.lsp.buf.references()<CR>
