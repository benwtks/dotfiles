" init.vim @benwtks
"
" TODO: Look into and set up markdown
" TODO: (not vim but) fix zsh autosuggest
" TODO: Set up debugger
" TODO: Add intellisense for C, maybe other c plugins
" TODO: Get a theme that supports treesitter highlighting
" TODO: add shortcut to yiw and <space>sT or <space>sS
" TODO: fix ctrl+h 'no more markers', not sure where from

" Building
" TODO: shortcut to list builds
" TODO: way to name builds, also give more descriptive names automatically
" TODO: remove git s from buildclean, just show rm command for trust
" TODO: add shortcuct to start qemu
" TODO: add gitdiff to build
" TODO: interactive build

" Plugins {{{

" Note, you need to run :PlugInstall the first time to fetch embedded git plugins

filetype off                  " required
call plug#begin('~/.config/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'mileszs/ack.vim'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'edkolev/tmuxline.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'chriskempson/base16-vim'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'simnalamburt/vim-mundo'
Plug 'liuchengxu/vim-which-key'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'yegappan/taglist'
Plug 'rhysd/vim-grammarous'
Plug 'jakewvincent/mkdnflow.nvim'
Plug 'airblade/vim-gitgutter'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'machakann/vim-highlightedyank'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

call plug#end()            " required
filetype plugin indent on    " required

" }}}

" Basics {{{
"
" set up the colour scheme {{{
syntax enable
set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace
set termguicolors
colorscheme base16-tomorrow-night
set encoding=utf8

" Set background to match terminal
highlight Normal ctermbg=none guibg=none
highlight SignColumn ctermbg=none guibg=none
highlight LineNr ctermbg=none guibg=none
highlight Folded ctermbg=none guibg=none
" }}}

" History {{{
set history=1000
set undoreload=1000
set undofile
set undodir=~/dotfiles/nvim/undo
" }}}

" Indentation {{{

" Automatically indent
set autoindent

autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype c setlocal ts=4 sw=4 noexpandtab
autocmd Filetype typescript setlocal ts=2 sw=2 expandtab
autocmd Filetype python setlocal ts=4 sw=4 expandtab
autocmd BufRead,BufNewFile   *.bp setlocal ts=4 sw=4 expandtab
autocmd BufRead,BufNewFile   *.Jenkinsfile setlocal ts=4 sw=4 expandtab
"
" }}}

" Return character {{{
set list
set listchars=eol:¬,tab:»\ 
" }}}

" Line numbers {{{
set relativenumber
set number
" }}}

" Miscellaneous {{{
" Backspace
set backspace=indent,eol,start

" No swp!
set noswapfile

" No annoying bells!
set visualbell

" Show AsyncRun output in new buffer
:let g:asyncrun_open = 8

" Don't let neovim mess with cursor
autocmd VimLeave * set guicursor=n:VER1

" Enable mouse!
set mouse=a

" Split below
set splitbelow

" For vim gutter to be more responsive
set updatetime=50

"}}}

" }}}

" Plugin config {{{

" Airline {{{
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

set laststatus=2
set noshowmode

let g:airline_theme = 'base16_tomorrow'

" let g:airline_right_sep = ''
" let g:airline_left_sep = ''
let g:airline_symbols.branch = ''

let g:airline_left_sep = "\uE0B8 "
let g:airline_right_sep = "\uE0Ba"
let g:airline_left_alt_sep= "\uE0b9 "
let g:airline_right_alt__sep = "\eU0bb"

let g:airline_detect_whitespace=0
let g:airline#extensions#tmuxline#enabled = 0
let g:airline_section_warning = ''
let g:airline_section_error = ''


let g:airline#extensions#taglist#enabled = 0

" }}}

" fzf {{{
set rtp+=/usr/local/opt/fzf
autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
command! -bang ProjectFiles call fzf#vim#files('/work', <bang>0)
command! -bang Dot call fzf#vim#files('~/dotfiles', <bang>0)
command! -bang Arm call fzf#vim#files('~/dotfiles-arm', <bang>0)
command! -bang Notes call fzf#vim#files('~/notes', <bang>0)
command! -bang ArmNotes call fzf#vim#files('~/arm-notes', <bang>0)

function! Bufs()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

command! BufferQuit call fzf#run(fzf#wrap({
  \ 'source': Bufs(),
  \ 'sink*': { lines -> execute('bwipeout '.join(map(lines, {_, line -> split(line)[0]}))) },
  \ 'options': '--multi --bind ctrl-a:select-all+accept'
\ }))

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" }}}

" Devicons {{{
let g:webdevicons_enable = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFileNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let WebDevIconsUnicodeDecorateFolderNodesExactMatches = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ' '
let g:DevIconsDefaultFolderOpenSymbol = ' '
let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['haml'] = ''
" }}}

" NerdTree {{{
" line numbers
let NERDTreeShowLineNumbers=1

" function! StartUp()
" 	" Run NERDTree, and then switch window
" 	NERDTree
" 	:execute "normal \<C-w>\<C-w>"
" endfunction

" Close vim if NERDTree is the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" " Call the StartUp function when vim starts
" autocmd VimEnter * call StartUp()
" }}}

" Taglist {{{

" Leave space for NERDTree and Git blame
let Tlist_Use_Right_Window = 1

" Just makes sense, plus matches NERDTree
let Tlist_GainFocus_On_ToggleOpen = 1

" Less confusing
let Tlist_Show_One_File = 1

" Exit Taglist if nothing else is open
let Tlist_Exit_OnlyWindow = 1

" Quicker
let Tlist_Use_SingleClick = 1

" }}}

" Markdownflow {{{

autocmd FileType markdown inoremap <CR> <Cmd>:MkdnNewListItem<CR>

lua <<EOF
require('mkdnflow').setup({
    perspective = {
        priority = 'root',
        fallback = 'current',
        root_tell = 'index.md',
        nvim_wd_heel = true
    },
    mappings = {
        MkdnEnter = {{'n', 'v'}, '<CR>'},
        MkdnTab = false,
        MkdnSTab = false,
        MkdnNextLink = {'n', '<Tab>'},
        MkdnPrevLink = {'n', '<S-Tab>'},
        MkdnNextHeading = {'n', ']]'},
        MkdnPrevHeading = {'n', '[['},
        MkdnGoBack = {'n', '<BS>'},
        MkdnGoForward = {'n', '<Del>'},
        MkdnFollowLink = false, -- see MkdnEnter
        MkdnDestroyLink = {'n', '<M-CR>'},
        MkdnTagSpan = {'v', '<M-CR>'},
        MkdnMoveSource = {'n', '<F2>'},
        MkdnYankAnchorLink = {'n', 'ya'},
        MkdnYankFileAnchorLink = {'n', 'yfa'},
        MkdnIncreaseHeading = {'n', '+'},
        MkdnDecreaseHeading = {'n', '-'},
        MkdnToggleToDo = {{'n', 'v'}, '<C-Space>'},
        MkdnNewListItem = false,
        MkdnNewListItemBelowInsert = {'n', 'o'},
        MkdnNewListItemAboveInsert = {'n', 'O'},
        MkdnExtendList = false,
        MkdnUpdateNumbering = {'n', '<leader>nn'},
        MkdnTableNextCell = {'i', '<Tab>'},
        MkdnTablePrevCell = {'i', '<S-Tab>'},
        MkdnTableNextRow = false,
        MkdnTablePrevRow = {'i', '<M-CR>'},
        MkdnTableNewRowBelow = {'n', '<leader>ar'},
        MkdnTableNewRowAbove = {'n', '<leader>aR'},
        MkdnTableNewColAfter = {'n', '<leader>ac'},
        MkdnTableNewColBefore = {'n', '<leader>aC'},
        MkdnFoldSection = {'n', '<leader>af'},
        MkdnUnfoldSection = {'n', '<leader>aF'}
    }
})
EOF
" }}}

" Other {{{

let g:coq_settings = { 'auto_start': 'shut-up' }

let g:highlightedyank_highlight_duration = 80
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  hightlight = { enable = true },
  indent = { enable = true }
}
EOF

" }}}

" }}}

" vimrc settings {{{

" .vimrc folding
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END

" Fold with tab
nnoremap <tab> za

" }}}

" Set directory {{{

function! FindRoot()
  let result = system('git rev-parse --show-toplevel')
  if v:shell_error == 0
    return substitute(result, '\n*$', '', 'g')
  endif
  return "."
endfunction

function! ChangeToRoot()
  let root = FindRoot()
  execute 'cd' root
endfunction

autocmd VimEnter * call ChangeToRoot()

set autochdir

" }}}

" Which key {{{

" Set command
let g:mapleader = "\<Space>"
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" By default timeoutlen is 1000 ms
set timeoutlen=500

" Define prefix dictionary
let g:which_key_map =  {
  \ 'n': [':NERDTreeToggle', 'NERDTree toggle'],
  \ 'u': [':MundoToggle', 'Undo tree'],
  \ 'r': [':source $MYVIMRC', 'Reload init.vim'],
  \ 'l': [':Limelight', 'Limelight'],
  \ 'B': [':tabnew | tabm 0 | term zsh -c -i "build"', 'Build'],
  \ 'T': [':TlistToggle', 'Toggle taglist'],
  \ 'c': [':term zsh -c -i "buildclean"', 'Clean builds'],
  \ }

let g:which_key_map.a =  {
  \ 'name': '+notes',
  \ 'p': [':e ~/notes/index.md', 'Personal index.md'],
  \ 'w': [':e ~/arm-notes/index.md', 'Work index.md'],
  \ }

let g:which_key_map.b = {
  \ 'name': '+buffer',
  \ 'p': ['<C-o>', 'Previous buffer'],
  \ 'b': [':Buffers', 'Buffers list'],
  \ 'q': [':b# | bd#', 'Quit buffer'],
  \ 'e': ['<C-w>=', 'Equalise'],
  \ 'h': [':vertical resize -5', 'Decrease width'],
  \ 'k': [':resize +5', 'Increase height'],
  \ 'j': [':resize -5', 'Decrease height'],
  \ 'l': [':vertical resize +5', 'Increase width'],
  \ 'c': [':cclose', 'Close quickfix']
  \ }

let g:which_key_map.o = {
  \ 'name': '+open',
  \ 'o': [':Files', 'File'],
  \ 'h': [':History', 'History'],
  \ 'f': [':GFiles', 'GFile'],
  \ 'p': [':ProjectFiles', 'Project file'],
  \ 'd': [':Dot', 'Dotfiles'],
  \ 'a': [':Arm', 'Arm Dotfiles'],
  \ 'n': [':Notes', 'Notes'],
  \ 'w': [':ArmNotes', 'Arm Notes'],
  \ 'i': [':e $MYVIMRC', 'init.vim'],
  \ 't': [':split | resize 20 | term', 'Terminal (split)'],
  \ 'T': [':tabnew | term', 'Terminal (tab)'],
  \ 'b': [':split | resize 20 | e /work/driver/build.sh', 'build.sh'],
  \ }

map <leader>sT :Tags <C-r>0<CR>
map <leader>sS :GGrep <C-r>0<CR>
map <leader>sL :Lines <C-r>0<CR>
map <leader>sA :Ag <C-r>0<CR>

let g:which_key_map.s = {
  \ 'name': '+search',
  \ ':': [':History:', 'Command history'],
  \ '/': [':History/', 'Search history'],
  \ 't': [':Tags', 'Search tags'],
  \ 'l': [':Lines', 'Search lines in all buffers'],
  \ 's': [':GGrep', 'Git grep'],
  \ 'a': [':Ag', 'Ag (depends on path)'],
  \ }

let g:which_key_map.e = {
  \ 'name': '+edit',
  \ 'w': [':%s/\s\+$//e | ;;', 'Remove trailing whitespace'],
  \ 'm': [':set ma', 'Set modifiable'],
  \ }

let g:which_key_map.g = {
  \ 'name': '+git',
  \ 's': [':G', 'Status'],
  \ 'o': [':GFiles?', 'Open'],
  \ 'c': [':Git commit', 'Commit'],
  \ 'l': [':GV --max-count=70', 'Log'],
  \ 'L': [':Git log', 'Quick log'],
  \ 'f': [':Gdiff', 'File diff'],
  \ 'd': [':G d', 'Diff'],
  \ 'D': [':G ds', 'Staged diff'],
  \ 'b': [':Git blame', 'Blame'],
  \ 'B': [':Git branch', 'Branch'],
  \ 'r': [':G remote', 'Remote'],
  \ 'p': {
    \ 'name': '+push',
    \ 'p': [':Git push origin main', 'main'],
    \ 'P': [':Git push origin master', 'master'],
    \ 'm': [':Git push origin HEAD:refs/for/master', 'HEAD:refs/for/master'],
    \ 't': [':Git push origin HEAD:refs/for/trunk', 'HEAD:refs/for/trunk'],
    \ 'o': [':echo "Work in Progress"', 'HEAD:/refs/for/_____'],
    \ },
  \ 'P': [':Git pull --rebase', 'Pull (rebase)'],
  \ 'n': [':GitGutterNextHunk','Next hunk'],
  \ 'N': [':GitGutterPrevHunk', 'Prev hunk'],
  \ 'u': [':GitGutterUndoHunk', 'Undo hunk'],
  \ 't': [':GitGutterFold', 'Diff fold'],
  \ 'x': [':Commits', 'Search commits in buffer'],
  \ 'X': [':Commits', 'Search commits in all buffers'],
  \ }

let g:which_key_map.p = {
  \ 'name': '+plug',
  \ 'i': [':PlugInstall', 'Install'],
  \ 'u': [':PlugUpdate', 'Update'],
  \ 'c': [':PlugClean', 'Clean'],
  \ 's': [':PlugStatus', 'Status'],
  \ }

let g:which_key_map.t = {
  \ 'name': '+tab',
  \ 't': [':tabs', 'List tabs'],
  \ 'o': [':tabnew', 'Open'],
  \ 'p': [':tabprev', 'Previous'],
  \ 'n': [':tabnext', 'Next'],
  \ '0': [':tabfirst', 'First tab'],
  \ '9': [':tablast', 'Last tab'],
  \ 'q': [':q', 'Quit'],
  \ }



autocmd VimEnter * call which_key#register('<Space>', "g:which_key_map")

"}}}

" Mappings {{{


" Map Esc to exit in Terminal mode
tnoremap <Esc> <C-\><C-n>

" Map a to A
noremap a A

" Map d to _d
xnoremap d _d

" Map ;; to :call clearmatches()
:map ;; :noh<return>

" Disable arrow keys in both normal, and insert modes
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Map - to add new line above current line
:map - O<esc>j

" Map _ to add new line below current line
:map _ o<esc>k

" Map WQ to be the same as wq
:command! WQ wq

" Map Wq to be the same as wq
:command! Wq wq

" Map W to be the same as w
:command! W w

" Map Q to be the same as q
:command! Q q

" Replace word with yank
nnoremap S diw"0P

" press before doing something you don't want to affect yank (e.g. delete 'dd)
noremap ' "_

" }}}
