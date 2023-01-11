" vscode theme, install in ~/.vim/colors/
colorscheme codedark

" set clipboard to X, depends vim-{gtk,X11} package, vim --version | grep clip
set clipboard=unnamedplus

" use mouse to choose tabs / splits
set mouse=a

" Turn on line numbering
set number
set numberwidth=5

" Ignore case in search
set ignorecase

" add ruler on 80 column and make sure its executed
set colorcolumn=80
au BufEnter * set colorcolumn=80

" disable line wrap
set formatoptions-=t
set textwidth=0
set wrap!

" tabbing will act as an indent when you start the next line
set smartindent

" tabbing will be 4 spaces wide instead 8 spaces wide as well as indents
set tabstop=4
set shiftwidth=4

" changes local leader (default \) timeout time, it acts like a toggle
set timeoutlen=90000

" spell checker on f6 and syntax on/off on f7/C-f7
nnoremap <F6> :setlocal spell! spelllang=en_us<CR>
nnoremap <F7> :syntax on<CR>
nnoremap <F8> :syntax off<CR>

" use column in insert mode
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

" normal + command mode can be escaped w/ jk or kj
inoremap jk <Esc>
inoremap kj <Esc>
cnoremap jk <Esc>
cnoremap kj <Esc>

" backspace will scroll up lines like a normal text editor
set backspace=indent,eol,start

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

"# --- Markdown --- #

" Add *.md to filetype markdown
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

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
