filetype plugin indent on

runtime! ftplugin/man.vim
let g:ft_man_folding_enable = 1
let g:ft_man_open_mode = 'vert'
let g:ft_man_no_sect_fallback = 1

call plug#begin('~/.vim/plugged')

Plug 'pangloss/vim-javascript'
Plug 'python-mode/python-mode'
Plug 'iamcco/coc-tailwindcss'

Plug 'dense-analysis/ale'

let g:ale_sign_error = 'e'
let g:ale_sign_warning = 'w'
let g:ale_fix_on_save = 1
let g:ale_fixers = {
        \   'python': ['autopep8', 'yapf'],
        \   'json': ['fixjson', 'prettier'],
        \   'javascript': ['prettier'],
        \   'scss': ['prettier', 'stylelint'],
        \   'css': ['prettier', 'stylelint'],
        \   'html': ['prettier'],
        \   'sh': ['shfmt', 'prettier']
        \}

function! LinterStatus() abort
let l:counts = ale#statusline#Count(bufnr(''))

let l:all_errors = l:counts.error + l:counts.style_error
let l:all_non_errors = l:counts.total - l:all_errors

return l:counts.total == 0 ? 'OK' : printf(
            \   '%dW %dE',
            \   all_non_errors,
            \   all_errors
            \)
endfunction

Plug 'jiangmiao/auto-pairs'

let g:AutoPairsMapSpace = 0
 imap <silent> <expr> <space> pumvisible()
         \ ? "<space>"
         \ : "<c-r>=AutoPairsSpace()<cr>"

Plug 'alvan/vim-closetag'

let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_filetypes = 'html,xhtml,phtml,javascript'

Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }

let g:shfmt_fmt_on_save = 1

Plug 'ojroques/vim-oscyank'

let g:oscyank_term = 'tmux'
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif

Plug 'junegunn/fzf',
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'lifepillar/vim-mucomplete'
Plug 'christoomey/vim-tmux-navigator'
Plug 'sheerun/vim-polyglot'

call plug#end()

syntax on
set t_Co=256

function! MyHighlights() abort
    hi Normal                                  ctermbg=none
    hi GitGutterAdd               ctermfg=2
    hi GitGutterChange            ctermfg=3
    hi GitGutterDelete            ctermfg=1
    hi SignColumn      cterm=bold ctermfg=none ctermbg=none
    hi ALEErrorSign               ctermfg=9
    hi ALEWarningSign             ctermfg=11
    hi LineNr                     ctermfg=8    ctermbg=none
    hi StatusLine      cterm=bold ctermfg=232  ctermbg=8
    hi StatusLineNC    cterm=none ctermfg=250  ctermbg=none
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme apprentice call MyHighlights()
augroup END

colorscheme apprentice

let maplocalleader="\\"

set path=.,**

nnoremap <leader>p :find<space>
nnoremap <C-p> :FZF<cr>
nnoremap <leader>d :lcd %:p:h<cr>
nnoremap <leader>s :pwd<cr>

let g:netrw_banner = 0
let g:netrw_dirhistmax = 0
let g:netrw_fastbrowse = 2
let g:netrw_special_syntax = 1

nnoremap <leader>e :e.<cr>
nnoremap <leader>f :buffers<CR>:buffer<Space>

nnoremap <leader>vr :e $MYVIMRC<cr>
nnoremap <leader>vs :e ~/.dotfiles/.zsh<cr>
nnoremap <leader>bin :e ~/.bin/<cr>

set splitright
nnoremap <leader>v :vsplit<cr>
set splitbelow
nnoremap <leader>o :split<cr>

set mouse=a
set encoding=utf-8
set backspace=indent,eol,start
set clipboard& clipboard^=unnamed,unnamedplus
set fileformats=unix,mac,dos
set number
set relativenumber
set autowrite
set autoread
set report=0
set history=500
set hidden

set nowrap
nnoremap <leader>W :set wrap!<cr>

set noshowcmd
set showmatch
set shortmess+=acI

set complete=.,w,b,u,i,]
set completeopt=longest,menuone,preview

set wildmenu
set wildmode=list:longest,full
set wildignore+=*.git
set wildignore+=*/venv/*
set wildignore+=*/node_modules/*
set wildignore+=*/workers-site/*
set wildignore+=*/public/*
set wildignore+=*/plugged/*
set wildignore+=*/resources/*
set wildignore+=*/undo/*

set ttimeout
set ttimeoutlen=1
set lazyredraw
set scrolloff=999
set scrolljump=-5
set vb t_vb=

set foldlevel=3
set foldlevelstart=0
set foldmethod=marker

set hlsearch
set incsearch
set ignorecase
set smartcase

nnoremap <silent> <leader>x :let @/ = ""<cr>

set laststatus=2
set statusline=
set statusline+=[%n][%t]%m%r%h%w
set statusline+=[%{LinterStatus()}]
set statusline+=%=
set statusline+=[%P][%l:%c/%L][%Y]

set linebreak
set breakindent
set autoindent
set copyindent
set preserveindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smarttab
set expandtab

set noswapfile
set undofile
set undodir^=$HOME/.vim/undo//
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif

set grepprg=ag\ --vimgrep

function! Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

nnoremap <leader>g :Grep<space>

function! CloseWindowOrKillBuffer()
    let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))
    if number_of_windows_to_this_buffer > 1
        wincmd c
    else
        bdelete
    endif
endfunction

nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>
nnoremap <leader>wd :w\|bd<cr>
nnoremap <leader>w :w!<cr>
nnoremap <leader>q :q<cr>

function! StripTrailingWhitespace()
    if &ft  =~  'markdown'
        return
    endif
    %s/\s\+$//e
endfunction

augroup vim_at_start
    au!
    au VimResized * :wincmd =
    au BufWritePre * call StripTrailingWhitespace()
    au BufEnter * syntax sync fromstart
augroup END

augroup lineReturn
    au!

    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   exe "normal! g`\""
                \ | endif

augroup END

nnoremap <right> :vertical resize +3<cr>
nnoremap <left> :vertical resize -3<cr>
nnoremap <down> :resize +3<cr>
nnoremap <up> :resize -3<cr>

nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

nnoremap <leader>nos :setlocal nospell<cr>
nnoremap <leader>pl :setlocal spell spelllang=pl<cr>
nnoremap <leader>en :setlocal spell spelllang=en<cr>
