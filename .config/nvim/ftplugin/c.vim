" =========================
" Project detection
" =========================
let s:dir = expand('%:p:h')

function! s:is_cmake()
  return filereadable(s:dir . '/CMakeLists.txt')
endfunction

function! s:is_make()
  return filereadable(s:dir . '/Makefile') || filereadable(s:dir . '/makefile')
endfunction


" =========================
" Build registers
" =========================
function! s:setup_build_registers()
  if s:is_cmake()
    let @b = 'cmake --build ./build'
    let @c = 'cmake --build ./build -t clean'
    let @f = 'cmake --build ./build --clean-first'
    let @d = 'cmake -S . -B ./build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_TOOLCHAIN_FILE=external/vcpkg/scripts/buildsystems/vcpkg.cmake'
    let @i = 'cmake --install ./build'
    let @r = 'cmake -S . -B ./build_release -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=external/vcpkg/scripts/buildsystems/vcpkg.cmake'
    let @t = 'cd ./build && ctest --schedule-random --output-on-failure && cd - > /dev/null 2>&1'
    let @v = 'cd ./build && valgrind ./main && cd - > /dev/null 2>&1'
    let @x = 'cd ./build && ./main; ret=$?; cd - > /dev/null 2>&1; (exit $ret)'

  elseif s:is_make()
    let @b = 'make'
    let @c = 'make clean'
    let @f = 'make clean && make'
    let @d = 'make DEBUG=1'
    let @i = 'make install'
    let @r = 'make RELEASE=1'
    let @t = 'make test'
    let @v = 'valgrind ./main'
    let @x = 'make run'

  else
    " Single-file fallback
    let @b = 'gcc -ggdb3 -Wall -Werror -Wpedantic -Wextra -Wsign-conversion -o %:r.out %'
    let @c = ''
    let @f = ''
    let @d = ''
    let @i = ''
    let @r = ''
    let @t = ''
    let @v = 'valgrind ./%:r.out'
    let @x = './%:r.out'
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
  setlocal makeprg=gcc\ -ggdb3\ -Wall\ -Werror\ -Wpedantic\ -Wextra\ -Wsign-conversion\ -o\ %:r.out\ %
endif

setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m


" =========================
" Init
" =========================
call s:setup_build_registers()
