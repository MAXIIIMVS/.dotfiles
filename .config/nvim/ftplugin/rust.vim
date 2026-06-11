if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

compiler rustc

function! s:is_project() abort
  return filereadable(getcwd() . '/Cargo.toml')
endfunction

function! s:setup_build_targets() abort
  let b:build_cmds = {}

  if s:is_project()
    let b:build_cmds['b'] = 'cargo build'
    let b:build_cmds['c'] = 'cargo clean'
    let b:build_cmds['d'] = 'cargo build --profile dev'
    let b:build_cmds['r'] = 'cargo build --release'
    let b:build_cmds['t'] = 'cargo test'
    let b:build_cmds['x'] = 'cargo run'
  else
    " Single-file fallback (using rustc)
    let b:build_cmds['b'] = 'rustc -O -o %:p:r %:p'
    let b:build_cmds['c'] = 'rm -f %:p:r'
    let b:build_cmds['x'] = '%:p:r'
  endif
endfunction

if s:is_project()
  setlocal makeprg=cargo\ check
else
  setlocal makeprg=rustc\ --force-warn\ dead_code\ %:p
endif

call s:setup_build_targets()
