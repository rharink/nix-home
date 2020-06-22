" Personal preference .vimrc file
" Maintained by Robert den Harink <robert@robhar.com>
"
"
" This must be first, because it changes other options as a side effect.
set nocompatible

syntax on

" Change shell
set shell=bash                  " Vim expects a POSIX-compliant shell, which Fish (my default shell) is not

" Change the mapleader from \ to ,
let mapleader=","
let maplocalleader="\\"

" Folding rules {{{
set foldenable                  " enable folding
set foldcolumn=2                " add a fold column
set foldmethod=marker           " detect triple-{ style fold markers
set foldlevelstart=99           " start out with everything unfolded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                                " which commands trigger auto-unfold
function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
    return line . ' …' . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction
set foldtext=MyFoldText()

" Mappings to easily toggle fold levels
nnoremap z0 :set foldlevel=0<cr>
nnoremap z1 :set foldlevel=1<cr>
nnoremap z2 :set foldlevel=2<cr>
nnoremap z3 :set foldlevel=3<cr>
nnoremap z4 :set foldlevel=4<cr>
nnoremap z5 :set foldlevel=5<cr>
" }}}

" Options {{{
set so=7                            " Set 7 lines to the cursor - when moving vertically using j/k
let $LANG='en'                      " Avoid garbled chars in Chinese etc.
set langmenu=en
set wildmenu                        " Turn on wildmenu
set ruler
set magic                           " For regular expressions turn magic on

" Configure backspace the way it should work
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set lazyredraw                      " Don't redraw while executing macros (good performance config)
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set cmdheight=2                     " Give more space for displaying messages
set noshowmode                      " Hide INSERT/VISUAL messages
set mouse=a                         " Copy selected text with mouse to system clipboard
set undofile                        " Save undos after file closes
set wildmode=longest:list,full      " Complete longest common string, then each full match
set updatetime=250                  " If this many milliseconds nothing is typed the swap file will be written to disk
set visualbell                      " Turn off the audio bell (no beeps)
set clipboard^=unnamed              " Make copy work with system clipboard
set gdefault                        " Always do global substitutions
set title                           " Set terminal title
set whichwrap+=<,>,[,]
set completeopt-=preview            " No annoying scratch preview above
set expandtab                       " Spaces on tabs
set shiftwidth=4
set softtabstop=2
set undolevels=1000
set smartindent                     " Indentation
set shortmess=Ia                    " Disable startup message
set shortmess+=c                    " Don't pass messages to |ins-completion-menu|.
set fileencoding=utf-8              " Encoding when written to file
set fileformat=unix                 " Line endings
set timeout timeoutlen=1000 ttimeoutlen=10 " TODO: ?
set autowrite                       " Automatically save before :next, :make etc
set ignorecase                      " Search case insensitive:
set smartcase                       " .. but not when search pattern contains upper case characters
set nocursorcolumn
set nocursorline
set number
set wrap
set textwidth=79
set formatoptions=qrn1
set notimeout
set ttimeout
set ttimeoutlen=10
set nobackup                        " Don't create annoying backup files
set path=+**                        " Search down into subfolders

" Buffers
set hidden

" Searching
set wrapscan
set ignorecase
set smartcase

" Usable 'Tab'
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab

" UI
set cursorline                      " Highlight current line
set showmatch
set tabstop=4                       " Default indentation is 4 spaces long and uses tabs, not spaces
set matchtime=2
set termguicolors                   " Enable true colors support

set completeopt+=menu,menuone       " Completion

set grepprg=rg\ --vimgrep
set grepformat^=%f:%l:%c:%m
set viewoptions=cursor,slash,unix

let $NVIM_TUI_ENABLE_TRUE_COLOR=1   " True color

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" }}}

" Mappings {{{
" File browsing
map <C-n> :NERDTreeToggle<CR>
nnoremap <leader>ff :Files<CR>
map <leader>bb :Buffers<CR>
" Source vimrc
nnoremap <Leader>vrc :source ~/.config/nvim/init.vim<CR>

" Search and replace
xnoremap gs y:%s/<C-r>"//g<Left><Left>

" Copy line
nnoremap Y y$

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <C-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" }}}

" Theme & Appearance {{{

" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme desert
catch
endtry

set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Set theme
" let ayucolor="dark"   " for dark version of theme
" let g:neodark#background = '#222222'

" colorscheme neodark

" Split borders
" set fillchars+=vert:\|
" hi vertsplit guibg=bg

" Bufferline
let g:bufferline_echo = 0

" }}}

" Auto commands {{{
au FileType dirvish call fugitive#detect(@%)
au FocusLost * :wa " Auto save everything
" }}}

" Other {{{
set guicursor=n-v-c:hor20,i-ci:ver20 " Make cursor block in insert mode and underline in normal mode
set signcolumn=yes

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
" }}}

" Vimtex {{{
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'

" Hardwrap markdown and tex files
au BufRead,BufNewFile *.md setlocal textwidth=79
au BufRead,BufNewFile *.tex setlocal textwidth=79
" }}}

" Coc {{{
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rr <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>rff  <Plug>(coc-format-selected)
nmap <leader>rff  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-felected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" }}}

" Zettelkasten {{{
let g:vimwiki_list = [{'path':'~/vimwiki','ext':'.md','syntax':'markdown'}, {'path': '~/vimwiki'}]

" Filename format. The filename is created using strftime() function
let g:zettel_format = "%y%W%w%file_no"

" command used for VimwikiSearch
" default value is "ag". To use other command, like ripgrep, pass the
" command line and options:
let g:zettel_fzf_command = "rg --column --line-number --ignore-case --no-heading --color=always "
"
" Disable default keymappings
"let g:zettel_default_mappings = 0

" This is basically the same as the default configuration
augroup filetype_vimwiki
  autocmd!
  autocmd FileType vimwiki imap <silent> [[ [[<esc><Plug>ZettelSearchMap
  autocmd FileType vimwiki nmap T <Plug>ZettelYankNameMap
  autocmd FileType vimwiki xmap z <Plug>ZettelNewSelectedMap
  autocmd FileType vimwiki nmap gZ <Plug>ZettelReplaceFileWithLink
augroup END

" Set template and custom header variable for the second Wiki
let g:zettel_options = [{"front_matter" : {"tags" : ""}, "template" :  "~/zettelkasten.tpl"}]
" }}}

" Helper functions {{{
"" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
" }}}
