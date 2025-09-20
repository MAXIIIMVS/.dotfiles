" let @m='godot --remote-send "SceneTree.play_main_scene"'
" let @c='godot --remote-send "SceneTree.play_current_scene"'
" let @s='godot --remote-send "SceneTree.stop"'
" let @r='godot --remote-send "SceneTree.stop" && sleep 0.3 && godot --remote-send "SceneTree.play_main_scene"'
" let @n='godot --remote-send "SceneTree.stop" && sleep 0.3 && godot --remote-send "SceneTree.play_current_scene"'

" :make will always run main scene
setlocal makeprg=godot\ --remote-send\ "SceneTree.play_main_scene"
" setlocal makeprg=xdotool\ search\ --class\ Godot\ windowactivate

" Function key overrides
" nnoremap <buffer> <F5> :silent !godot --remote-send "SceneTree.play_main_scene"<CR>
" nnoremap <buffer> <F6> :silent !godot --remote-send "SceneTree.play_current_scene"<CR>
" nnoremap <buffer> <F7> :silent !godot --remote-send "SceneTree.stop"<CR>
" nnoremap <buffer> <F8> :silent !godot --remote-send "SceneTree.stop" \|\| sleep 0.3 \|\| godot --remote-send "SceneTree.play_main_scene"<CR>
" nnoremap <buffer> <F9> :silent !godot --remote-send "SceneTree.stop" \|\| sleep 0.3 \|\| godot --remote-send "SceneTree.play_current_scene"<CR>

" Descriptions:
" <F5> → run main scene
" <F6> → run current scene
" <F7> → stop running scene
" <F8> → restart main scene
" <F9> → restart current scene
