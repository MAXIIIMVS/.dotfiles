let @a='make audit'
let @b='make build'
let @d='make debug'
let @h='go help'
let @t='make test'
let @v='make vendor'
let @x='make run'

if filereadable("Makefile")
  setlocal makeprg=make\ build
else
  let &l:makeprg = 'GOMOD=off go build -o ' . expand('%:r') . ' ' . expand('%')
endif
setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m
