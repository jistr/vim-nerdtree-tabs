" TODO: preserve NERDTree cursor and scroll position across tabs

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
noremap <silent> <unique> <script> <Plug>NERDTreeTabsToggle :call <SID>NERDTreeToggleAllTabs()

" === plugin commands ===
command NERDTreeTabsToggle call <SID>NERDTreeToggleAllTabs()


" === rest of the code ===

" global on/off NERDTree state
let s:nerd_tree_globally_active = 0

" automatic NERDTree mirroring on tab switch
function s:NERDTreeMirrorIfGloballyActive()
  let l:nerd_tree_open = s:IsNERDTreeOpenInCurrentTab()

  " if NERDTree is not active in the current tab, try to mirror it
  let l:previous_winnr = winnr("$")
  if s:nerd_tree_globally_active && !l:nerd_tree_open
    silent NERDTreeMirror

    " if the window count of current tab changed, it means that NERDTreeMirror
    " was successful and we should move focus to the next window
    if l:previous_winnr != winnr("$")
      wincmd w
    endif
  endif
endfunction

" close NERDTree across all tabs
function s:NERDTreeCloseAllTabs()
  let s:nerd_tree_globally_active = 0

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo silent NERDTreeClose
  exe 'tabn ' . l:current_tab
endfunction

" switch NERDTree on for current tab -- mirror it if possible, otherwise create it
function s:NERDTreeMirrorOrCreate()
  let l:nerd_tree_open = s:IsNERDTreeOpenInCurrentTab()

  " if NERDTree is not active in the current tab, try to mirror it
  let l:previous_winnr = winnr("$")
  if !l:nerd_tree_open
    silent NERDTreeMirror

    " if the window count of current tab didn't increase after NERDTreeMirror,
    " it means NERDTreeMirror was unsuccessful (no NERDTree buffer exists) and
    " a new NERDTree has to be created
    if l:previous_winnr == winnr("$")
      silent NERDTreeToggle
    endif
  endif
endfunction

" switch NERDTree on for all tabs while making sure there is only one NERDTree buffer
function s:NERDTreeMirrorOrCreateAllTabs()
  let s:nerd_tree_globally_active = 1

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo call s:NERDTreeMirrorOrCreate()
  exe 'tabn ' . l:current_tab
endfunction

" toggle NERDTree in current tab and match the state in all other tabs
function s:NERDTreeToggleAllTabs()
  let l:nerd_tree_open = s:IsNERDTreeOpenInCurrentTab()

  if l:nerd_tree_open
    call s:NERDTreeCloseAllTabs()
  else
    call s:NERDTreeMirrorOrCreateAllTabs()
  endif
endfunction

" if the current window is NERDTree, move focus to the next window
function s:NERDTreeUnfocus()
  if match(bufname('%'), 'NERD_tree_\d\+') == 0
    wincmd w
  endif
endfunction

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" check if NERDTree is open in current tab
function s:IsNERDTreeOpenInCurrentTab()
  let l:active_buffers_current_tab = map(filter(range(0, bufnr('$')), 'bufwinnr(v:val)>=0'), 'bufname(v:val)')
  let l:nerd_tree_active = -1 != match(l:active_buffers_current_tab, 'NERD_tree_\d\+')
  return l:nerd_tree_active
endfunction

function s:SaveNERDTreeViewIfPossible()
  if match(bufname('%'), 'NERD_tree_\d\+') == 0
    let s:nerdtree_view = winsaveview()
  endif
endfunction

function s:RestoreNERDTreeViewIfPossible()
  " if nerdtree exists in current tab, it is the current window and if saved
  " state is available, restore it
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1 && exists('s:nerdtree_view')
    let l:current_winnr = winnr()
    let l:nerdtree_winnr = bufwinnr(t:NERDTreeBufName)

    exe l:nerdtree_winnr . "wincmd w"
    call winrestview(s:nerdtree_view)
    exe l:current_winnr . "wincmd w"
  endif
endfunction


" === event handlers ===

fun s:GuiEnterHandler()
  if g:nerdtree_tabs_open_on_gui_startup
    call s:NERDTreeMirrorOrCreateAllTabs()
  endif
endfun

fun s:VimEnterHandler()
  if g:nerdtree_tabs_open_on_console_startup && !has('gui_running')
    call s:NERDTreeMirrorOrCreateAllTabs()
  endif
endfun

fun s:TabEnterHandler()
  if g:nerdtree_tabs_open_on_new_tab
    call s:NERDTreeMirrorIfGloballyActive()
  endif
  if g:nerdtree_tabs_synchronize_view
    call s:RestoreNERDTreeViewIfPossible()
  endif
endfun

fun s:TabLeaveHandler()
  if g:nerdtree_tabs_meaningful_tab_names
    call s:NERDTreeUnfocus()
  endif
endfun

fun s:WinEnterHandler()
  if g:nerdtree_tabs_autoclose
    call s:CloseIfOnlyNerdTreeLeft()
  endif
endfun

fun s:WinLeaveHandler()
  if g:nerdtree_tabs_synchronize_view
    call s:SaveNERDTreeViewIfPossible()
  endif
endfun

autocmd GuiEnter * silent call <SID>GuiEnterHandler()
autocmd VimEnter * silent call <SID>VimEnterHandler()
autocmd TabEnter * silent call <SID>TabEnterHandler()
autocmd TabLeave * silent call <SID>TabLeaveHandler()
autocmd WinEnter * silent call <SID>WinEnterHandler()
autocmd WinLeave * silent call <SID>WinLeaveHandler()

