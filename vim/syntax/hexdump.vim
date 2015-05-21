" Vim syntax file
" Language:     Hexdump output
" Maintainer:   Fred Spreen
" Last Change:  2014 Feb 05
" Modeled after hex.vim

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  "finish
endif

syn case ignore

syn match hdAddress  "^\x\+"
syn match hdZero     "\X00"
syn match hdNeg      "\X[fF][fF]"
syn match hdAsciiCap "\X4\x\|\X5[0-9aA]"
syn match hdAsciiLow "\X6\x\|\X7[0-9aA]"

hi def link hdAddress Comment
" hi def link hdZero    SpecialKey
" hi def link hdNeg     Constant
hi hdZero     ctermfg=8
hi hdNeg      ctermfg=13
hi hdAsciiCap ctermfg=15
hi hdAsciiLow ctermfg=15

let b:current_syntax = "hexdump"
