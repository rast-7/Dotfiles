set shell=zsh

"Configuring Vundle, a package manager
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" List of Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'tpope/vim-commentary'
Plugin 'jiangmiao/auto-pairs'
Plugin 'elixir-lang/vim-elixir'
Plugin 'tomasiser/vim-code-dark'
Plugin 'liuchengxu/space-vim-dark'
Plugin 'joshdick/onedark.vim'
Plugin 'leafgarland/typescript-vim'
call vundle#end()

filetype plugin indent on

" Turn on syntax highlighting
syntax on

" Display line numbers
set nu

"Display relative numbers, makes it easy to figure out how much to jump
set relativenumber

" Shows a bar in the bottom when using tab completion for commands in the command mode, to see the available options conveniently.
set wildmenu

" Shows the cursor's position in bottom right
set ruler

" [DISABLING THIS FOR NOW] Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Press Space to turn off highlighting and clear any message already displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

colorscheme onedark

" 1 TAB = 2 SPACES
set shiftwidth=2 softtabstop=2 expandtab

" Set auto identation. This is does not mean it will fix indentation, it means that when you go the next in line in Insert mode, the indentiation will persist.
set autoindent

" Search text selected in visual mode http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" Highlight trailing spaces,etc
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

" Keep text selected when changing indentation in visual mode using < >
vnoremap < <gv
vnoremap > >gv

" Enable buffer list for vim-airline
let g:airline#extensions#tabline#enabled = 1

" Need to enable this to goto another buffer, without saving the current one.
set hidden

" Cycle/Move across buffers using CTRL + H and CTRL + L
:map <C-L> :bnext<CR>
:map <C-H> :bprevious<CR>

" Open new buffer with CTRL + T
:map <C-T> :enew<CR>

" Close buffer with CTRL + C, (Opens the previous buffer after closing the
" current one, this makes closing work as expected)
:map <C-C> :bp\|bd #<CR>

" Use CtrlP in regex mode by default
let g:ctrlp_regexp = 1

" Makes CtrlP fuzzy searching work more like the one I use in Sublime Text
" Specifically, this will match spaces with underscores
let g:ctrlp_abbrev = {
    \ 'gmode': 't',
    \ 'abbrevs': [
        \ {
        \ 'pattern': ' ',
        \ 'expanded': '.*',
        \ 'mode': 'pfrz',
        \ },
        \ ]
    \ }

" Open NERDTree automatically when starting vim for a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Close NERDTree along with the quickfix window
:map <Leader>c :NERDTreeToggle<CR> <bar> :cclose<CR>

" Disable Line numbers
:map <Leader>q :set norelativenumber<CR> <bar> :set nonumber<CR>

" Enable Line numbers
:map <Leader>w :set number<CR> <bar> :set relativenumber<CR>

" Close Vim if no active buffers are present. (need to close NERDTree manually
" as it is the last window)
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" easytags config:
" Make tagging async
" Tag all the files (instead of the current one) WARNING: Do not open vim in a
" big directory structure ( eg. ~/ )
"let g:easytags_async = 1
"let g:easytags_autorecurse = 1
let g:airline_section_y = "%{gutentags#statusline('Generating Tags Bro......')}"
let g:airline_theme = 'codedark'

let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'

" Time for rg instead of ag, Thanks: https://elliotekj.com/2016/11/22/setup-ctrlp-to-use-ripgrep-in-vim/
" and http://www.wezm.net/technical/2016/09/ripgrep-with-vim/
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m

  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

" bind K to grep for word under cursor
nnoremap K :exe 'Ag' expand('<cword>')<cr>

" bind :Ag to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! "<args>"|cwindow|redraw!

" Auto close quickfix when exiting Vim.
function! s:CloseIfOnlyControlWinLeft()
  if winnr("$") != 1
    return
  endif
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        \ || &buftype == 'quickfix'
    q
  endif
endfunction
augroup CloseIfOnlyControlWinLeft
  au!
  au BufEnter * call s:CloseIfOnlyControlWinLeft()
augroup END

" Run the selected command (make sure .zshenv is a symlink to .zshrc) and
" :set shell=zsh
vnoremap r :'<,'>w !zsh<cr>

" Highlight the column, for ensuring line length is under control
set colorcolumn=100

:autocmd BufNewFile  *.cpp  0r ~/.vim/templates/cpp.cpp

set foldmethod=indent
set foldnestmax=10
set foldlevel=2
