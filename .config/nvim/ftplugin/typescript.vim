let @b='npm build'
let @r='npm run dev'
let @i='npm i'
let @s='npm start'
let @t='npm test'
setlocal makeprg=tsc\ %
setlocal errorformat=%f:%l:%c:\ %m
