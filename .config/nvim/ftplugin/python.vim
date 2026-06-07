if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Virtual environment or binary probe
if executable('venv/bin/python')
  let s:py_exec = 'venv/bin/python'
elseif executable('python3')
  let s:py_exec = 'python3'
else
  let s:py_exec = 'python'
endif

function! s:setup_build_targets() abort
  let b:build_cmds = {}
  
  let b:build_cmds['b'] = s:py_exec . ' -m compileall %:p'
  let b:build_cmds['t'] = s:py_exec . ' -m pytest'
  let b:build_cmds['x'] = s:py_exec . ' %:p'
endfunction

let &l:makeprg = s:py_exec . ' -m py_compile %:p'
setlocal errorformat=%*\\sFile\ \"%f\"\\,\ line\ %l\\,\ %m

call s:setup_build_targets()
