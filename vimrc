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

		" Trim trailing whitespace on Python, Perl, C, C++, .h files
		autocmd BufWrite *.py,*.pl,*.c,*.cpp,*.c++,*.h :%s/[ \t]\+$//e

		" Close NERDTree if it's the only thing left open in a tab
		autocmd BufEnter *
		\ if (winnr("$")==1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) |
		\    q |
		\ endif

	" end autocmd group
	augroup END
else
	set autoindent
endif

" Modeline bug guard
" xref:  https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
" xref:  https://nvd.nist.gov/vuln/detail/CVE-2019-12735
" xref:  https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-12735
if v:version < 801 || (v:version == 801 && !has("patch1365"))
	" pass
	set modelines=0
	set nomodeline
endif

" Sudo write
cmap w!! w !sudo tee >/dev/null %

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
if &term =~ "xterm*"
	" Change italics to standout
	" Xterm doesn't support italics (neither does the Terminus font),
	" but Vim tries to use them anyway
	set t_ZH=[7m
	set t_ZR=[27m
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

function SetTrueColor()
	set t_8f=[38;2;%lu;%lu;%lum    " set foreground color
	set t_8b=[48;2;%lu;%lu;%lum    " set background color
	set termguicolors
endfunction
call SetTrueColor()

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

" Ignore whitespace when 'diff'ing and default to a side-by-side diff
set diffopt=vertical,filler,iwhite

" Don't use - when showing deletions in diff
set fillchars=vert:┃,diff:\ ,fold:-

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
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_powerline_fonts=1
" Fix some symbols which are not supported by Terminus
" Prefer U+2261 IDENTICAL TO (triple bar shape)
" default is U+2630 YIJING TRIGAM FOR HEAVEN
let g:airline_symbols.linenr = "\u2261"
" Prefer U+2204 THERE DOES NOT EXIST
" default is U+0246 LATIN CAPITAL LETTER E WITH STROKE
" (strangely, the airline documentation is not consistent with the code here)
let g:airline_symbols.notexists = "\u2204"
" Prefer U+E0A2 [powerline lock]
" default is U+1F512 LOCK
let g:airline_symbols.crypt = "\uE0A2"
" Prefer U+2248 ALMOST EQUAL TO
" default is U+26A1 HIGH VOLTAGE SIGN
" (default is double-wide? corrupt on st+Terminus, 2x width on DejaVu+MinTTY)
let g:airline_symbols.dirty = "\u2248"
" Prefer U+2420 SYMBOL FOR SPACE [S/P] if/when Terminus supports it
" for now, use U+2021 DOUBLE DAGGER
" default is U+2739 TWELVE-POINTED BLACK STAR for some reason
let g:airline#extensions#whitespace#symbol="\u2021"
set laststatus=2
" toggle spacing checks
nmap <F7> :AirlineToggleWhitespace<CR>

" tagbar keymap and settings
" sort by file order, not alphabetically
let g:tagbar_sort = 0
nmap <F12> :TagbarToggle<CR>

" NERDTree keymap and settings
nmap <F8> :NERDTreeToggle<CR>
" Use fancy arrows (con:  no grouping lines)
let NERDTreeDirArrows = 1
" Defaults are \u25B8 and \u25BE but Terminus doesn't have those chars
let NERDTreeDirArrowExpandable = "\u25B6"
let NERDTreeDirArrowCollapsible = "\u25BC"
" Ignorable file types:  default is just ['\~$']
" Ignore *.pyc files
let NERDTreeIgnore=['\.pyc$[[file]]', '\~$']

" NERDTree Git plugin changes
" Default values, mostly NOT supported by Terminus:
" 	'Modified'	U-2739 twelve-pointed black star
" 	'Staged'	U-271A heavy greek cross
" 	'Untracked'	U-272D outlined black star
" 	'Renamed'	U-279C heavy round-tipped rightwards arrow
" 	'Unmerged'	U-2550 box drawings double horizontal
" 	'Deleted'	U-2716 heavy multiplication X
" 	'Dirty'		U-2717 ballot X
" 	'Clean'		U-2714 heavy check mark, U-FE0E variation selector-15
" 	'Ignored'	U-2612 ballot box with X
" 	'Unknown'	ASCII question mark
" My values, ARE supported by Terminus:
" 	'Modified'	ASCII asterisk
" 	'Staged'	U-E0A0 [powerline version control]
" 	'Untracked'	ASCII exclamation mark
" 	'Renamed'	U-2192 rightwards arrow
" 	'Unmerged'	U-2194 left right arrow
" 	'Deleted'	U-2205 empty set
" 	'Dirty'		U-00D7 multiplication sign
" 	'Clean'		U-2714 heavy check mark
" 	'Ignored'	U-00AC not sign
" 	'Unknown'	ASCII question mark
" Note that \uXXXX codes must be in double-quotes, not single
let g:NERDTreeGitStatusIndicatorMapCustom = {
			\ "Modified"  : '*',
			\ "Staged"    : "\uE0A0",
			\ "Untracked" : '!',
			\ "Renamed"   : "\u2192",
			\ "Unmerged"  : "\u2194",
			\ "Deleted"   : "\u2205",
			\ "Dirty"     : "\u00D7",
			\ "Clean"     : "\u2714",
			\ "Ignored"   : "\u00AC",
			\ "Unknown"   : '?',
			\ }

" Vimwiki settings
" Don't create temporary wikis
let g:vimwiki_global_ext = 0
" Avoid using the netrw plugin; create an index instead
let g:vimwiki_dir_link = 'index'
" Default is a little too generic
let g:vimwiki_toc_header = 'Table of Contents'
" Automatically invokes :lcd - allows NERDTree to function as a wiki index!
let g:vimwiki_auto_chdir = 1
" Change options for the default wiki
let g:vimwiki_list = [{
	\ 'path'           : '~/notes/',
	\ 'index'          : 'index',
	\ 'ext'            : '.md',
	\ 'syntax'         : 'markdown',
	\ 'diary_rel_path' : 'Logbook',
	\ 'diary_index'    : 'index',
	\ 'diary_header'   : 'Logbook',
	\ }]
" I like the .wiki extension, but if we're writing in MarkDown then .md must
" be used if we want GitHub to preview the files properly.

" ALE settings
" Tell pyls not to use pylint.  If pylint is installed, ALE will use it
" directly.
let g:ale_python_pyls_config = { 'pyls' : {
	\ 'plugins' : {'pylint' : {'enabled' : v:false }}
	\ }}

" Site-specific configuration
" expand() avoids system call differences on Cygwin
if filereadable(expand('~/.vim/siterc'))
	source ~/.vim/siterc
endif

" Modeline to set the usual tabs
" vim:noet:sw=8 sts=0
