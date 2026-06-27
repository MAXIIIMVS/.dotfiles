if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function! s:is_make() abort
  return filereadable(getcwd() . '/Makefile') || filereadable(getcwd() . '/makefile')
endfunction

function! s:is_go_mod() abort
  return filereadable(getcwd() . '/go.mod')
endfunction

function! s:setup_build_targets() abort
  let b:build_cmds = {}

  if s:is_make()
    " Use Makefile configurations if present
    let b:build_cmds['b'] = 'make'
    let b:build_cmds['c'] = 'make clean'
    let b:build_cmds['t'] = 'make test'
    let b:build_cmds['x'] = 'make run'
  elseif s:is_go_mod()
    " Standard Go module project
    let b:build_cmds['b'] = 'go build -gcflags=all="-N -l" ./...'
    let b:build_cmds['c'] = 'go clean'
    let b:build_cmds['t'] = 'go test ./...'
    let b:build_cmds['x'] = 'go run .'
  else
    " Single-file fallback
    let b:build_cmds['b'] = 'go build -gcflags=all="-N -l" -o %:p:r %:p'
    let b:build_cmds['c'] = 'rm -f %:p:r'
    let b:build_cmds['x'] = 'go run %:p'
  endif
endfunction

" Set local compiler program for quickfix window parsing
if s:is_make()
  setlocal makeprg=make
elseif s:is_go_mod()
  setlocal makeprg=go\ build\ -gcflags=all=\"-N\ -l\"\ ./...
else
  setlocal makeprg=go\ build\ -gcflags=all=\"-N\ -l\"\ -o\ %:p:r\ %:p
endif

setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m

call s:setup_build_targets()
