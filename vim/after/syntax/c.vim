" Apply coloring to C/C++ functions
" http://stackoverflow.com/questions/736701/class-function-names-highlighting-in-vim
"
syn match cCustomParen	"("		contains=cParen contains=cCppParen
syn match cCustomFunc	"\w\+\s*("	contains=cCustomParen
syn match cCustomScope	"::"
syn match cCustomClass	"\w\+\s*::"	contains=cCustomScope

hi def link cCustomFunc		Function
hi def link cCustomClass	Function

" Modeline to set the usual tabs
" vim:noet:sw=8 sts=0
