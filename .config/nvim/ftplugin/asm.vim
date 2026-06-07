if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function! s:is_make() abort
  return filereadable(getcwd() . '/Makefile') || filereadable(getcwd() . '/makefile')
endfunction

function! s:setup_build_targets() abort
  let b:build_cmds = {}

  if s:is_make()
    let b:build_cmds['b'] = 'make'
    let b:build_cmds['c'] = 'make clean'
    let b:build_cmds['x'] = 'make run'
  else
    " Single-file ELF64 compilation using NASM and LD layout
    if executable('nasm')
      let b:build_cmds['b'] = 'nasm -f elf64 -g -F dwarf %:p -o %:p:r.o && ld %:p:r.o -o %:p:r.out'
    else
      " GNU Assembler Fallback
      let b:build_cmds['b'] = 'as --64 -g %:p -o %:p:r.o && ld %:p:r.o -o %:p:r.out'
    endif
    let b:build_cmds['c'] = 'rm -f %:p:r.o %:p:r.out'
    let b:build_cmds['v'] = 'valgrind %:p:r.out'
    let b:build_cmds['x'] = '%:p:r.out'
  endif
endfunction

if s:is_make()
  setlocal makeprg=make
else
  setlocal makeprg=nasm\ -f\ elf64\ %:p
endif

call s:setup_build_targets()
