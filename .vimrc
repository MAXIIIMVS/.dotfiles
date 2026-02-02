" settings {{{
colorscheme catppuccin " sorbet, habamax, zaibatsu, wildcharm, retrobox, wildcharm, industry
filetype plugin on
syntax enable
set t_Co=256  " Enable 256 colors
set autochdir
set autoindent
set background=dark
set confirm
set clipboard=unnamedplus
set cursorline
set cursorlineopt=both
" set colorcolumn=80
set encoding=utf-8
set expandtab
set fillchars=eob:\ 
set formatoptions-=cro
set guifont=FiraCode\ Nerd\ Font\ Medium
set guitablabel=%t
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set linebreak
set list
set listchars=tab:\ \ ,extends:❯,precedes:❮,nbsp:·,trail:
set magic
set mouse=a
set nocompatible
set noswapfile
set noshowmode
set number
set ruler
set path+=**
set relativenumber
set scrolloff=3
" set spell
set spellcapcheck=''
set showcmd
set showmatch
set showtabline=2
set shiftwidth=4
set smartcase
set smartindent
set splitright
set splitbelow
set tabstop=4
set termguicolors
set title
set ttimeoutlen=0
set wildmenu
set wildoptions=pum
set wildignore=*/node_modules/*,tags,*.o,*/vendor/*,*/build/*,*/external/*,*.obj,*.pyc,*.class,*/.git/*,*/.svn/*
set wildignorecase
" settings }}}

" keymaps {{{
function! MyTermdebug()
  " let current_dir = expand("%:p:h")
  packadd termdebug
  :Termdebug
  :Asm
  :Var
  :Program
  :resize 10
  :Gdb
  :wincmd x
  :Gdb
  call feedkeys("dashboard -enabled off\n", "n")
  call feedkeys("file ", "n")
endfunction

function! RunFromRegister()
  let reg = nr2char(getchar())
  if reg == ''
    return
  endif
  :terminal
  call feedkeys(getreg(reg) . "\<CR>")
endfunction

nnoremap <Tab> <cmd>bn<CR>
nnoremap <S-Tab> <cmd>bp<CR>
nnoremap <space>1 <cmd>tabn 1<CR>
nnoremap <space>2 <cmd>tabn 2<CR>
nnoremap <space>3 <cmd>tabn 3<CR>
nnoremap <space>4 <cmd>tabn 4<CR>
nnoremap <space>5 <cmd>tabn 5<CR>
nnoremap <space>6 <cmd>tabn 6<CR>
nnoremap <space>7 <cmd>tabn 7<CR>
nnoremap <space>8 <cmd>tabn 8<CR>
nnoremap <space>9 <cmd>tabn 9<CR>
tnoremap <ESC> <c-w>N
nnoremap <c-l> <cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>
nnoremap <leader>t :let $CUR_DIR=expand('%:p:h')<CR>:terminal<CR>cd $CUR_DIR<CR>
nnoremap <M-o> o
nnoremap <M-S-o> O
inoremap <M-o> <ESC>o
inoremap <M-S-o> <ESC>O
vnoremap <M-o> <ESC>o
vnoremap <M-S-o> <ESC>O
xnoremap <M-o> <ESC>o
xnoremap <M-S-o> <ESC>O
tnoremap <leader>t exit<CR>
nnoremap <M-t> <cmd>terminal<CR>
tnoremap <M-t> exit<CR>
tnoremap <leader>T <cmd>call ToggleTermColors()<CR>
nnoremap ;b :b 
nnoremap <F4> :call MyTermdebug()<CR>
nnoremap <space>r :call RunFromRegister()<CR>
nnoremap ;f :tabfind 
nnoremap ;F :find 
nnoremap ;e :e 
nnoremap ;t :tabedit 
nnoremap ;g :silent grep -i 
nnoremap ;h :h 
nnoremap ;o <cmd>silent %bd<bar>e#<bar>bd#<CR><bar>'"
nnoremap ;s :s/<c-r><c-w>/<c-r><c-w>/gI<left><left><left>
nnoremap ;S :%s/<c-r><c-w>/<c-r><c-w>/gI<left><left><left>
nnoremap ;n <cmd>silent call ToggleNetrw()<CR>
" nnoremap ;n <cmd>silent call ToggleNetrw()<CR>
nnoremap ;n :call ToggleNetrw() <bar> :sil! /<C-R>=expand("%:t")<CR><CR> :nohlsearch<CR>
nnoremap [B <cmd>bfirst<CR>
nnoremap [b <cmd>bp<CR>
nnoremap ]B <cmd>blast<CR>
nnoremap ]b <cmd>bn<CR>
nnoremap [T <cmd>tabfirst<CR>
nnoremap [t <cmd>tabp<CR>
nnoremap ]T <cmd>tablast<CR>
nnoremap ]t <cmd>tabn<CR>
nnoremap ]q <cmd>cn<CR>
nnoremap [q <cmd>cp<CR>
nnoremap ]Q <cmd>clast<CR>
nnoremap [Q <cmd>cfirst<CR>
nnoremap <c-s> <cmd>silent up<CR>
nnoremap <leader>s <cmd>silent source %<CR>
inoremap <c-s> <ESC><cmd>silent up<CR>
vnoremap <c-s> <ESC><cmd>silent up<CR>
snoremap <c-s> <ESC><cmd>silent up<CR>
execute "set <M-j>=\ej"
nnoremap <M-j> <c-w>j
tnoremap <M-j> <c-w>j
execute "set <M-l>=\el"
nnoremap <M-l> <c-w>l
tnoremap <M-l> <c-w>l
execute "set <M-k>=\ek"
nnoremap <M-k> <c-w>k
tnoremap <M-k> <c-w>k
execute "set <M-h>=\eh"
nnoremap <M-h> <c-w>h
tnoremap <M-h> <c-w>h

function! ToggleTermColors()
    if &termguicolors
        set termguicolors&
    else
        set termguicolors
    endif
endfunction

" search the visually selected text, not required in nvim>0.8
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

function! GitPullVimPlugins()
  " TODO: add other plugin directories too
  let plugin_dir = expand('~/.vim/pack/plugins/start')
  let updated_count = 0
  let skipped_count = 0

  if !isdirectory(plugin_dir)
    echo "Plugin directory does not exist: " . plugin_dir
    return
  endif

  let subdirs = glob(plugin_dir . '/*', 1, 1)
  for subdir in subdirs
    if isdirectory(subdir)
      execute 'silent! lcd ' . fnameescape(subdir)

      if isdirectory('.git')
        let output = system('git pull')
        if output =~# 'Already up to date\|Already up-to-date'
          let skipped_count += 1
          echo "Skipped: " . subdir . " (Already up to date)"
        else
          let updated_count += 1
          echo "Updated: " . subdir
        endif
      else
        let skipped_count += 1
        echo "Skipped: " . subdir . " (Not a Git repository)"
      endif

      execute 'silent! lcd ' . fnameescape(plugin_dir)
    endif
  endfor

  echo "Updated plugins: " . updated_count
  echo "Skipped plugins: " . skipped_count
endfunction

nnoremap <leader>u <cmd>call GitPullVimPlugins()<CR>
" keymaps }}}

autocmd BufRead,BufNewFile *.asm set filetype=asm

" netrw {{{
let g:netrw_banner = 0
let g:netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
let g:netrw_winsize = -40
let g:netrw_browse_split = 4
let g:netrw_fastbrowse = 0
let g:netrw_liststyle = 3

augroup NetrwSettings
  autocmd!
  autocmd WinClosed * if &filetype == 'netrw' | let g:NetrwIsOpen = 0 | endif
augroup END

let g:NetrwIsOpen=0

function! CloseNetrw() abort
  for bufn in range(1, bufnr('$'))
    if bufexists(bufn) && getbufvar(bufn, '&filetype') ==# 'netrw'
      silent! execute 'bwipeout ' . bufn
      if getline(2) =~# '^" Netrw '
        silent! bwipeout
      endif
      let g:NetrwIsOpen=0
      return
    endif
  endfor
endfunction

augroup closeOnOpen
  autocmd!
  autocmd BufWinEnter * if getbufvar(winbufnr(winnr()), "&filetype") != "netrw"|call CloseNetrw()|endif
aug END

function! ToggleNetrw()
    let g:netrw_winsize = -40
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        let @n = expand("%:p:h")
        silent Lexplore %:p:h
    endif
endfunction
" netrw }}}

" autocommands {{{
augroup customize_terminal
    autocmd!
    autocmd BufEnter term://* setlocal nonumber norelativenumber nospell
augroup END

autocmd FileType * set formatoptions-=cro

augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END
" autocommands }}}

" vim-rooter {{{
let g:rooter_silent_chdir= 1
let g:rooter_resolve_links= 1
let g:rooter_cd_cmd = 'lcd'
let g:rooter_change_directory_for_non_project_files = 'current'
" vim-rooter }}}

" statusline {{{
" checkout: https://pastebin.com/qWRQVzES
" statusline }}}

" vim-airline {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
" let g:airline_theme='deus'
let g:airline_powerline_fonts=1
  let g:airline_detect_spell=0
let g:airline_theme='base16_spacemacs'
" let g:airline_theme='base16_snazzy'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
 let g:airline_left_sep = ''
 let g:airline_right_sep = ''
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" let g:airline_theme='base16_gruvbox_dark_hard'
" let g:airline_theme='papercolor'
let g:airline_section_c = '%f'
" }}}

" plugins {{{
" Plugins that I installed using vim packages (:h packages)
" vim-airline  vim-airline-themes  vim-polyglot  vim-rooter  vim-rsi vim-gutentags
" plugins }}}

" gutentags {{{
" let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
" gutentags}}}

" Termdebug {{{
let g:termdebug_wide=1
let g:termdebug_map_K = 0
" Termdebug }}}

" Prefer rg > ag > ack
if executable('rg')
    let g:ackprg = 'rg -S --no-heading --vimgrep'
    set grepprg=rg\ --vimgrep\ $*
elseif executable('ag')
    let g:ackprg = 'ag --vimgrep'
    set grepprg=ag\ --vimgrep\ $*
endif
set grepformat=%f:%l:%c:%m

" gvim {{{
set guioptions-=T  " Disable the toolbar icons
set guioptions-=r  " Disable the right scrollbar
set guioptions-=l  " Disable the left scrollbar
set guioptions-=m  " Disable menu bar
set noerrorbells   " Disable all error bells (audible)
set novisualbell   " Disable the visual bell (screen flash)
set belloff=all
set t_vb=          " Turn off the terminal bell (affects GUI too)
" }}}

" Automatically open Quickfix window if there are errors after :make
augroup auto_open_quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
augroup END
