" =======================================
" Who: Hugues Obolonsky (@hoxca)
" What: .vimrc
" Version: 1.0 
" =======================================

" ----------------------------------------
" Vundle
" ----------------------------------------

set nocompatible " be iMproved
filetype off     " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle, required
Bundle 'gmarik/vundle'

" ---------------
" Plugin Bundles
" ---------------

" Navigation
Bundle 'FuzzyFinder'
" This fork is required due to remapping ; to :
Bundle 'christoomey/vim-space'
Bundle 'minibufexpl.vim'
Bundle 'cmdline-insertdatetime'
" UI Additions
Bundle 'mutewinter/vim-indent-guides'
Bundle 'Lokaltog/vim-powerline'
Bundle 'scrooloose/nerdtree'
" Bundle 'Rykka/ColorV'
Bundle 'mutewinter/ir_black_mod'
Bundle 'wincent/Command-T'

" Commands
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'godlygeek/tabular'
Bundle 'Raimondi/delimitMate'
Bundle 'scrooloose/syntastic'
Bundle 'ervandew/supertab'
Bundle 'gregsexton/MatchTag'
Bundle 'Shougo/neocomplcache'
Bundle 'tComment'

" SnipMate
Bundle "garbas/vim-snipmate"

" SnipMate Depedancies
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "snipmate-snippets"

" Language Additions
Bundle 'vim-ruby/vim-ruby'
Bundle 'html5.vim' 
Bundle 'HTML5-Syntax-File'
Bundle 'pangloss/vim-javascript'

" Libraries
Bundle 'L9'
Bundle 'tpope/vim-repeat'
"Bundle 'rcodetools/rcodetools.vim'

filetype plugin indent on  " Automatically detect file types. (must turn on after Vundle)
au BufRead,BufNewFile *.vm set ft=html syntax=velocity

" ---------------------------------------------------------
" Avoid Platform Specific Configuration (we love Mac OSX)
" ---------------------------------------------------------

if has('gui_macvim')
  " MacVim
  set guifont=Menlo\ Regular:h12

  " Hide Toolbar in MacVim
  if has("gui_running")
    set guioptions=egmrt
  endif

endif

" ----------------------------------------
" Regular Vim Configuartion (No Plugins Needed)
" ----------------------------------------

let g:Powerline_symbols = 'fancy'
let g:molokai_original = 1

" ---------------
" Color
" ---------------

" Conditionally Set colorscheme
if $TERM == 'xterm-256color'
  " Neato, 256 color terminal. We can use ir_black_mod
  colorscheme ir_black_mod
else
  " We can't use ir_black_mod :(
  let g:CSApprox_verbose_level=0
  colorscheme slate
endif

" ---------------
" Backups
" ---------------
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

" ---------------
" UI
" ---------------
set ruler              " Ruler on
" set nu               " Line numbers on
set nowrap             " Line wrapping off
set laststatus=2       " Always show the statusline
set cmdheight=2

" ---------------
" Behaviors
" ---------------
syntax enable
set autoread           " Automatically reload changes if detected
set wildmenu           " Turn on WiLd menu
set hidden             " Change buffer - without saving
set history=1024       " Number of things to remember in history.
set cf                 " Enable error files & error jumping.
set clipboard+=unnamed " Yanks go on clipboard instead.
set autowrite          " Writes on make/shell commands
set timeoutlen=1500    " Time to wait for a command (after leader for example)

set foldlevelstart=99  " Remove folds
set formatoptions=crql

" ---------------
" Text Format
" ---------------
set tabstop=2
set backspace=2        " Delete everything with backspace
set shiftwidth=2       " Tabs under smart indent
set cindent
set autoindent
set smarttab
set expandtab
set pastetoggle=<F2>   " Use F2 to toggle Paste in insert mode"
set backspace=2

" ---------------
" Searching
" ---------------
set ignorecase        " Case insensitive search
set smartcase         " Non-case sensitive search
set incsearch
set hlsearch

" Use CR to discard search highligthning
nnoremap <CR> :noh<CR><CR>:<ESC> 

" ---------------
" Visual
" ---------------
set showcmd            " tune the timeout and show command for leaderkey"
set showmatch          " Show matching brackets.
set matchtime=2        " How many tenths of a second to blink

" ---------------
" Sounds
" ---------------
set noerrorbells
set novisualbell
set t_vb=

" ---------------
" Mouse
" ---------------
set mousehide          " Hide mouse after chars typed
set mouse=nihr         " Mouse in almost all mode (avoid visual)

" Better complete options to speed it up
set complete=.,w,b,u,U

" ----------------------------------------
" Bindings
" ----------------------------------------

set <S-Down>=[1;9B
set <S-UP>=[1;9A
set <S-Right>=[1;9C
set <S-Left>=[1;9D

nmap <silent> <S-Down> :wincmd j<CR>
nmap <silent> <S-Up> :wincmd k<CR>
nmap <silent> <S-Right> :wincmd l<CR>
nmap <silent> <S-Left> :wincmd h<CR>

" insert right spaceship for ruby =>
imap <c-l> <space>=><space>

" Fixes common typos
" command W w!
" command Q q!

map <F1> <Esc>
imap <F1> <Esc>

" Removes doc lookup binding because it's easy to fat finger
nmap K k
vmap K k

" Make line completion easier
imap <C-l> <C-x><C-l>


" Use ; for : in normal and visual mode, less keystrokes
nnoremap ; :
vnoremap ; :
" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" ---------------
" Leader
" ---------------

" Set leader to ,
let mapleader=","

nmap <silent> <leader>s :set spell!<CR>
nmap <silent> <leader>v :e ~/.vim/vimrc<CR>

" ---------------------------------------
" RENAME CURRENT FILE
" ---------------------------------------
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>m :call RenameFile()<cr>
  
" ----------------------------------------
" Auto Commands
" ----------------------------------------

if has("autocmd")
  " No formatting on o key newlines
  autocmd BufNewFile,BufEnter * set formatoptions-=o

  " No more complaining about untitled documents
  autocmd FocusLost silent! :wa

  " When editing a file, always jump to the last cursor position.
  " This must be after the uncompress commands.
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line ("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
endif

" Use F2 to toggle Paste in insert mode
set pastetoggle=<F2>
" tune the timeout and show command for leaderkey
set showcmd

" ----------------------------------------
" Plugin Configuration
" ----------------------------------------

" ---------------
" tComment
" ---------------

let g:tcommentMapLeaderOp1="<Leader>c"
let g:tcommentMapLeaderOp2="<Leader>_"
vmap <leader>b :TCommentBlock<cr>
let g:tcommentOptions =  {'col': 1}
let g:tcommentBlankLines=0

"---------------
" SuperTab
" ---------------
" Set these up for cross-buffer completion (something Neocachecompl has a hard
" time with)
let g:SuperTabDefaultCompletionType="<c-x><c-n>"
let g:SuperTabContextDefaultCompletionType="<c-x><c-n>"

" ---------------
" Neocachecompl
" ---------------
let g:neocomplcache_enable_at_startup=1
let g:neocomplcache_enable_auto_select=1 "Select the first entry automatically
let g:neocomplcache_enable_cursor_hold_i=1
let g:neocomplcache_cursor_hold_i_time=300
let g:neocomplcache_auto_completion_start_length=1

" Tab / Shift-Tab to cycle completions
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Ctrl-K to complete and advance snippet
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)

" ---------------
" Syntastic
" ---------------
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'], 'passive_filetypes': [] }

" --------------------
" Minibuffer Explorer
" --------------------
let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1

" -------------------------
" InsertDate and timestamp
" -------------------------

inoremap <expr> <C-d> strftime('%d-%m-%Y')
cnoremap <expr> <C-X>dt strftime('%Y%m%d')
cnoremap <expr> <C-X>ts strftime('%Y%m%d%H%M')

" ---------------
" FuzzyFinder
" ---------------
let g:fufNextMode="<c-m>"
let g:fuf_modesDisable=['mrucmd'] " Enables FufMruFile

if has('mac') || has('macunix') || has('gui_macvim')
  nnoremap <silent><D-y> :FufMruFile<CR>
  nnoremap <silent><D-u> :FufFileWithCurrentBufferDir<CR>
else
  nnoremap <silent><M-y> :FufMruFile<CR>
  nnoremap <silent><M-u> :FufFileWithCurrentBufferDir<CR>
end
nnoremap <leader>ff :FufFile<CR>
nnoremap <leader>fm :FufMruFile<CR>
nnoremap <leader>fb :FufBuffer<CR>
" ---------------
" ctags
" ---------------
set tags=tags;/

" ---------------
" NERDTree
" ---------------
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>nn :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2 " Change the NERDTree directory to the root node
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" ---------------
" Indent Guides
" ---------------
" let g:indent_guides_auto_colrs=1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=black     ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgray  ctermbg=darkgray

let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_color_change_percent=5

if $TERM == 'xterm-256color' 
      " Make the guides smaller since they will be crazy visible in 256color mode
      let g:indent_guides_guide_size=1
else
  " Turn off the guides when 256color mode isn't available
  let g:indent_guides_enable_on_vim_startup=0
endif

" ---------------
" Session
" ---------------
let g:session_autosave=0
let g:session_autoload=0
nnoremap <leader>os :OpenSession<CR>

" ---------------
" status.vim
" ---------------
let g:statusline_fugitive=1
let g:statusline_fullpath=0

" Everything must be after Right Separator for BufStat
let g:statusline_order=[
      \ 'Filename',
      \ 'Encoding',
      \ 'Help',
      \ 'Filetype',
      \ 'Modified',
      \ 'Fugitive',
      \ 'RVM',
      \ 'TabWarning',
      \ 'Syntastic',
      \ 'Paste',
      \ 'ReadOnly',
      \ 'RightSeperator',
      \ 'CurrentHighlight',
      \ 'CursorColumn',
      \ 'LineAndTotal',
      \ 'FilePercent']

" ---------------
" Browser Refresh
" ---------------
map <silent><leader>r :RRB<CR>
map <silent><F5> :RRB<CR>

" ---------------
" SpeedDating
" ---------------
let g:speeddating_no_mappings=1 " Remove default mappings (C-a etc.)
nmap <silent><leader>dm <Plug>SpeedDatingDown
nmap <silent><leader>dp <Plug>SpeedDatingUp
nmap <silent><leader>dn <Plug>SpeedDatingNowUTC

" --------------
"  Command-T
"  -------------

if has('ruby')
  " --------
  " Use Command T since we've got Ruby
  " --------

  " Conditional Mappings
  if has('unix')
    nnoremap <silent><C-t> :CommandT<CR>
  else
    nnoremap <silent><M-t> :CommandT<CR>
  endif

  " Leader Commands
  nnoremap <leader>t :CommandT<CR>
endif


" ---------------
" Tabular
" ---------------
" nmap <Leader>t= :Tabularize /=<CR>
" vmap <Leader>t= :Tabularize /=<CR>
" nmap <Leader>t: :Tabularize /:\zs<CR>
" vmap <Leader>t: :Tabularize /:\zs<CR>
" nmap <Leader>t, :Tabularize /,\zs<CR>
" vmap <Leader>t, :Tabularize /,\zs<CR>
" nmap <Leader>t> :Tabularize /=>\zs<CR>
" vmap <Leader>t> :Tabularize /=>\zs<CR>

" ---------------
" Vundle
" ---------------
nmap <Leader>bi :BundleInstall<CR>
nmap <Leader>bi! :BundleInstall!<CR>
nmap <Leader>bu :BundleInstall!<CR> " Because this also updates
nmap <Leader>bc :BundleClean<CR>

" ----------------------------------------
" Functions
" ----------------------------------------

" ---------------
" OpenURL
" ---------------

if has('ruby')
ruby << EOF
  require 'open-uri'
  require 'openssl'
  
  def extract_url(url)
    re = %r{(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]\{\};:'".,<>?«»“”‘’]))}

    url.match(re).to_s
  end

  def open_url
    line = VIM::Buffer.current.line

    if url = extract_url(line)
      if RUBY_PLATFORM.downcase =~ /(win|mingw)(32|64)/
        `start cmd /c chrome #{url}`
        VIM::message("Opened #{url}")
      else
        `open #{url}`
        VIM::message("Opened #{url}")
      end
    else
      VIM::message("No URL found on this line.")
    end

  end

  # Returns the contents of the <title> tag of a given page
  def fetch_title(url)
    if RUBY_VERSION < '1.9'
      open(url).read.match(/<title>(.*?)<\/title>?/i)[1]
    else
      open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read.match(/<title>(.*?)<\/title>?/i)[1]
    end
  end

  # Paste the title and url for the url on the clipboard in markdown format: [Title](url)
  # Note: Clobbers p register
  def paste_url_and_title
    clipboard = VIM::evaluate('@+')
    url = extract_url(clipboard)
    if url and url.strip != ""
      puts "Fetching title"
      title = fetch_title(url)
      VIM::command "let @p = '[#{title}](#{url})'"
      VIM::command 'normal! "pp'
    else
      VIM::message("Clipboard does not contain URL: '#{clipboard[1..10]}'...")
    end
  end
EOF

" Open a URL
if !exists("*OpenURL")
  function! OpenURL()
    :ruby open_url
  endfunction
endif

command! OpenUrl call OpenURL()
nnoremap <leader>o :call OpenURL()<CR>

" ---------------
" Paste link with Title
" ---------------

" Open a URL
if !exists("*PasteURLTitle")
  function! PasteURLTitle()
    :ruby paste_url_and_title
  endfunction
endif

command! PasteURLTitle call PasteURLTitle()
map <leader>pt :PasteURLTitle<CR>

endif " endif has('ruby')

" ---------------
" Fix Trailing White Space
" ---------------
map <leader>ws :%s/\s\+$//e<CR>
command! FixTrailingWhiteSpace :%s/\s\+$//e

" ---------------
" Quick spelling fix (first item in z= list)
" ---------------
function! QuickSpellingFix()
  if &spell
    normal 1z=
  else
    " Enable spelling mode and do the correction
    set spell
    normal 1z=
    set nospell
  endif
endfunction

command! QuickSpellingFix call QuickSpellingFix()
nmap <silent> <leader>z :QuickSpellingFix<CR>

autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
