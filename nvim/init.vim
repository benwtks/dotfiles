" init.vim @benwtks
"
" TODO: Look into and set up markdown
" TODO: Setup limelight
" TODO: Set up presentation plugin
" TODO: Set up tags
" TODO: Set up debugger
" TODO: Set up git grep shortcut
" TODO: Set up search for file from selected - make links from build errors
" TODO: Easier shortcut for / search from word under cursor
" TODO: Change build.sh to execute outside of docker. Instead of opening
" docker and then cd'ing, running build.sh, we can run build.sh and it'll do
" all of that and run docker with the command it was going to do before. Once
" this is done, we can add a shortcut to execute this from vim and have it
" open the output in a new split. With the above tasks, we can then easily
" open files and search for functions from the output in vim.

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
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'yegappan/taglist'
Plug 'rhysd/vim-grammarous'
Plug 'jakewvincent/mkdnflow.nvim'
Plug 'junegunn/limelight.vim'
Plug 'airblade/vim-gitgutter'


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

" Set indentation to 4 space tab for html and css
" autocmd Filetype html setlocal ts=4 sw=4 noexpandtab
" autocmd Filetype css setlocal ts=4 sw=4 noexpandtab

" Automatically indent
set autoindent

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


" }}}

" fzf {{{
set rtp+=/usr/local/opt/fzf
autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
command! -bang ProjectFiles call fzf#vim#files('~', <bang>0)
command! -bang Dot call fzf#vim#files('~/dotfiles', <bang>0)

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

" Limelight {{{

" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" Default: 0.5
let g:limelight_default_coefficient = 0.7

" Number of preceding/following paragraphs to include (default: 0)
let g:limelight_paragraph_span = 0

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
  \ 'h': [':History', 'History'],
  \ 'n': [':NERDTreeToggle', 'NERDTree toggle'],
  \ 'u': [':MundoToggle', 'Undo tree'],
  \ 'r': [':source $MYVIMRC', 'Reload init.vim']
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
  \ 'i': [':e $MYVIMRC', 'init.vim'],
  \ 't': [':split | resize 20 | term', 'Terminal'],
  \ }

let g:which_key_map.e = {
  \ 'name': '+edit',
  \ 'w': [':%s/\s\+$//e | ;;', 'Remove trailing whitespace'],
  \ 'm': [':set ma', 'Set modifiable'],
  \ 'l': [':Limelight', 'Limelight'],
  \ 's': [':BLines', 'Search lines'],
  \ 'S': [':Lines', 'Search lines in all buffers'],
  \ 't': [':Tags', 'Search tags'],
  \ 'T': [':BTags', 'Search tags in all buffer'],
  \ 'h': [':History:', 'Command history'],
  \ 'H': [':History/', 'Search history'],
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
    \ 'm': [':Git push origin HEAD:/refs/for/master', 'HEAD:/refs/for/master'],
    \ 't': [':Git push origin HEAD:/refs/for/trunk', 'HEAD:/refs/for/trunk'],
    \ 'o': [':echo "Work in Progress"', 'HEAD:/refs/for/_____'],
    \ },
  \ 'P': [':Git pull', 'Push'],
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