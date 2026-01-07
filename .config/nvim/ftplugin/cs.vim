let s:dir = FindRootDirectory()
let @g = 'godot --headless --path ' . s:dir . ' --build-solutions'

let @b='dotnet build'
let @c='dotnet clean'
let @f='dotnet format'
let @l='dotnet list package'
let @w='dotnet watch -q run'
let @x='dotnet run'
