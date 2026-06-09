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

  if s:is_godot()
    " Remote control bindings for active editor instances
    let b:build_cmds['m'] = 'godot --remote-send "SceneTree.play_main_scene"'
    let b:build_cmds['c'] = 'godot --remote-send "SceneTree.play_current_scene"'
    let b:build_cmds['s'] = 'godot --remote-send "SceneTree.stop"'
    " Cleaned up reload logic (stops execution, waits half a second, then spins it back up)
    let b:build_cmds['r'] = 'godot --remote-send "SceneTree.stop"; sleep 0.5; godot --remote-send "SceneTree.play_main_scene"'
    let b:build_cmds['n'] = 'godot --remote-send "SceneTree.stop"; sleep 0.5; godot --remote-send "SceneTree.play_current_scene"'
    " Standard execution mapping fallback
    let b:build_cmds['x'] = b:build_cmds['m']
    " NEW: Validate/Lint current file headlessly (Great for catching syntax issues early)
    let b:build_cmds['l'] = 'godot --headless --script %:p'
  else
    " Single-file headless script execution fallback (if working outside a project)
    let b:build_cmds['x'] = 'godot --headless --script %:p'
    let b:build_cmds['l'] = 'godot --headless --script %:p'
  endif
endfunction


" =========================
" makeprg + errorformat
" =========================
if s:is_godot()
  setlocal makeprg=godot\ --remote-send\ \"SceneTree.play_main_scene\"
else
  setlocal makeprg=godot\ --headless\ --script\ %:p
endif

" Matches standard Godot engine error lines outputted to the console
setlocal errorformat=SCRIPT\ ERROR:\ %m\ at:\ %f:%l,%f:%l:\ %m


" =========================
" Init
" =========================
call s:setup_build_targets()
