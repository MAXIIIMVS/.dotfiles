" =========================
" Project detection
" =========================
if exists("b:did_go_ftplugin")
  finish
endif
let b:did_go_ftplugin = 1

let s:dir = expand('%:p:h')

function! s:is_make()
  return filereadable(s:dir . '/Makefile') || filereadable(s:dir . '/makefile')
endfunction


" =========================
" Compiler detection
" =========================
if !executable('go')
  echoerr 'No Go compiler found in PATH'
  finish
endif

" =========================
" Build registers
" =========================
function! s:setup_build_registers()
  if s:is_make()
    let @a='make audit'
    let @b='make build'
    let @d='make debug'
    let @h='go help'
    let @t='make test'
    let @v='make vendor'
    let @x='make run'
  else
    " Single-file fallback
    let @a=''
    let @b = 'go build -o %:r %:r.go '
    let @d=''
    let @h=''
    let @t=''
    let @v=''
    let @x = 'go run %'
  endif
endfunction


" =========================
" makeprg + errorformat
" =========================
if s:is_make()
  setlocal makeprg=make
else
  let &l:makeprg = 'go build -o %:r %:r.go '
endif

setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m


" =========================
" Init
" =========================
call s:setup_build_registers()
