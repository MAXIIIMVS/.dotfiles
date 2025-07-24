" :mapclear <buffer>

let g:netrw_usexterm = 0

" let s:treedepthstring     = "│ "
" let g:netrw_hide = 1
" let g:netrw_altv=1
setlocal noconfirm
if g:NetrwIsOpen == 1
  silent! nnoremap <silent> <buffer> <nowait> q :silent q<CR>
  silent! nnoremap <silent> <buffer> <nowait> <c-c> :silent q<CR>
  silent! nnoremap <silent> <buffer> <nowait> ;q :silent q<CR>
  silent! nnoremap <silent> <buffer> <nowait> ;; :silent q<CR>
  silent! nnoremap <silent> <buffer> <nowait> ;n :silent q<CR>
  setl bufhidden=wipe
endif

nmap <buffer> <c-p> p
nmap <buffer> <c-v> v
nmap <buffer> <C-h> o<c-w>J
nmap <buffer> <C-t> t
nmap <buffer> g? <f1><silent>
nmap <buffer> gs s
nmap <buffer> g. gh
nmap <buffer> dd D
" Go back in history
nmap <buffer> H u
" Go up a directory
nmap <buffer> h -^
nmap <buffer> l <CR>
nmap <buffer> gx x

nnoremap <silent> <buffer> a :call CreateFileAndEdit()<CR>

function! CreateFileAndEdit()
  let dir = getreg('n')
  if empty(dir)
    let dir = getcwd()
  endif

  if dir[-1:] !=# '/'
    let dir .= '/'
  endif

  let filename = trim(input('Enter filename: ', dir, 'file'))
  if empty(filename)
    return
  endif

  " Check if file exists
  if filereadable(filename) || isdirectory(filename)
    echoerr 'File or directory "' . filename . '" already exists! Aborting to prevent overwrite.'
    return
  endif

  " Ensure parent directories exist
  let basedir = fnamemodify(filename, ':h')
  if !isdirectory(basedir)
    try
      call mkdir(basedir, 'p')
    catch /.*/
      echoerr 'Could not create directories: ' . v:exception
      return
    endtry
  endif

  " If user typed a path ending with `/`, treat it as a directory
  if filename =~ '[\/]$'
    try
      call mkdir(filename, 'p')
      quit
      return
    catch /.*/
      echoerr 'Could not create directory: ' . v:exception
      return
    endtry
  endif

  " Create the file
  try
    call writefile([], filename, 's')
  catch /.*/
    echoerr 'Could not create file: ' . v:exception
    return
  endtry

  " Close netrw (current window) and open the file
  " quit " this cause a problem while using noice.nvim
  execute 'edit ' . fnameescape(filename)
endfunction
