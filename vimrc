" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" if compiled with autocmd (spport for autocommands)
if has("autocmd")
	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" put these in an autocmd group
	augroup vimrcPersonal
		" undefine (in case of reload)
		au!

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal g`\"" |
		\ endif

		" TODO check against ftplugin/gitcommit.vim, maybe better way
		" to do this
		" Jump to top of file for Git commit messages
		autocmd BufReadPost COMMIT_EDITMSG exe "normal gg"

		" Trim trailing whitespace on Python, Perl, C, C++, .h files
		autocmd BufWrite *.py,*.pl,*.c,*.cpp,*.c++,*.h :%s/[ \t]\+$//e

	" end autocmd group
	augroup END
else
	set autoindent
endif

" ----- Pathogen Plugin Handler -----
"  expand() avoids system call differences on Cygwin
if filereadable(expand('~/.vim/bundle/vim-pathogen/autoload/pathogen.vim'))
	runtime bundle/vim-pathogen/autoload/pathogen.vim
	execute pathogen#infect()
endif

" ----- Interface Options -----

" Choose specific backspace behavior
" Many Linux vim packages do this already
" Windows packages, not so much (including Cygwin)
set bs=indent,eol,start

" Fix keys for screen/tmux sessions
if &term =~ "screen.*"
	" Ctrl+PageUp/Down (for tab switching)
	set t_kN=[6;*~
	set t_kP=[5;*~
endif

" Remove some GUI options
set guioptions-=r " Right-hand scrollbar
set guioptions-=L " Left scrollbar for vert split
set guioptions-=e " GUI Tabs (use text)
set guioptions-=m " Menu
set guioptions-=T " Toolbar

" Set font for gVim
if has('gui_running')
	" Windows
	if (has('gui_win32') || has('win32') || has('win64'))
		set guifont=Terminus:h11:cDEFAULT
	elseif has("x11")
		set guifont=Terminus\ 11
	endif
endif

" turn on syntax coloring
syntax on

" highlight search results
set hlsearch

" turn on ruler and line numbering
set ruler
set number
set numberwidth=1

" show partial commands
set showcmd

" spell-checking
"set spell

" Doxygen syntax coloring
let g:load_doxygen_syntax=1

" Nice title bar
set t_ts=]0;
set t_fs=
set titlestring=%(%y\ %)%(%r\ %)%(%M\ %)%F
set title

" No line wrapping
set nowrap
set textwidth=0
set wrapmargin=0

" Ignore whitespace when 'diff'ing
set diffopt=filler,iwhite

" Don't use - when showing deletions in diff
" Don't use | in vertical separators
" NOTE extra space at end
set fillchars+=diff:\ ,vert:\ 

" 80-column marker function
function RightEdge()
	set colorcolumn=81
endfunction

" Four-space tab function
function FourSpaceTab()
	set expandtab
	set shiftwidth=4
	set softtabstop=4
endfunction

" Turn on XML folding (may cause slowdowns)
function FoldXML()
	let g:xml_syntax_folding = 1
	set foldmethod=syntax
endfunction

" Prepare for paste in from Windows
function GoPaste()
	set paste
	set noexpandtab
endfunction

" Done with pasting
function StopPaste()
	set nopaste
	set expandtab
	" TODO some sort of push/pop to save previous expandtab state?
endfunction

" Detect indentation which is not a multiple of 4 spaces.
function BadIndent()
	" A bright red; may need to account for non-256-color terms
	hi BadIndent ctermbg=160

	" Toggle this on and off
	let w:bad_indent = exists('w:bad_indent') ? !w:bad_indent : 1
	if w:bad_indent
		match BadIndent /\v.+(^(    )*\S.*)@160<!$/
		" Match is 160 chars look-back for performance reasons.
		" May result in false positives on legitimately long lines.
	else
		match none
	endif
endfunction

" Actually invoke appropriate functions
call FourSpaceTab()

" If textwidth>0 (thus setting a margin) color the column after it
set colorcolumn=+1

" Auto-detect is nice, but it isn't always right.
set background=dark
" ~/.vim/colors/mine.vim
colo mine

" vim-airline settings
let g:airline_powerline_fonts=1
" Prefer \u2420 [S/P] if/when Terminus supports it
" for now, double-dagger
" (default is \u2739 [twelve-pointed black star] for some reason)
let g:airline#extensions#whitespace#symbol="\u2021"
set laststatus=2
" toggle spacing checks
nmap <F7> :AirlineToggleWhitespace<CR>

" tagbar keymap and settings
" sort by file order, not alphabetically
let g:tagbar_sort = 0
nmap <F8> :TagbarToggle<CR>

" Site-specific configuration
" expand() avoids system call differences on Cygwin
if filereadable(expand('~/.vim/siterc'))
    source ~/.vim/siterc
endif

" Modeline to set the usual tabs
" vim:noet:sw=8 sts=0
