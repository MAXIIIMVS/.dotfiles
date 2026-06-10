if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" TSX targets closely mirror TypeScript but emphasize web bundler tasks
function! s:setup_build_targets() abort
  let b:build_cmds = {}
 
  let b:build_cmds['b'] = 'npm run build'
  let b:build_cmds['t'] = 'npm run test'
  let b:build_cmds['x'] = 'npm run dev' " Common for Vite / Next.js / CRA
endfunction

if executable('tsc')
  setlocal makeprg=tsc\ --noEmit
endif
setlocal errorformat=%f(%l,%c):\ error\ TS%n:\ %m

call s:setup_build_targets()
