if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Compiler/Runtime detection
if executable('luajit')
  let s:lua_exec = 'luajit'
else
  let s:lua_exec = 'lua'
endif

function! s:setup_build_targets() abort
  let b:build_cmds = {}
  " Lua files are typically interpreted directly
  let b:build_cmds['b'] = s:lua_exec . ' -b %:p %:p:r.out' " Bytecode compilation
  let b:build_cmds['c'] = 'rm -f %:p:r.out'
  let b:build_cmds['x'] = s:lua_exec . ' %:p'
endfunction

let &l:makeprg = s:lua_exec . ' %:p'
setlocal errorformat=%*[^:]:\ %f:%l:\ %m

call s:setup_build_targets()
