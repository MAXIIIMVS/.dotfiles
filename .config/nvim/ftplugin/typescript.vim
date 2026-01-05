let @b='npm build'
let @i='npm i'
let @s='npm start'
let @t='npm test'
let @x='npm run dev'
setlocal makeprg=tsc\ %
setlocal errorformat=%f:%l:%c:\ %m
