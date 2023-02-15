" vim: comment
set number 
set nu 

set backspace=indent,eol,start

set tabstop=4
set shiftwidth=4
set smartindent
set smarttab
syntax on


set showcmd

" for searching file quickly 
set path+=**
set wildmenu

set nocompatible              " be iMproved, required
filetype off                  " required

" -----MAPPING-----
cnoremap ;; <C-c>

map <C-n> :NERDTreeToggle<CR>
map <C-m> :TagbarToggle<CR>

imap <C-h> <esc>0i
imap <C-l> <esc>$i<right>
imap <C-d> <esc>o
nmap <C-h> <esc>0
nmap <C-l> <esc>$<right>

" map <C-s> <esc>:w<CR>
" noremap <silent> <C-s>          :update<CR>
" vnoremap <silent> <C-s>         <C-C>:update<CR>
" inoremap <silent> <C-s>         <C-O>:update<CR>
nmap <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>a


