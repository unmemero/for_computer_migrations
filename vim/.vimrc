" Enable syntax highlighting
syntax on

" Enable mouse support in all modes
set mouse=a

" Show absolute line numbers (no relative lines)
set number
set norelativenumber

" Modern editor defaults
set tabstop=4
set shiftwidth=4
set expandtab
set hlsearch
set incsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set encoding=utf-8
set updatetime=100
set laststatus=2

" --- Plugins (vim-plug) ---
call plug#begin('~/.vim/plugged')
Plug 'tomasiser/vim-code-dark'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" --- Colorscheme & Fonts ---
if has('termguicolors')
  set termguicolors
endif
silent! colorscheme codedark
silent! let g:airline_theme = 'codedark'

" Ensure vim-devicons is loaded for NERDTree
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1

" --- NERDTree Configuration ---
" Toggle NERDTree with Ctrl+b (VSCode sidebar shortcut)
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

" Open NERDTree on start if no file is specified
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif

" Close Vim if NERDTree is the only window left open
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" --- Terminal Mappings ---
" Seamless navigation between splits in terminal mode
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Seamless navigation between splits in normal mode
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Bottom Terminal Toggle Configuration ---
let g:term_buf = 0
let g:term_win = 0

function! ToggleBottomTerminal()
  if g:term_win && win_gotoid(g:term_win)
    hide
    let g:term_win = 0
  else
    botright new
    resize 10
    if g:term_buf && bufexists(g:term_buf)
      buffer g:term_buf
    else
      terminal
      let g:term_buf = bufnr('%')
    endif
    let g:term_win = win_getid()
  endif
endfunction

" Toggle bottom terminal with Ctrl+j or Leader+t
nnoremap <silent> <C-j> :call ToggleBottomTerminal()<CR>
tnoremap <silent> <C-j> <C-\><C-n>:call ToggleBottomTerminal()<CR>
nnoremap <silent> <Leader>t :call ToggleBottomTerminal()<CR>
tnoremap <silent> <Leader>t <C-\><C-n>:call ToggleBottomTerminal()<CR>

" --- VSCode Full Layout Helper ---
function! SetupVSCodeLayout()
  " 1. Close any existing NERDTree and terminals to clean start
  silent! NERDTreeClose
  windo if &buftype == 'terminal' | bdelete! | endif

  " 2. Open NERDTree on the left
  NERDTree
  wincmd l " Return to main editor area

  " 3. Create bottom terminal pane
  botright new
  resize 10
  terminal
  let g:term_buf = bufnr('%')
  let g:term_win = win_getid()
  wincmd k " Return to main editor area

  " 4. Create right Antigravity CLI terminal pane
  vertical rightbelow new
  vertical resize 45
  terminal agy -i
  wincmd h " Return to main editor area (middle pane)
endfunction

" Map Leader+vs to initialize/re-align the VSCode getup
nnoremap <silent> <Leader>vs :call SetupVSCodeLayout()<CR>
