" === plugin configuration variables ===

" open NERDTree on gvim/macvim startup
if !exists('g:nerdtree_tabs_open_on_gui_startup')
  let g:nerdtree_tabs_open_on_gui_startup = 1
endif

" open NERDTree on console vim startup
if !exists('g:nerdtree_tabs_open_on_console_startup')
  let g:nerdtree_tabs_open_on_console_startup = 0
endif

" Open NERDTree on new tab creation if NERDTree was globally opened
" by :NERDTreeTabsToggle
if !exists('g:nerdtree_tabs_open_on_new_tab')
  let g:nerdtree_tabs_open_on_new_tab = 1
endif

" unfocus NERDTree when leaving a tab so that you have descriptive tab names
" and not names like 'NERD_tree_1'
if !exists('g:nerdtree_tabs_meaningful_tab_names')
  let g:nerdtree_tabs_meaningful_tab_names = 1
endif

" close current tab if there is only one window in it and it's NERDTree
if !exists('g:nerdtree_tabs_autoclose')
  let g:nerdtree_tabs_autoclose = 1
endif

" synchronize view of all NERDTree windows (scroll and cursor position)
if !exists('g:nerdtree_tabs_synchronize_view')
  let g:nerdtree_tabs_synchronize_view = 1
endif

" === plugin mappings ===
noremap! <silent> <unique> <script> <Plug>NERDTreeTabsToggle :call <SID>NERDTreeToggleAllTabs()
noremap! <silent> <unique> <script> <Plug>NERDTreeMirrorToggle :call <SID>NERDTreeMirrorToggle()

" === plugin commands ===
command! NERDTreeTabsToggle call <SID>NERDTreeToggleAllTabs()
command! NERDTreeMirrorToggle call <SID>NERDTreeMirrorToggle()


" === rest of the code ===

" global on/off NERDTree state
let s:nerdtree_globally_active = 0

" automatic NERDTree mirroring on tab switch
function! s:NERDTreeMirrorIfGloballyActive()
  let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()

  " if NERDTree is not active in the current tab, try to mirror it
  let l:previous_winnr = winnr("$")
  if s:nerdtree_globally_active && !l:nerdtree_open
    silent NERDTreeMirror

    " if the window count of current tab changed, it means that NERDTreeMirror
    " was successful and we should move focus to the next window
    if l:previous_winnr != winnr("$")
      wincmd w
    endif
  endif
endfunction

" close NERDTree across all tabs
function! s:NERDTreeCloseAllTabs()
  let s:nerdtree_globally_active = 0

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo silent NERDTreeClose
  exe 'tabn ' . l:current_tab
endfunction

" switch NERDTree on for current tab -- mirror it if possible, otherwise create it
function! s:NERDTreeMirrorOrCreate()
  let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()

  " if NERDTree is not active in the current tab, try to mirror it
  let l:previous_winnr = winnr("$")
  if !l:nerdtree_open
    silent NERDTreeMirror

    " if the window count of current tab didn't increase after NERDTreeMirror,
    " it means NERDTreeMirror was unsuccessful and a new NERDTree has to be created
    if l:previous_winnr == winnr("$")
      silent NERDTreeToggle
    endif
  endif
endfunction

" switch NERDTree on for all tabs while making sure there is only one NERDTree buffer
function! s:NERDTreeMirrorOrCreateAllTabs()
  let s:nerdtree_globally_active = 1

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo call s:NERDTreeMirrorOrCreate()
  exe 'tabn ' . l:current_tab
endfunction

" toggle NERDTree in current tab and match the state in all other tabs
function! s:NERDTreeToggleAllTabs()
  let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()

  if l:nerdtree_open
    call s:NERDTreeCloseAllTabs()
  else
    call s:NERDTreeMirrorOrCreateAllTabs()
    " force focus to NERDTree in current tab
    if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
      exe bufwinnr(t:NERDTreeBufName) . "wincmd w"
    endif
  endif
endfunction

" toggle NERDTree in current tab, use mirror if possible
function! s:NERDTreeMirrorToggle()
  let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()

  if l:nerdtree_open
    silent NERDTreeClose
  else
    call s:NERDTreeMirrorOrCreate()
  endif
endfunction

" if the current window is NERDTree, move focus to the next window
function! s:NERDTreeUnfocus()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) == winnr()
    wincmd w
  endif
endfunction

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1 && winnr("$") == 1
    q
  endif
endfunction

" check if NERDTree is open in current tab
function! s:IsNERDTreeOpenInCurrentTab()
  let l:nerdtree_active = exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
  return l:nerdtree_active
endfunction

function! s:SaveNERDTreeViewIfPossible()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) == winnr()
    " save scroll and cursor etc.
    let s:nerdtree_view = winsaveview()

    " save buffer name (to be able to correct desync by commands spawning
    " a new NERDTree instance)
    let s:nerdtree_buffer = bufname("%")
  endif
endfunction

function! s:RestoreNERDTreeViewIfPossible()
  " if nerdtree exists in current tab, it is the current window and if saved
  " state is available, restore it
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1 && exists('s:nerdtree_view')
    let l:current_winnr = winnr()
    let l:nerdtree_winnr = bufwinnr(t:NERDTreeBufName)

    " switch to NERDTree window
    exe l:nerdtree_winnr . "wincmd w"
    " load the correct NERDTree buffer if not already loaded
    if exists('s:nerdtree_buffer') && t:NERDTreeBufName != s:nerdtree_buffer
      silent NERDTreeClose
      silent NERDTreeMirror
    endif
    " restore cursor and scroll
    call winrestview(s:nerdtree_view)
    exe l:current_winnr . "wincmd w"
  endif
endfunction

" === event handlers ===

fun! s:GuiEnterHandler()
  if g:nerdtree_tabs_open_on_gui_startup
    call s:NERDTreeMirrorOrCreateAllTabs()
  endif
endfun

fun! s:VimEnterHandler()
  if g:nerdtree_tabs_open_on_console_startup && !has('gui_running')
    call s:NERDTreeMirrorOrCreateAllTabs()
  endif
endfun

fun! s:TabEnterHandler()
  if g:nerdtree_tabs_open_on_new_tab
    call s:NERDTreeMirrorIfGloballyActive()
  endif
  if g:nerdtree_tabs_synchronize_view
    call s:RestoreNERDTreeViewIfPossible()
  endif
endfun

fun! s:TabLeaveHandler()
  if g:nerdtree_tabs_meaningful_tab_names
    call s:NERDTreeUnfocus()
  endif
endfun

fun! s:WinEnterHandler()
  if g:nerdtree_tabs_autoclose
    call s:CloseIfOnlyNerdTreeLeft()
  endif
endfun

fun! s:WinLeaveHandler()
  if g:nerdtree_tabs_synchronize_view
    call s:SaveNERDTreeViewIfPossible()
  endif
endfun

autocmd GuiEnter * call <SID>GuiEnterHandler()
autocmd VimEnter * call <SID>VimEnterHandler()
autocmd TabEnter * call <SID>TabEnterHandler()
autocmd TabLeave * call <SID>TabLeaveHandler()
autocmd WinEnter * call <SID>WinEnterHandler()
autocmd WinLeave * call <SID>WinLeaveHandler()

