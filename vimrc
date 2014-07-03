"pathogen
"call pathogen#infect()
execute pathogen#infect()

:let mapleader=","

"status bar
"Add full file path to your existing statusline
set statusline+=%F
"set modeline
set ls=2
"set title

"language tools
set nocompatible
filetype plugin on
let g:languagetool_jar='/Users/believe/software/LanguageTool-2.5/languagetool-commandline.jar'

"solarized
se t_Co=16
syntax enable
"let g:solarized_termcolors=16
"let g:solarized_contrast="high"
"let g:solarized_termtrans=1
set background=light
"set background=dark
"colorscheme solarized

"python compiler
set makeprg=ipython\ %
set autowrite

set vb
set ruler

"vim wiki
"set nocompatible
filetype plugin on  
syntax on

"this makes the bash aliases seen by vim
"set shellcmdflag=-ic

set number
" Enable CursorLine
set cursorline
set cursorcolumn
set clipboard+=unnamed
"highlight CursorColumn ctermfg=black ctermbg=Grey

""ino kj <esc>
""imap <tab> <esc> 
ino jj <esc>
vno v <esc>

" Default Colors for CursorLine
"highlight  CursorLine ctermbg=Yellow ctermfg=None

" Change Color when entering Insert Mode
"autocmd InsertEnter * highlight  CursorLine ctermbg=Green ctermfg=Red

" Revert Color to default when leaving Insert Mode
"autocmd InsertLeave * highlight  CursorLine ctermbg=Yellow ctermfg=None


" ============== Latex =================
syntax on
filetype plugin on
set grepprg=grep\ -nH\ $*
let g:Tex_GotoError = 0
let g:tex_flavor='latex'
" let g:Tex_DefaultTargetFormat='dvi'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_pdf='pdflatex -interaction=nonstopmode $*'
let g:Tex_CompileRule_dvi='latex -interaction=nonstopmode $*'
let g:Tex_ViewRule_ps = 'Preview'
let g:Tex_ViewRule_pdf = 'Skim'
let g:Tex_ViewRule_dvi = 'Skim'
let g:Tex_MultipleCompileFormats = 'dvi,pdf'
let g:Tex_FoldedSections = 'myeqs,subsection'
let g:Tex_FoldedCommands = 'myeqs'
"let g:Tex_TreatMacViewerAsUNIX= 1
let g:Imap_UsePlaceHolders = 0
map <f2> :w<cr><leader>ll
" ======================================

vmap <F2> :w !pbcopy<CR><CR>:!osascript /Users/believe/Dropbox/scripts/system/select_octave_window.scpt<CR><CR>
vmap <F3> :w !pbcopy<CR><CR>:!osascript /Users/believe/Dropbox/scripts/system/select_executer_window.scpt<CR><CR>
vmap <F4> :w !pbcopy<CR><CR>:!osascript /Users/believe/Dropbox/scripts/system/select_python_window.scpt<CR><CR>
map <F5> :call Pp()<CR><CR><CR>

"map <F5> :.w<CR>:!/Applications/Matlab/Matlab_R2011a.app/bin/matlab -nodesktop -nosplash -r "try, run %:p, pause, catch, end, quit"<CR><CR>

" The matlab Connection

map <F55> :call MatlabRun()<CR><CR>
map <S-F6> :call RunMatlab()<CR><CR>

func! MatlabRun()
  exec "w"
  exec "!matlab-ctrl.py \"". expand("%:r") . "\""
endfunc

func! RunMatlab()
  exec "w"
  call system("matlab-launch.sh \"" . expand("%:r") . "\"")
endfunc

func! Pp(nlines)
  execute 'r !tail -n ' . a:nlines . ' /tmp/clipbuf'
endfunc

command! -nargs=1 Pcb call Pp(<f-args>)

func! QE(switch)
  if a:switch == "pw"
      exec "tabe $QE/Doc/INPUT_PW.txt"
  elseif a:switch == "bands"
      exec "tabe $QE/Doc/INPUT_BANDS.txt"
  elseif a:switch == "pp"
      exec "tabe $QE/Doc/INPUT_PP.txt"
  elseif a:switch == "proj"
      exec "tabe $QE/Doc/INPUT_PROJWFC.txt"
  else
      echom "Your selection doesn't match any QE manual"
  endif
endfunc

func! A()
  ""2014_06_01_raw.html
endfunc

function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
  let ft=toupper(a:filetype)
  let group='textGroup'.ft
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
  try
    execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif
  execute 'syntax region textSnip'.ft.'
  \ matchgroup='.a:textSnipHl.'
  \ start="'.a:start.'" end="'.a:end.'"
  \ contains=@'.group
endfunction

call TextEnableCodeSnip('matlab', '@begin=m@',  '@end=m@',  'SpecialComment' )
call TextEnableCodeSnip('python', '@begin=py@', '@end=py@', 'SpecialComment' )
call TextEnableCodeSnip('sh', '@begin=sh@', '@end=sh@', 'SpecialComment' )

command! C  ?#%%?;/#%%/ y
command! Ac let @+ .= getline('.')

nnoremap <silent> <localleader>b :call Ca()<cr>
func! Ca()
    let @a=@+
    normal! "Ayy
    let @+=@a
endfunc

au FileType mail call FT_mail()

function! FT_mail()
    set nocindent
    set noautoindent
    set wrap linebreak nolist
    set textwidth=0
    " reformat for 72 char lines
    " normal gggqGgg
    " settings
    setlocal spell spelllang=en
    " setlocal fileencoding=iso8859-1,utf-8
    set fileencodings=iso8859-1,utf-8
    " abbreviations
    iabbr  gd Good Day!
endfunction

function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

"to swich to a shell
noremap <C-d> :sh<cr>
