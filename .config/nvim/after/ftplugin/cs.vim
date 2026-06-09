" =========================
" Project detection
" =========================
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function! s:is_godot() abort
  return filereadable(getcwd() . '/project.godot')
endfunction


" =========================
" Build Target Definition
" =========================
function! s:setup_build_targets() abort
  let b:build_cmds = {}

  " Standard Dotnet Targets
  let b:build_cmds['b'] = 'dotnet build'
  let b:build_cmds['c'] = 'dotnet clean'
  let b:build_cmds['f'] = 'dotnet format'
  let b:build_cmds['l'] = 'dotnet list package'
  let b:build_cmds['w'] = 'dotnet watch -q run'
  let b:build_cmds['x'] = 'dotnet run'

  " Godot-specific target (only populated if project.godot is present)
  if s:is_godot()
    let b:build_cmds['g'] = 'godot --headless --path ' . escape(getcwd(), ' ') . ' --build-solutions'
  endif
endfunction


" =========================
" makeprg + errorformat
" =========================
if s:is_godot()
  " Tells the running editor instance to execute the main scene
  setlocal makeprg=godot\ --remote-send\ \"SceneTree.play_main_scene\"
else
  setlocal makeprg=dotnet\ build
endif

" Standard MSBuild / Roslyn error matching pattern
setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m


" =========================
" Init
" =========================
call s:setup_build_targets()
