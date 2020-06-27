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

" ------PLUGINS-----
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'xavierd/clang_complete'
Plugin 'jiangmiao/auto-pairs'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'reedes/vim-pencil'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-fugitive'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
call vundle#end()            " required
filetype plugin indent on    " required



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

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsEditSplit="vertical"

let g:netwr_banner=0
let g:netwr_browse_split=4
let g:netwn_altv=1
let g:netwn_liststyle=3
let g:netwn_list_hide=netrw_gitignore#Hide()
let g:netwn_list_hide=',\(^\|\s\s\)\zs\.\S\+'


" syntatic 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_python_python_exec = '/Library/Frameworks/Python.framework/Versions/3.8/bin/python3.8'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_compiler_options = ' -std=c++0x'
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_include_dirs = [ 'includes', 'headers', '../includes', '../headers' ]

" clang_complete 
" path to directory where library can be found
let g:clang_library_path='/Library/Developer/CommandLineTools/usr/include/c++/v1'
" or path directly to the library file
" let g:clang_library_path='/usr/lib64/libclang.so.3.8'

