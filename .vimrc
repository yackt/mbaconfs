
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


" --- cursorline setting ---
" cursorline setting
set cursorline
augroup cch
	autocmd! cch
	autocmd WinLeave * set nocursorline
	autocmd WinEnter,BufRead * set cursorline
augroup END
:hi clear CursorLine
:hi CursorLine gui=underline
hi CursorLine ctermbg=black guibg=black

" --- about tab, indent, space ---
" tab indent
setl tabstop=4
setl shiftwidth=4
setl softtabstop=0

" tab and space of eol
set list
set listchars=tab:^\ ,trail:~

" statusline setting
set laststatus=2

" column number
set number

" setting for json
map <Leader>j !python -m json.tool<CR>

" prevent automatic line feed
set formatoptions=q
set textwidth=0

" encoding
set encoding=utf-8

" --- about fold settings ---
" save fold settings
autocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif

" load fold settings
autocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif

" Don't save options.
set viewoptions-=options

" --- about plugins ---
" neocomplcache snippets
let g:neocomplcache_snippets_dir = '~/.vim/after/snippets'
let g:neocomplcache_enable_at_startup = 1
imap <C-k>	<Plug>(neocomplcache_snippets_expand)
smap <C-k>	<Plug>(neocomplcache_snippets_expand)

" powerline
let g:Powerline_symbols = 'fancy'

"" vim-latex
"let tex_flavor = 'latex'
"set grepprg=grep\ -nH\ $*
"set shellslash
"let g:Tex_DefaultTargetFormat = 'pdf'
"let g:Tex_CompileRule_dvi = 'platex --interaction=nonstopmode $*'
"let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
"let g:Tex_FormatDependency_pdf = 'dvi,pdf'

" neobundle
set nocompatible
filetype off

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
	call neobundle#rc(expand('~/.vim/bundle'))
endif

"NeoBundle 'jcf/vim-latex'
NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/neobundle.vim.git'
NeoBundle 'Shougo/neocomplcache-snippets-complete.git'
NeoBundle 'thinca/vim-quickrun.git'
NeoBundle 'koron/dicwin-vim.git'
NeoBundle 'Lokaltog/vim-powerline'

NeoBundle 'jsx/jsx.vim.git'
NeoBundle 'jelera/vim-javascript-syntax.git'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'digitaltoad/vim-jade.git'

filetype plugin on
filetype indent on

" --- about colors ---
" 256 colors
set t_Co=256

" background
set background=dark

" colorscheme
colorscheme xoria256

" syntax
if &t_Co > 1
	syntax enable
endif
