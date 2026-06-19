" Name:         Libra.vim
" Description:  Converted from libra.lua; Designed by Mustafa Hayati <mustafa.hayati1992@gmail.com>.

hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "libra"

function! s:ApplyHighlights()
    let l:bg = &background
    let l:is_transparent = get(g:, 'is_transparent', 0)

    " 1. True Retrobox Palette Definitions (Upstream Base)
    if l:bg ==# "dark"
        let l:p = {
        \ 'bg0': '#282828', 'bg1': '#3c3836', 'bg2': '#504945', 'bg3': '#665c54', 'bg4': '#7c6f64',
        \ 'fg0': '#fbf1c7', 'fg1': '#ebdbb2', 'fg2': '#d5c4a1', 'fg3': '#bdae93', 'fg4': '#a89984',
        \ 'red': '#fb4934', 'green': '#b8bb26', 'yellow': '#fabd2f', 'blue': '#83a598', 'purple': '#d3869b',
        \ 'aqua': '#8ec07c', 'orange': '#fe8019', 'grey': '#928374', 'sign_bg': '#282828',
        \ 'visual_bg': '#404945', 'search_bg': '#766c34'
        \ }
    else
        let l:p = {
        \ 'bg0': '#fbf1c7', 'bg1': '#ebdbb2', 'bg2': '#d5c4a1', 'bg3': '#bdae93', 'bg4': '#a89984',
        \ 'fg0': '#282828', 'fg1': '#3c3836', 'fg2': '#504945', 'fg3': '#665c54', 'fg4': '#7c6f64',
        \ 'red': '#cc241d', 'green': '#98971a', 'yellow': '#d79921', 'blue': '#458588', 'purple': '#b16286',
        \ 'aqua': '#689d6a', 'orange': '#d65d0e', 'grey': '#928374', 'sign_bg': '#fbf1c7',
        \ 'visual_bg': '#eaeda3', 'search_bg': '#bdae93'
        \ }
    endif

    " Dictionary to hold compiled highlight arguments
    let l:groups = {}

    " 2. Baseline Retrobox Structure
    let l:groups['Normal'] = 'guifg=' . l:p.fg1 . ' guibg=' . l:p.bg0 . ' gui=NONE cterm=NONE'
    let l:groups['NormalFloat'] = 'guifg=' . l:p.fg1 . ' guibg=' . l:p.bg1 . ' gui=NONE cterm=NONE'
    let l:groups['CursorLine'] = 'guibg=' . l:p.bg1 . ' gui=NONE cterm=NONE'
    let l:groups['CursorLineNr'] = 'guifg=' . l:p.yellow . ' guibg=' . l:p.bg1 . ' gui=NONE cterm=NONE'
    let l:groups['LineNr'] = 'guifg=' . l:p.bg4 . ' gui=NONE cterm=NONE'
    let l:groups['SignColumn'] = 'guibg=' . l:p.sign_bg . ' gui=NONE cterm=NONE'
    let l:groups['FoldColumn'] = 'guifg=' . l:p.grey . ' guibg=' . l:p.sign_bg . ' gui=NONE cterm=NONE'
    let l:groups['VertSplit'] = 'guifg=' . l:p.bg3 . ' guibg=NONE gui=NONE cterm=NONE'
    let l:groups['WinSeparator'] = 'guifg=' . l:p.bg3 . ' guibg=NONE gui=NONE cterm=NONE'
    let l:groups['ColorColumn'] = 'guibg=' . l:p.bg1 . ' gui=NONE cterm=NONE'
    let l:groups['Visual'] = 'guibg=' . l:p.visual_bg . ' gui=NONE cterm=NONE'
    let l:groups['VisualNOS'] = 'guibg=' . l:p.visual_bg . ' gui=NONE cterm=NONE'
    let l:groups['Search'] = 'guibg=' . l:p.search_bg . ' guifg=NONE gui=NONE cterm=NONE'
    let l:groups['IncSearch'] = 'guibg=' . l:p.orange . ' guifg=' . l:p.bg0 . ' gui=NONE cterm=NONE'
    let l:groups['Comment'] = 'guifg=' . l:p.grey . ' gui=NONE cterm=NONE'
    let l:groups['NonText'] = 'guifg=' . l:p.bg2 . ' gui=NONE cterm=NONE'
    let l:groups['Whitespace'] = 'guifg=' . l:p.bg2 . ' gui=NONE cterm=NONE'
    let l:groups['SpecialKey'] = 'guifg=' . l:p.bg2 . ' gui=NONE cterm=NONE'
    let l:groups['Todo'] = 'guifg=' . l:p.fg0 . ' guibg=' . l:p.bg0 . ' gui=bold cterm=bold'
    let l:groups['Constant'] = 'guifg=' . l:p.purple . ' gui=NONE cterm=NONE'
    let l:groups['Character'] = 'guifg=' . l:p.purple . ' gui=NONE cterm=NONE'
    let l:groups['Number'] = 'guifg=' . l:p.purple . ' gui=NONE cterm=NONE'
    let l:groups['Boolean'] = 'guifg=' . l:p.purple . ' gui=NONE cterm=NONE'
    let l:groups['Float'] = 'guifg=' . l:p.purple . ' gui=NONE cterm=NONE'
    let l:groups['Identifier'] = 'guifg=' . l:p.blue . ' gui=NONE cterm=NONE'
    let l:groups['Function'] = 'guifg=' . l:p.green . ' gui=bold cterm=bold'
    let l:groups['Title'] = 'guifg=' . l:p.green . ' gui=bold cterm=bold'
    let l:groups['Statement'] = 'guifg=' . l:p.red . ' gui=NONE cterm=NONE'
    let l:groups['Conditional'] = 'guifg=' . l:p.red . ' gui=NONE cterm=NONE'
    let l:groups['Repeat'] = 'guifg=' . l:p.red . ' gui=NONE cterm=NONE'
    let l:groups['Label'] = 'guifg=' . l:p.red . ' gui=NONE cterm=NONE'
    let l:groups['Operator'] = 'guifg=' . l:p.fg1 . ' gui=NONE cterm=NONE'
    let l:groups['Keyword'] = 'guifg=' . l:p.red . ' gui=NONE cterm=NONE'
    let l:groups['Exception'] = 'guifg=' . l:p.red . ' gui=NONE cterm=NONE'
    let l:groups['PreProc'] = 'guifg=' . l:p.aqua . ' gui=NONE cterm=NONE'
    let l:groups['Include'] = 'guifg=' . l:p.aqua . ' gui=NONE cterm=NONE'
    let l:groups['Define'] = 'guifg=' . l:p.aqua . ' gui=NONE cterm=NONE'
    let l:groups['Macro'] = 'guifg=' . l:p.aqua . ' gui=NONE cterm=NONE'
    let l:groups['PreCondit'] = 'guifg=' . l:p.aqua . ' gui=NONE cterm=NONE'
    let l:groups['Type'] = 'guifg=' . l:p.yellow . ' gui=NONE cterm=NONE'
    let l:groups['StorageClass'] = 'guifg=' . l:p.orange . ' gui=NONE cterm=NONE'
    let l:groups['Structure'] = 'guifg=' . l:p.aqua . ' gui=NONE cterm=NONE'
    let l:groups['Typedef'] = 'guifg=' . l:p.yellow . ' gui=NONE cterm=NONE'
    let l:groups['Special'] = 'guifg=' . l:p.orange . ' gui=NONE cterm=NONE'
    let l:groups['SpecialChar'] = 'guifg=' . l:p.red . ' gui=NONE cterm=NONE'
    let l:groups['Tag'] = 'guifg=' . l:p.aqua . ' gui=NONE cterm=NONE'
    let l:groups['Delimiter'] = 'guifg=' . l:p.orange . ' gui=NONE cterm=NONE'
    let l:groups['SpecialComment'] = 'guifg=' . l:p.grey . ' gui=NONE cterm=NONE'
    let l:groups['Debug'] = 'guifg=' . l:p.red . ' gui=NONE cterm=NONE'
    let l:groups['StatusLine'] = 'guifg=' . '#130F1E' . ' guibg=' . l:p.fg1 . ' gui=reverse cterm=reverse'
    let l:groups['StatusLineNC'] = 'guifg=' . l:p.bg2 . ' guibg=' . l:p.fg4 . ' gui=reverse cterm=reverse'
    let l:groups['TabLine'] = 'guifg=' . l:p.fg4 . ' guibg=' . l:p.bg4 . ' gui=NONE cterm=NONE'
    let l:groups['TabLineFill'] = 'guifg=' . l:p.fg4 . ' guibg=' . l:p.bg4 . ' gui=NONE cterm=NONE'
    let l:groups['TabLineSel'] = 'guifg=' . l:p.green . ' guibg=' . l:p.bg0 . ' gui=NONE cterm=NONE'
    let l:groups['Pmenu'] = 'guifg=' . l:p.fg1 . ' guibg=' . l:p.bg2 . ' gui=NONE cterm=NONE'
    let l:groups['PmenuSel'] = 'guifg=' . l:p.bg0 . ' guibg=' . l:p.blue . ' gui=NONE cterm=NONE'
    let l:groups['PmenuSbar'] = 'guibg=' . l:p.bg2 . ' gui=NONE cterm=NONE'
    let l:groups['PmenuThumb'] = 'guibg=' . l:p.bg4 . ' gui=NONE cterm=NONE'
    let l:groups['DiagnosticError'] = 'guifg=' . l:p.red . ' gui=NONE cterm=NONE'
    let l:groups['DiagnosticWarn'] = 'guifg=' . l:p.yellow . ' gui=NONE cterm=NONE'
    let l:groups['DiagnosticInfo'] = 'guifg=' . l:p.blue . ' gui=NONE cterm=NONE'
    let l:groups['DiagnosticHint'] = 'guifg=' . l:p.aqua . ' gui=NONE cterm=NONE'
    let l:groups['DiagnosticUnderlineError'] = 'gui=underline cterm=underline guisp=' . l:p.red
    let l:groups['DiagnosticUnderlineWarn'] = 'gui=underline cterm=underline guisp=' . l:p.yellow
    let l:groups['DiagnosticUnderlineInfo'] = 'gui=underline cterm=underline guisp=' . l:p.blue
    let l:groups['DiagnosticUnderlineHint'] = 'gui=underline cterm=underline guisp=' . l:p.aqua

    " 3. Apply Your Precise Overrides (Takes Precedence)
    if l:bg ==# "dark"
        let l:dark_text = "#CDD6F5"
        let l:groups['Normal'] = 'guifg=' . l:dark_text . ' guibg=#1A1528 gui=NONE cterm=NONE'
        let l:groups['NormalFloat'] = 'guifg=' . l:dark_text . ' guibg=#181826 gui=NONE cterm=NONE'
        let l:groups['CursorLine'] = 'guibg=#29283B gui=NONE cterm=NONE'
        let l:groups['Function'] = 'guifg=#B8BB26 gui=NONE cterm=NONE'
        let l:groups['Title'] = 'guifg=#B8BB26 gui=NONE cterm=NONE'
        let l:groups['String'] = 'guifg=#D7AF5F gui=NONE cterm=NONE'
        let l:groups['NonText'] = 'guifg=#9ca0b1 gui=NONE cterm=NONE'
        let l:groups['Whitespace'] = 'guifg=#444444 gui=NONE cterm=NONE'
        let l:groups['Visual'] = 'guibg=#45475b guifg=NONE gui=NONE cterm=NONE'
        let l:groups['VisualNOS'] = 'guibg=#45475b guifg=NONE gui=NONE cterm=NONE'

        " Standardize variables and identifiers to dark blue variable color instead of white text fallback
        let l:dark_var_color = "#83a598"
        let l:groups['Identifier'] = 'guifg=' . l:dark_var_color . ' gui=NONE cterm=NONE'

        " Explicitly lock type rules
        let l:groups['Type'] = 'guifg=' . l:p.yellow . ' gui=NONE cterm=NONE'
        let l:groups['StorageClass'] = 'guifg=' . l:p.orange . ' gui=NONE cterm=NONE'
        let l:groups['Structure'] = 'guifg=' . l:p.aqua . ' gui=NONE cterm=NONE'
        let l:groups['Typedef'] = 'guifg=' . l:p.yellow . ' gui=NONE cterm=NONE'

        " Numbers explicitly cleared from default highlights or links causing underlines
        let l:groups['Constant'] = 'guifg=' . l:p.purple . ' gui=NONE cterm=NONE'
        let l:groups['Character'] = 'guifg=' . l:p.purple . ' gui=NONE cterm=NONE'
        let l:groups['Number'] = 'guifg=' . l:p.purple . ' gui=NONE cterm=NONE'
        let l:groups['Boolean'] = 'guifg=' . l:p.purple . ' gui=NONE cterm=NONE'
        let l:groups['Float'] = 'guifg=' . l:p.purple . ' gui=NONE cterm=NONE'

        " Fix white brackets/parenthesis fallback definitions
        let l:groups['Operator'] = 'guifg=' . l:p.orange . ' gui=NONE cterm=NONE'
        let l:groups['Delimiter'] = 'guifg=' . l:p.orange . ' gui=NONE cterm=NONE'

        let l:groups['MatchParen'] = 'guibg=#504945 guifg=NONE gui=bold,underline cterm=bold,underline guisp=#bdae93'
        let l:groups['Underlined'] = 'guifg=#83a598 gui=underline cterm=underline guisp=#83a598'

        let l:groups['DiagnosticError'] = 'guifg=#ff5f5f gui=NONE cterm=NONE'
        let l:groups['DiagnosticWarn'] = 'guifg=#ffaf00 gui=NONE cterm=NONE'
        let l:groups['DiagnosticInfo'] = 'guifg=#5fafff gui=NONE cterm=NONE'
        let l:groups['DiagnosticHint'] = 'guifg=#5fffaf gui=NONE cterm=NONE'
        let l:groups['DiagnosticUnderlineError'] = 'gui=underline cterm=underline guisp=#ff5f5f'
        let l:groups['DiagnosticUnderlineWarn'] = 'gui=underline cterm=underline guisp=#ffaf00'
        let l:groups['DiagnosticUnderlineInfo'] = 'gui=underline cterm=underline guisp=#5fafff'
        let l:groups['DiagnosticUnderlineHint'] = 'gui=underline cterm=underline guisp=#5fffaf'

        let l:groups['Pmenu'] = 'guifg=' . l:dark_text . ' guibg=#181826 gui=NONE cterm=NONE'
        let l:groups['PmenuSel'] = 'guifg=' . l:dark_text . ' guibg=#444444 gui=NONE cterm=NONE'
        let l:groups['FloatBorder'] = 'guifg=#554d80 guibg=#181826 gui=NONE cterm=NONE'

        let l:groups['SignColumn'] = 'guibg=#1A1528 guifg=' . l:dark_text . ' gui=NONE cterm=NONE'
        let l:groups['FoldColumn'] = 'guibg=#1A1528 gui=NONE cterm=NONE'
        let l:groups['CursorLineNr'] = 'guibg=#1A1528 guifg=#ffaf00 gui=bold cterm=bold'
        let l:groups['ColorColumn'] = 'guibg=#313245 gui=NONE cterm=NONE'
        let l:groups['WinSeparator'] = 'guifg=#554D80 gui=NONE cterm=NONE'
        let l:groups['VertSplit'] = 'guifg=#5f5f5f gui=NONE cterm=NONE'

        " Tab groups precisely isolated
        let l:groups['TabLine'] = 'guifg=' . l:p.fg4 . ' guibg=' . l:p.bg4 . ' gui=NONE cterm=NONE'
        let l:groups['TabLineFill'] = 'guifg=NONE guibg=#130F1E gui=NONE cterm=NONE'
        let l:groups['TabLineSel'] = 'guifg=' . l:dark_text . ' guibg=#1A1528 gui=NONE cterm=NONE'

        let l:groups['QuickFixLine'] = 'guibg=#38384C gui=bold cterm=bold'
        let l:groups['Search'] = 'guibg=#2f4f75 guifg=NONE gui=NONE cterm=NONE'
        let l:groups['IncSearch'] = 'guibg=#fe8019 guifg=#1A1528 gui=bold cterm=bold'
        let l:groups['CurSearch'] = 'guibg=#fabd2f guifg=#1A1528 gui=bold cterm=bold'
        let l:groups['ErrorMsg'] = 'guibg=NONE gui=NONE cterm=NONE'
        let l:groups['debugPC'] = 'guibg=#45475b gui=NONE cterm=NONE'
        let l:groups['SnacksIndent'] = 'guifg=#444444 gui=NONE cterm=NONE'

        let l:groups['DiffAdd'] = 'guibg=#2a332d guifg=NONE gui=NONE cterm=NONE'
        let l:groups['DiffChange'] = 'guibg=#3a2e36 guifg=NONE gui=NONE cterm=NONE'
        let l:groups['DiffDelete'] = 'guibg=#3e2d2e guifg=NONE gui=NONE cterm=NONE'
        let l:groups['DiffText'] = 'guibg=#575268 guifg=NONE gui=NONE cterm=NONE'

        let l:groups['SpellBad'] = 'gui=undercurl cterm=undercurl guisp=#ff5f5f'
        let l:groups['SpellCap'] = 'gui=undercurl cterm=undercurl guisp=#5fafff'
        let l:groups['SpellRare'] = 'gui=undercurl cterm=undercurl guisp=#5fffaf'
        let l:groups['SpellLocal'] = 'gui=undercurl cterm=undercurl guisp=#ffaf00'

        let l:groups['CmpItemAbbr'] = 'guifg=#a0a0b0 gui=NONE cterm=NONE'
        let l:groups['CmpItemAbbrMatch'] = 'guifg=#ffaf00 gui=bold cterm=bold'
        let l:groups['CmpItemAbbrMatchFuzzy'] = 'guifg=#ffaf00 gui=NONE cterm=NONE'
        let l:groups['CmpItemKind'] = 'guifg=#7fafff guibg=#181826 gui=NONE cterm=NONE'
        let l:groups['CmpItemMenu'] = 'guifg=#8f8f99 guibg=#181826 gui=italic cterm=italic'

        if l:is_transparent
            let l:groups['Normal'] = 'guifg=' . l:dark_text . ' guibg=NONE gui=NONE cterm=NONE'
            let l:groups['NormalFloat'] = 'guifg=' . l:dark_text . ' guibg=NONE gui=NONE cterm=NONE'
            let l:groups['SignColumn'] = 'guibg=NONE gui=NONE cterm=NONE'
            let l:groups['FoldColumn'] = 'guibg=NONE gui=NONE cterm=NONE'
            let l:groups['CursorLineNr'] = 'guibg=NONE guifg=NONE gui=NONE cterm=NONE'
            let l:groups['FloatBorder'] = 'guifg=#5f5f5f guibg=NONE gui=NONE cterm=NONE'
            let l:groups['VertSplit'] = 'guibg=NONE guifg=#5f5f5f gui=NONE cterm=NONE'
            let l:groups['Pmenu'] = 'guifg=#d0d0d0 guibg=NONE gui=NONE cterm=NONE'
            let l:groups['TabLineFill'] = 'guibg=NONE guifg=NONE gui=NONE cterm=NONE'
            let l:groups['TabLineSel'] = 'guifg=' . l:dark_text . ' guibg=NONE gui=NONE cterm=NONE'
            let l:groups['StatusLine'] = 'guibg=NONE guifg=NONE gui=NONE cterm=NONE'
            let l:groups['StatusLineNC'] = 'guibg=NONE guifg=NONE gui=NONE cterm=NONE'
            let l:groups['StatusLineTerm'] = 'guibg=NONE guifg=NONE gui=NONE cterm=NONE'
            let l:groups['StatusLineTermNC'] = 'guibg=NONE guifg=NONE gui=NONE cterm=NONE'
            let l:groups['Search'] = 'guibg=#5f431f guifg=NONE gui=NONE cterm=NONE'
            let l:groups['IncSearch'] = 'guibg=#5f431f guifg=NONE gui=NONE cterm=NONE'
            let l:groups['CurSearch'] = 'guibg=#5f431f guifg=NONE gui=NONE cterm=NONE'
            let l:groups['SnacksIndent'] = 'guifg=#504945 gui=NONE cterm=NONE'
            let l:groups['CmpItemKind'] = 'guifg=#7fafff guibg=NONE gui=NONE cterm=NONE'
            let l:groups['CmpItemMenu'] = 'guifg=#8f8f99 guibg=NONE gui=italic cterm=italic'
            let l:groups['DiagnosticError'] = 'guifg=#ff5f5f gui=bold cterm=bold'
            let l:groups['DiagnosticWarn'] = 'guifg=#ffaf00 gui=bold cterm=bold'
        endif
    else
        " 4. Light Mode Overrides
        let l:light_text = "#4c4f69"
        let l:groups['Normal'] = 'guifg=' . l:light_text . ' guibg=' . (l:is_transparent ? 'NONE' : '#eff1f5') . ' gui=NONE cterm=NONE'
        let l:groups['NormalFloat'] = 'guifg=' . l:light_text . ' guibg=' . (l:is_transparent ? 'NONE' : '#ECECF0') . ' gui=NONE cterm=NONE'
        let l:groups['CursorLine'] = 'guifg=NONE guibg=#e9ebf1 gui=NONE cterm=NONE'
        let l:groups['CursorLineNr'] = 'guifg=#7287fd guibg=NONE gui=NONE cterm=NONE'
        let l:groups['LineNr'] = 'guifg=#bcc0cc guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Comment'] = 'guifg=#7c7f93 guibg=NONE gui=NONE cterm=NONE'
        let l:groups['NonText'] = 'guifg=#9ca0b0 guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Whitespace'] = 'guifg=#787575 gui=NONE cterm=NONE'

        let l:groups['Identifier'] = 'guifg=#dd7878' . ' gui=NONE cterm=NONE'
        let l:groups['Operator'] = 'guifg=' . l:light_text . ' gui=NONE cterm=NONE'
        let l:groups['Delimiter'] = 'guifg=' . l:light_text . ' gui=NONE cterm=NONE'

        let l:groups['MatchParen'] = 'guifg=#fe640b guibg=NONE gui=underline cterm=underline guisp=#fe640b'
        let l:groups['Underlined'] = 'guifg=#1e66f5 gui=underline cterm=underline guisp=#1e66f5'

        let l:groups['SignColumn'] = 'guifg=#bcc0cc guibg=NONE gui=NONE cterm=NONE'
        let l:groups['FoldColumn'] = 'guifg=#9ca0b0 guibg=NONE gui=NONE cterm=NONE'
        let l:groups['FloatBorder'] = 'guifg=#1e66f5 guibg=#ECECF0 gui=NONE cterm=NONE'
        let l:groups['ColorColumn'] = 'guifg=NONE guibg=#e6e9ef gui=NONE cterm=NONE'
        let l:groups['VertSplit'] = 'guifg=#dce0e8 guibg=NONE gui=NONE cterm=NONE'
        let l:groups['CursorColumn'] = 'guifg=NONE guibg=#e6e9ef gui=NONE cterm=NONE'

        let l:groups['Visual'] = 'guifg=NONE guibg=#bcc0cc gui=NONE cterm=NONE'
        let l:groups['VisualNOS'] = 'guifg=NONE guibg=#bcc0cc gui=NONE cterm=NONE'
        let l:groups['Search'] = 'guifg=' . l:light_text . ' guibg=#a8daf0 gui=NONE cterm=NONE'
        let l:groups['CurSearch'] = 'guifg=NONE guibg=#fc8fc3 gui=NONE cterm=NONE'

        let l:groups['Function'] = 'guifg=#1e66f5 guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Title'] = 'guifg=#1e66f5 guibg=NONE gui=NONE cterm=NONE'
        let l:groups['String'] = 'guifg=#40a02b guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Keyword'] = 'guifg=#8839ef guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Statement'] = 'guifg=#8839ef guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Conditional'] = 'guifg=#8839ef guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Repeat'] = 'guifg=#8839ef guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Exception'] = 'guifg=#8839ef guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Include'] = 'guifg=#8839ef guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Macro'] = 'guifg=#8839ef guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Constant'] = 'guifg=#fe640b guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Type'] = 'guifg=#df8e1d guibg=NONE gui=NONE cterm=NONE'
        let l:groups['StorageClass'] = 'guifg=#df8e1d guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Structure'] = 'guifg=#df8e1d guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Special'] = 'guifg=#ea76cb guibg=NONE gui=NONE cterm=NONE'
        let l:groups['PreProc'] = 'guifg=#ea76cb guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Character'] = 'guifg=#179299 guibg=NONE gui=NONE cterm=NONE'
        let l:groups['Label'] = 'guifg=#209fb5 guibg=NONE gui=NONE cterm=NONE'

        let l:groups['DiagnosticError'] = 'guifg=#cc241d gui=bold cterm=bold'
        let l:groups['DiagnosticWarn'] = 'guifg=#d79921 gui=NONE cterm=NONE'
        let l:groups['DiagnosticInfo'] = 'guifg=#458588 gui=NONE cterm=NONE'
        let l:groups['DiagnosticHint'] = 'guifg=#689d6a gui=NONE cterm=NONE'
        let l:groups['DiagnosticUnderlineError'] = 'gui=underline cterm=underline guisp=#cc241d'
        let l:groups['DiagnosticUnderlineWarn'] = 'gui=underline cterm=underline guisp=#d79921'
        let l:groups['DiagnosticUnderlineInfo'] = 'gui=underline cterm=underline guisp=#458588'
        let l:groups['DiagnosticUnderlineHint'] = 'gui=underline cterm=underline guisp=#689d6a'
        let l:groups['Error'] = 'guifg=#d20f39 guibg=NONE gui=NONE cterm=NONE'
        let l:groups['ErrorMsg'] = 'guifg=#d20f39 guibg=NONE gui=NONE cterm=NONE'
        let l:groups['WarningMsg'] = 'guifg=#df8e1d guibg=NONE gui=NONE cterm=NONE'

        let l:groups['StatusLine'] = 'guifg=' . l:light_text . ' guibg=' . (l:is_transparent ? 'NONE' : '#dce0e8')
        let l:groups['StatusLineNC'] = 'guifg=#bcc0cc guibg=' . (l:is_transparent ? 'NONE' : '#e6e9ef')
        let l:groups['TabLine'] = 'guifg=#9ca0b0 guibg=#dce0e8 gui=NONE cterm=NONE'
        let l:groups['TabLineFill'] = 'guifg=NONE guibg=' . (l:is_transparent ? 'NONE' : '#e6e9ef') . ' gui=NONE cterm=NONE'
        let l:groups['TabLineSel'] = 'guifg=' . l:light_text . ' guibg=' . (l:is_transparent ? 'NONE' : '#eff1f5') . ' gui=NONE cterm=NONE'

        let l:groups['Pmenu'] = 'guifg=#7c7f93 guibg=' . (l:is_transparent ? 'NONE' : '#e6e9ef') . ' gui=NONE cterm=NONE'
        let l:groups['PmenuSel'] = 'guifg=NONE guibg=#ccd0da gui=NONE cterm=NONE'
        let l:groups['PmenuSbar'] = 'guifg=NONE guibg=#ccd0da gui=NONE cterm=NONE'
        let l:groups['PmenuThumb'] = 'guifg=NONE guibg=#9ca0b0 gui=NONE cterm=NONE'
        let l:groups['PmenuExtra'] = 'guifg=#9ca0b0 guibg=#e6e9ef gui=NONE cterm=NONE'
        let l:groups['PmenuExtraSel'] = 'guifg=#9ca0b0 guibg=#ccd0da gui=NONE cterm=NONE'
        let l:groups['PmenuMatch'] = 'guifg=' . l:light_text . ' guibg=NONE gui=NONE cterm=NONE'
        let l:groups['PmenuMatchSel'] = 'guifg=NONE guibg=NONE gui=NONE cterm=NONE'

        let l:groups['CmpItemAbbr'] = 'guifg=#7c7f93 gui=NONE cterm=NONE'
        let l:groups['CmpItemAbbrMatch'] = 'guifg=#1e66f5 gui=bold cterm=bold'
        let l:groups['CmpItemAbbrMatchFuzzy'] = 'guifg=#1e66f5 gui=NONE cterm=NONE'
        let l:groups['CmpItemKind'] = 'guifg=#1e66f5 guibg=NONE gui=NONE cterm=NONE'
        let l:groups['CmpItemMenu'] = 'guifg=#FF0000 guibg=#FF0000 gui=italic cterm=italic'

        let l:groups['SpellBad'] = 'gui=undercurl cterm=undercurl guisp=#cc241d'
        let l:groups['SpellCap'] = 'gui=undercurl cterm=undercurl guisp=#458588'
        let l:groups['SpellRare'] = 'gui=undercurl cterm=undercurl guisp=#689d6a'
        let l:groups['SpellLocal'] = 'gui=undercurl cterm=undercurl guisp=#d79921'

        let l:groups['QuickFixLine'] = 'guifg=NONE guibg=#d0baf3 gui=NONE cterm=NONE'
        let l:groups['DiffAdd'] = 'guifg=NONE guibg=#d0e2d1 gui=NONE cterm=NONE'
        let l:groups['DiffChange'] = 'guifg=NONE guibg=#e0e7f5 gui=NONE cterm=NONE'
        let l:groups['DiffDelete'] = 'guifg=NONE guibg=#eac8d3 gui=NONE cterm=NONE'
        let l:groups['DiffText'] = 'guifg=NONE guibg=#b0c7f5 gui=NONE cterm=NONE'
        let l:groups['debugPC'] = 'guifg=NONE guibg=#dce0e8' . ' gui=NONE cterm=NONE'
        let l:groups['debugBreakpoint'] = 'guifg=#9ca0b0 guibg=#eff1f5' . ' gui=NONE cterm=NONE'
    endif

    " Execute standard Vim highlight loop
    for [l:group, l:opts] in items(l:groups)
        execute 'highlight' l:group l:opts
    endfor

    " 5. Tree-sitter Specific Overrides (Safe API for Neovim Environments)
    if has('nvim')
        if l:bg ==# "dark"
            let l:orange_val = l:p.orange
            call nvim_set_hl(0, '@operator', {'fg': l:orange_val})
            call nvim_set_hl(0, '@punctuation', {'fg': l:orange_val})
            call nvim_set_hl(0, '@punctuation.delimiter', {'fg': l:orange_val})
            call nvim_set_hl(0, '@punctuation.bracket', {'fg': l:orange_val})
            call nvim_set_hl(0, '@punctuation.special', {'fg': l:orange_val})

            let l:dark_var_val = "#83a598"
            call nvim_set_hl(0, '@variable', {'fg': l:dark_var_val})
            call nvim_set_hl(0, '@variable.member', {'fg': l:dark_var_val})
            call nvim_set_hl(0, '@property', {'fg': l:dark_var_val})
        else
            let l:light_text_val = l:light_text
            call nvim_set_hl(0, '@operator', {'fg': l:light_text_val})
            call nvim_set_hl(0, '@punctuation', {'fg': l:light_text_val})
            call nvim_set_hl(0, '@punctuation.delimiter', {'fg': l:light_text_val})
            call nvim_set_hl(0, '@punctuation.bracket', {'fg': l:light_text_val})
            call nvim_set_hl(0, '@punctuation.special', {'fg': l:light_text_val})

            let l:light_var_val = "#458588"
            call nvim_set_hl(0, '@variable', {'fg': l:light_var_val})
            call nvim_set_hl(0, '@variable.member', {'fg': l:light_var_val})
            call nvim_set_hl(0, '@property', {'fg': l:light_var_val})
        endif
    endif
endfunction

call s:ApplyHighlights()
