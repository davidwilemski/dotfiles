" This must be first because it changes other options as a side effect
set nocompatible

set background=dark
colorscheme solarized
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
nmap <silent> <leader>/ :nohlsearch<CR>
nmap <silent> <ENTER> :nohlsearch<CR>
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

let g:neocomplete#enable_at_startup = 1


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

autocmd Filetype javascript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype html setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype c setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype ruby setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType python nnoremap <leader>y :0,$!yapf --style='{based_on_style: pep8}'<Cr>

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
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>t :call SelectaCommand("find * -type file ! -iname '*.pyc' ! -iname '*.swo' ! -iname '*.swp'", "", ":e")<cr>
