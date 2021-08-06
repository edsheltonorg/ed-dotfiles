" set clipboard to X, depends vim-{gtk,X11} package, vim --version | grep clip
set clipboard=unnamedplus

" zenburn theme, install in ~/.vim/colors/
"color zenburn
"let g:zenburn_high_Contrast=1

" vscode theme
colorscheme codedark

" use column in insert mode
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

" Dim inactive windows
function! s:DimInactiveWindows()
  for i in range(1, tabpagewinnr(tabpagenr(), '$'))
    let l:range = ""
    if i != winnr()
      if &wrap
        let l:width=256 " max
      else
        let l:width=winwidth(i)
      endif
      let l:range = join(range(1, l:width), ',')
    endif
    call setwinvar(i, '&colorcolumn', l:range)
  endfor
endfunction
augroup DimInactiveWindows
  au!
  au WinEnter * call s:DimInactiveWindows()
  au WinEnter * set cursorline
  au WinLeave * set nocursorline
augroup END

" if exists('$TMUX')
    " let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    " let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
" else
    " let &t_SI = "\e[5 q"
    " let &t_EI = "\e[2 q"
" endif

" use mouse to choose tabs / splits
set mouse=a

" add ruler on 80 column and make sure its executed
set colorcolumn=80
au BufEnter * set colorcolumn=80

" save file w/ sudo permissions even in normal mode w/ :w!!
cmap w!! w !sudo tee > /dev/null %

" Turns on relative row numbering + numbering by default, makes more condensed, and adds C-n keys to enable / disable
"set relativenumber
set number
set numberwidth=5

" When searching you ignore case of words
set ignorecase

" changes local leader (default \) timeout time, it acts like a toggle
set timeoutlen=90000

" spell checker on f6 and syntax on/off on f7/C-f7
nnoremap <F6> :setlocal spell! spelllang=en_us<CR>
nnoremap <F7> :syntax on<CR>
nnoremap <F8> :syntax off<CR>

" C-f to use first autocorrect solution behind or on cursor in insert mode and normal mode
imap <c-f> <c-g>u<Esc>[s1z=`]a<c-g>u
nmap <c-f> [s1z=<c-o>

" normal + command mode can be escaped w/ jk or kj
inoremap jk <Esc>
inoremap kj <Esc>
cnoremap jk <Esc>
cnoremap kj <Esc>

" backspace will scroll up lines like a normal text editor
set backspace=indent,eol,start

" fix for some plugins not liking .md as the extension for a .markdown
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" tabbing will act as an indent when you start the next line
set smartindent

" tabbing will be 4 spaces wide instead 8 spaces wide as well as indents
set tabstop=4
set shiftwidth=4

"" autosave folds and autoloads them on open
au WinLeave * mkview
au WinEnter * silent loadview

" remap spacebar to fold open/close (za) if able to, if not space
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>

" markdown + rmarkdown syntax folding through header level
function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif
    return "="
endfunction
au BufEnter *.md setlocal foldexpr=MarkdownLevel()
au BufEnter *.md setlocal foldmethod=expr
au BufEnter *.rmd setlocal foldexpr=MarkdownLevel()
au BufEnter *.rmd setlocal foldmethod=expr

" vim plug
call plug#begin()
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
call plug#end()

" disable line wrap
set formatoptions-=t
set textwidth=0
set wrap!

