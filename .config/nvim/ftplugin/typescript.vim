if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function! s:has_package_json() abort
  return filereadable(getcwd() . '/package.json')
endfunction

function! s:setup_build_targets() abort
  let b:build_cmds = {}

  if s:has_package_json()
    let b:build_cmds['b'] = 'npm run build'
    let b:build_cmds['t'] = 'npm test'
    let b:build_cmds['x'] = 'npm start'
  else
    " Single-file fallback using ts-node or deno if available
    if executable('ts-node')
      let b:build_cmds['x'] = 'ts-node %:p'
    elseif executable('deno')
      let b:build_cmds['x'] = 'deno run %:p'
    else
      let b:build_cmds['b'] = 'tsc %:p'
      let b:build_cmds['x'] = 'tsc %:p && node %:p:r.js'
      let b:build_cmds['c'] = 'rm -f %:p:r.js'
    endif
  endif
endfunction

if executable('tsc')
  setlocal makeprg=tsc\ --noEmit
endif
setlocal errorformat=%f(%l,%c):\ error\ TS%n:\ %m

call s:setup_build_targets()
