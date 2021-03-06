" Vim color file
" TODO doc comments

" Start from default colors
hi clear Normal
hi clear
" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

" TODO better name
let g:colors_name = "mine"

" Menus as blue background / cyan highlight
" TODO recolor so black text is more visible
" TODO separate out into categories as below
hi Pmenu	ctermbg=4
hi PmenuSel	ctermfg=0 ctermbg=6

if &t_Co == 256 || has("gui_running")
	" GUI normal-on-black text
	hi Normal guifg=#AAAAAA guibg=#000000

	" === 256 color terminal ===

	" Special chars as dark gray
	hi SpecialKey	cterm=bold ctermfg=8 gui=bold guifg=#555555

	" Left margin columns with dark gray background
	hi LineNr	ctermbg=232 ctermfg=8 cterm=bold
	hi SignColumn	ctermbg=234
	hi FoldColumn	ctermbg=234
	hi Folded	ctermbg=234

	" Right-edge column as dark gray background
	hi ColorColumn	ctermbg=233 guibg=#121212

	" Spelling violations highlighted with...this brown egg-yolk color
	hi SpellBad	ctermbg=58

	" Dimmer 'diff' highlights

	"DiffAdd	term=bold ctermbg=4 guibg=DarkBlue
	"DiffChange	term=bold ctermbg=5 guibg=DarkMagenta
	"DiffDelete	term=bold ctermfg=12 ctermbg=6 gui=bold guifg=Blue guibg=DarkCyan
	"DiffText	term=reverse cterm=bold ctermbg=9 gui=bold guibg=Red
	hi DiffAdd	ctermbg=22
	hi DiffChange	ctermbg=17
	hi DiffDelete	ctermbg=52
	hi DiffText	ctermbg=20 cterm=none

	" Blue tab line
	hi TabLine	cterm=bold ctermbg=25 ctermfg=16  gui=bold guibg=#005faf guifg=#000000
	hi TabLineSel	cterm=bold            ctermfg=251 gui=bold               guifg=#c6c6c6
	hi TabLineFill	cterm=none ctermbg=25             gui=none guibg=#005faf

	" Blue separators
	hi VertSplit	cterm=none            ctermfg=26 gui=none guibg=#005faf guifg=#005fdf
	hi StatusLine	cterm=bold ctermbg=26 ctermfg=15 gui=bold guibg=#005fdf guifg=#ffffff
	hi StatusLineNC	cterm=bold ctermbg=25 ctermfg=16 gui=bold guibg=#005faf guifg=#000000

	" Green comments
	hi Comment	ctermfg=34 guifg=#00df87

	" === Plugin-specific colors ===
	" = Syntastic =
	" Compare SignColumn for background
	" Red error, Yellow warning
	hi SyntasticErrorSign	ctermfg=9	ctermbg=234
	hi SyntasticWarningSign	ctermfg=11	ctermbg=234
else
	" === normal 16-color terminal ===

	" Special chars as dark gray
	hi SpecialKey	cterm=bold ctermfg=0
	hi LineNr	cterm=bold ctermfg=0

	" Right-edge column as dark gray background
	hi ColorColumn	ctermfg=0 ctermbg=7 cterm=bold,reverse

	" Tab line with dark blue background
	hi TabLine	cterm=none ctermfg=7 ctermbg=4
	hi TabLineSel	cterm=none ctermfg=7
	hi TabLineFill	cterm=none           ctermbg=4

endif

" Modeline to use usual tabs
" vim:noet:sw=8 sts=0
