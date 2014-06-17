" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	1999 Jul 25
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc

" Get colorschemes at http://www.cs.cmu.edu/~maverick/VimColorSchemeTest/index-pl.html
"colorscheme desert
colorscheme advantage
set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"500	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
" set verbose=10
set fileencodings=utf-8,koi8-r,cp1251,latin-1
set exrc secure         " enable per-directory .vimrc files and disable unsafe commands in local .vimrc files

" Enable undo
if has("persistent_undo") " requires vim 7.3 at least
  set undofile
  set undodir=/tmp
endif

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost * if line("'\"") | exe "'\"" | endif
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
"  set hlsearch
  " Show trailing whitepace and spaces before a tab:
  highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\t\|[^\t]\zs\t\+/
endif

" :au[tocmd] [group] {event} {pat} [nested] {cmd}
" :au BufNewFile,BufRead *.html so <sfile>:h/html.vim
" :set verbose=9   <- This setting makes Vim echo the autocommands as it executes them.

" I often type :Q/W instead of :q/w
command -bang Q q<bang>
command -bang Qa qa<bang>
" bar: The command can be followed by a "|" and another command
command -bang -bar -nargs=? -complete=file W w<bang> <args>

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,.bkk,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Switches match highlighting on and off
nmap <F6> :set hls!<CR>

" Switches numered lines on and off
nmap <F5> :set nu!<CR>

" Insert #ifndef... headers into .h files
" attention! (green) symbols below entered as Ctrl-v followed by Ctrl-r
fun InsertIfndefs()
	let defsym=toupper(substitute(expand("%:t"), "[^a-zA-Z0-9]", "_", "g") . "_included")
	echo "defsym: " defsym 
	normal I#ifndef =defsym#define =defsym#endif /* =defsym */kkk
endfun

if has("autocmd")
 " Allow fileenc= in modelines http://vim.wikia.com/wiki/How_to_make_fileencoding_work_in_the_modeline
" au BufReadPost * let b:reloadcheck = 1
" au BufWinEnter * if exists('b:reloadcheck') | unlet b:reloadcheck | if &mod != 0 && &fenc != "" | exe 'e! ++enc=' . &fenc | endif | endif

 augroup cprog
  " Remove all cprog autocommands
  autocmd!
  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  "autocmd FileType *      set formatoptions=tcql smartindent comments& confirm textwidth=70
  autocmd FileType *      set formatoptions=tcql comments& confirm textwidth=78
  autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
  autocmd FileType c,cpp  set smarttab noexpandtab shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType c,cpp  set autowrite scrolloff=3 showmatch matchtime=2
  autocmd FileType c,cpp  set tags+='./.tags,.tags' " add .tags files
  autocmd FileType c,cpp  set tags+='./../tags,../tags,./../.tags,../.tags' " look in the level above
  autocmd FileType c,cpp  set path=.,/usr/include,,../include
"  autocmd FileType c,cpp  map <F4> a#include ""<Esc>i
  autocmd FileType c,cpp  map <F4> A<Delete><Enter><ESC>
  autocmd FileType c,cpp  map <F3> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
  autocmd FileType c,cpp  map <F8> :cnext <Return>
  autocmd FileType c,cpp  map <F7> :cprev <Return>
"  autocmd BufNewFile *.h O<C-R>=expand("%:t:r")<CR>
  autocmd BufNewFile *.h,*.hpp  call InsertIfndefs()
  autocmd BufNewFile *.c,*.cxx,*.cpp normal I#include "=expand("%:t:r") . ".h""
  autocmd FileType c,cpp  inoremap #I #include <><Esc>i
 augroup END

 augroup perl
  autocmd!
  autocmd FileType perl  set formatoptions=croql cindent comments=:#,mb:#
  autocmd FileType perl  set showmatch shiftwidth=2 ts=2 softtabstop=8 smarttab noexpandtab
  autocmd FileType perl  let perl_extended_vars=1
  autocmd FileType perl  map <F2> <ESC>ggi#!/usr/bin/perl -w<CR><CR>
  autocmd FileType perl  map <F4> A<Delete><Enter><ESC>
  autocmd BufNewFile *.pl 0r ~/.vim/tpl.pl |$
  autocmd BufNewFile *.cgi 0r ~/.vim/tpl.cgi |set ft=perl |$
  autocmd BufNewFile *.pm 0r ~/.vim/tpl.pm |exe "0s#Package#".expand("%")."#"| 0s/\//::/g| 0s/\.pm//| normal 5j
"  autocmd BufWritePre,FileWritePre *.pl :ks|1;/^# Last modified: /:normal f: lD:r!/bin/datekJ's
"  autocmd BufWritePre,FileWritePre *.pl ks|call UpdateTimeStamp()|'s
  autocmd BufWritePre,FileWritePre *.pl ks|call LastMod()|'s
  autocmd BufWritePost,FileWritePost *.pl :!chmod +x %
 augroup END

" autocmd FORMAT FileType javascript set formatoptions=croql cindent comments=:#,mb:#
 autocmd FileType javascript set formatoptions=croql cindent showmatch shiftwidth=2 softtabstop=8 ts=2 smarttab noexpandtab comments& confirm
" autocmd FileType javascript map <F3> exe "let line=getline(line('.')); substitute('[;{}]','\r','')"
 autocmd FileType javascript map <F3> :call MyCindent()<CR>
 autocmd FileType javascript map <F4> A<Delete><Enter><ESC>

 augroup awk
  au!
  autocmd FileType awk  set formatoptions=crol cindent comments=:#,mb:#
  autocmd FileType awk  set showmatch shiftwidth=2 softtabstop=8
  autocmd BufNewFile *.awk 0r ~/.vim/tpl.awk |$
  autocmd BufWritePre,FileWritePre *.awk :ks|1;/^# Last modified: /:normal f: lD:r!/bin/datekJ's
  autocmd BufWritePost,FileWritePost *.awk :!chmod +x %
 augroup END

 augroup sh
  au!
  autocmd FileType sh  set formatoptions=crol ai comments=:#,mb:#
  autocmd FileType sh  set shiftwidth=2 softtabstop=8
  autocmd BufNewFile *.sh 0r ~/.vim/tpl.sh |$
" autocmd BufWritePre,FileWritePre *.sh :ks|1;/^# Last modified: /:normal f: lD:r!/bin/datekJ's
  autocmd BufWritePre,FileWritePre *.sh ks|call LastMod()|'s
  autocmd BufWritePost,FileWritePost *.sh :!chmod +x %
 augroup END

 augroup tex
  au!
  autocmd FileType tex set formatoptions=tcq2t ai nosi nocindent ignorecase infercase textwidth=75
  autocmd FileType tex set comments=:%,mb:%
  autocmd FileType tex map <F4> a\begin{equation}<CR>\end{equation}<Esc>ko \label{}<Esc>ieq
  autocmd FileType tex map <F3> a\begin{enumerate}<CR>\end{enumerate}<Esc>ko \item<Esc>o  
  autocmd FileType tex map <F2> a\begin{itemize}<CR>\end{itemize}<Esc>ko \item<Esc>o  
  autocmd FileType tex map <F5> a\begin{figure}[htbp]<CR>\end{figure}<Esc>ko \caption{}<CR> \label{fig}<Esc>i
  autocmd FileType tex map <F6> a\begin{tabular}{\|c\|c\|}<CR>\hline<CR>1 & 2\\<CR>3 & 4 \\<CR>\hline<CR>\end{tabular}<Esc>kkkkklllll
  autocmd BufNewFile *.tex 0r ~/.vim/tpl.tex |$|?\\end{document}?-
  autocmd BufWritePre,FileWritePre *.tex :ks|1;/^% Last modified: /:normal f: lD:r!/bin/datekJ's
 augroup END

 augroup html
  au!
  autocmd FileType htm,html set formatoptions=tclt ai ignorecase infercase mps+=<:> textwidth=70
  autocmd BufNewFile *.htm,*.html 0r ~/.vim/tpl.html |$|?title?:normal f>l
 augroup END

 augroup makefile
  " [( FileType make )]
  autocmd BufNewFile Makefile,makefile call AskForMakefileType()|
 augroup END

 augroup qtpro
  au!
  autocmd FileType pro set formatoptions=tclt ai ignorecase infercase mps+=<:> textwidth=70
  autocmd BufNewFile *.pro 0r ~/.vim/tpl.pro |$
 augroup END

 augroup asp
  autocmd!
  autocmd FileType aspvbs set ft=aspperl formatoptions=croql cindent comments=:#,mb:# shiftwidth=2 ts=2 softtabstop=8 smarttab noexpandtab showmatch
 augroup END

 augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPost,FileReadPost	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
 augroup END
endif

fun! AskForMakefileType()
  let choice = confirm("What template do you want?","Start from &Scratch\n&c-prog\n&tex\n&xul",1)
  if choice == 2
    0r ~/.vim/tpl.mf.c |/BINS/;
  elseif choice == 3
    0r ~/.vim/tpl.mf.tex |/PREF/;
  elseif choice == 4
    0r ~/.vim/tpl.mf.xul |/NAME/;
  else
    echo "tidy makefile choosen...";
  endif
endfun

function! MyCindent()
  let pat="[;{}]"
  if search(pat) >= 0
    normal a
  endif
endfunction

" searches the first ten lines for the timestamp and updates using the
" TimeStamp function
function! UpdateTimeStamp()
	" Do the updation only if the current buffer is modified 
confirm "QQQ"
echo "UpdateTimeStamp"
	if &modified == 1
		" go to the first line
		exec "1"

echo "Searching"
		" Search for Last modified: 
		let modified_line_no = search("^# Last-modified:")
		if modified_line_no != 0 && modified_line_no < 15
echo "Found"
			" There is a match in first 10 lines 
			" Go to the : in modified: 
			exe "s/Last-modified: .*/" . TimeStamp()
		endif
	endif
endfunction

" Search the first 5 lines for Last modified: and update the current datetime.
" stolen from http://pinguin.uni-psych.gwdg.de/~ihrke/wiki/index.php/.vimrc
function! LastMod()
    if line("$") > 5
let l = 5
    else
let l = line("$")
    endif
"    exe "1," . l . "g/Last modified: /s/Last modified: .*/Last modified: " . strftime("%a %b %d, %Y  %I:%M%p")
    exe "1," . l . "g/Last modified: /s/Last modified: .*/Last modified: " . strftime("%Y-%m-%d %H:%M:%S %z")
endfun


"  let ln = line(".")
"  let cur = getline(ln)
"  let ch = substitute(cur, '[;{}]', '&\r', '')
"  let ch = substitute(cur, "}", "\r&", "")
"  echo cur
"  setline(ln, ch)


