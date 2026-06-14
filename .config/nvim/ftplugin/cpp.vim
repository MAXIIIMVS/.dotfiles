" =========================
" Project detection
" =========================
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function! s:is_cmake() abort
  return filereadable(getcwd() . '/CMakeLists.txt')
endfunction

function! s:is_make() abort
  return filereadable(getcwd() . '/Makefile') || filereadable(getcwd() . '/makefile')
endfunction


" =========================
" Compiler detection
" =========================
if executable('g++-14')
  let s:cxx = 'g++-14'
elseif executable('g++')
  let s:cxx = 'g++'
else
  echoerr 'No g++ compiler found in PATH'
  finish
endif


" =========================
" Build Target Definition
" =========================
function! s:setup_build_targets() abort
  let b:build_cmds = {}

  if s:is_cmake()
    let b:build_cmds['b'] = 'cmake --build ./build'
    let b:build_cmds['c'] = 'cmake --build ./build -t clean'
    let b:build_cmds['f'] = 'cmake --build ./build --clean-first'
    let b:build_cmds['d'] = 'cmake -S . -B ./build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
    let b:build_cmds['i'] = 'cmake --install ./build'
    let b:build_cmds['r'] = 'cmake -S . -B ./build_release -G Ninja -DCMAKE_BUILD_TYPE=Release'
    let b:build_cmds['t'] = 'cd ./build && ctest --schedule-random --output-on-failure && cd - > /dev/null 2>&1'
    let b:build_cmds['v'] = 'cd ./build && valgrind ./main && cd - > /dev/null 2>&1'
    let b:build_cmds['x'] = 'cd ./build && ./main; ret=$?; cd - > /dev/null 2>&1; (exit $ret)'

  elseif s:is_make()
    let b:build_cmds['b'] = 'make'
    let b:build_cmds['c'] = 'make clean'
    let b:build_cmds['f'] = 'make clean && make'
    let b:build_cmds['d'] = 'make DEBUG=1'
    let b:build_cmds['i'] = 'make install'
    let b:build_cmds['r'] = 'make RELEASE=1'
    let b:build_cmds['t'] = 'make test'
    let b:build_cmds['v'] = 'valgrind ./main'
    let b:build_cmds['x'] = 'make run'

  else
    " Single-file fallback
    let b:build_cmds['b'] = s:cxx . ' -ggdb3 -Wall -Werror -Wpedantic -Wextra -Wsign-conversion -std=c++23 -o %:p:r.out %:p'
    let b:build_cmds['c'] = 'rm -f %:p:r.out'
    let b:build_cmds['f'] = ''
    let b:build_cmds['d'] = ''
    let b:build_cmds['i'] = ''
    let b:build_cmds['r'] = ''
    let b:build_cmds['t'] = ''
    let b:build_cmds['v'] = 'valgrind %:p:r.out'
    let b:build_cmds['x'] = '%:p:r.out'
  endif
endfunction


" =========================
" makeprg + errorformat
" =========================
if s:is_cmake()
  setlocal makeprg=cmake\ --build\ build
elseif s:is_make()
  setlocal makeprg=make
else
  let &l:makeprg = s:cxx . ' -ggdb3 -Wall -Werror -Wpedantic -Wextra -Wsign-conversion -std=c++23 -o %:p:r.out %:p'
endif

setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m


" =========================
" Init
" =========================
call s:setup_build_targets()
