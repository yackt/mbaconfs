
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
set tabstop=4
set shiftwidth=4
set softtabstop=0
set expandtab

" tab and space of eol
set list
set listchars=tab:^\ ,trail:~

" setting for cursor
nnoremap j gj
nnoremap k gk

" statusline setting
set laststatus=2

" column number
set number

" setting for json
map <Leader>j !python -m json.tool<CR>

" setting for perl tidy
map <Leader>pt !perltidy<CR>

" prevent automatic line feed
set formatoptions=q
set textwidth=0

" encoding
set encoding=utf-8
"set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932

" ambiwidth
set ambiwidth=double

" setting for clipboard
set clipboard=unnamed,autoselect

" setting for quickrun sql
let g:quickrun_config = {}
let g:quickrun_config['sql'] = {
			\ 'command': 'mysql',
			\ 'exec': ['%c %o < %s'],
			\ 'cmdopt': '%{MakeMySQLCommandOptions()}',
			\ }

let g:mysql_config_host = 'localhost'
let g:mysql_config_port = '30000'
let g:mysql_config_user = 'root'
function! MakeMySQLCommandOptions()
	if !exists("g:mysql_config_host")
		let g:mysql_config_host = input("host> ")
	endif
	if !exists("g:mysql_config_port")
		let g:mysql_config_port = input("port> ")
	endif
	if !exists("g:mysql_config_user")
		let g:mysql_config_user = input("user> ")
	endif
	if !exists("g:mysql_config_pass")
		let g:mysql_config_pass = inputsecret("password> ")
	endif
	if !exists("g:mysql_config_db")
		let g:mysql_config_db = input("database> ")
	endif

	let optlist = []
	if g:mysql_config_user != ''
		call add(optlist, '-u ' . g:mysql_config_user)
	endif
	if g:mysql_config_host != ''
		call add(optlist, '-h ' . g:mysql_config_host)
	endif
	if g:mysql_config_pass != ''
		call add(optlist, '-p' . g:mysql_config_pass)
	endif
	if g:mysql_config_port != ''
		call add(optlist, '-P ' . g:mysql_config_port)
	endif
	if exists("g:mysql_config_otheropts")
		call add(optlist, g:mysql_config_otheropts)
	endif

	call add(optlist, g:mysql_config_db)
	return join(optlist, ' ')
endfunction

noremap <silent> <Leader>h :QuickRun sql<CR>

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

" neobundle
set nocompatible
filetype off

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
	call neobundle#rc(expand('~/.vim/bundle'))
endif

" open-browser
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

NeoBundle 'jcf/vim-latex'
NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/neobundle.vim.git'
NeoBundle 'Shougo/neosnippet.git'
NeoBundle 'thinca/vim-quickrun.git'
NeoBundle 'koron/dicwin-vim.git'
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'kana/vim-fakeclip'
NeoBundle 'tyru/open-browser.vim'

NeoBundle 'jsx/jsx.vim.git'
NeoBundle 'jelera/vim-javascript-syntax.git'

" for template
NeoBundle 'digitaltoad/vim-jade.git'
NeoBundle 'uggedal/jinja-vim'
NeoBundle 'motemen/xslate-vim'
NeoBundle 'gurisugi/microtemplate.vim'

filetype plugin on
filetype indent on

" --- about vim-latex ---
let tex_flavor = 'latex'
set grepprg=grep\ -nH\ $*
set shellslash
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_dvi = 'platex --interaction=nonstopmode $*'
let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
let g:Tex_FormatDependency_pdf = 'dvi,pdf'

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
