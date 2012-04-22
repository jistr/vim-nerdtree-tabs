" === plugin configuration variables ===

" open NERDTree on gvim/macvim startup
if !exists('g:nerdtree_tabs_open_on_gui_startup')
  let g:nerdtree_tabs_open_on_gui_startup = 1
endif

" open NERDTree on console vim startup (off by default)
if !exists('g:nerdtree_tabs_open_on_console_startup')
  let g:nerdtree_tabs_open_on_console_startup = 0
endif

" On startup - focus NERDTree when opening a directory, focus the file if
" editing a specified file
if !exists('g:nerdtree_tabs_smart_startup_focus')
  let g:nerdtree_tabs_smart_startup_focus = 1
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

" synchronize focus when switching tabs (focus NERDTree after tab switch
" if and only if it was focused before tab switch)
if !exists('g:nerdtree_tabs_synchronize_focus')
  let g:nerdtree_tabs_synchronize_focus = 1
endif

" when switching into a tab, make sure that focus will always be in file
" editing window, not in NERDTree window (off by default)
if !exists('g:nerdtree_tabs_focus_on_files')
  let g:nerdtree_tabs_focus_on_files = 0
endif

" === plugin mappings ===
noremap <silent> <script> <Plug>NERDTreeTabsToggle :call <SID>NERDTreeToggleAllTabs()
noremap <silent> <script> <Plug>NERDTreeMirrorToggle :call <SID>NERDTreeMirrorToggle()

" === plugin commands ===
command! NERDTreeTabsToggle call <SID>NERDTreeToggleAllTabs()
command! NERDTreeMirrorToggle call <SID>NERDTreeMirrorToggle()


" === initialization ===

let s:disable_handlers_for_tabdo = 0

" global on/off NERDTree state
" the exists check is to enable script reloading without resetting the state
if !exists('s:nerdtree_globally_active')
  let s:nerdtree_globally_active = 0
endif

" === NERDTree manipulation (opening, closing etc.) ===

" automatic NERDTree mirroring on tab switch
fun! s:NERDTreeMirrorIfGloballyActive()
  let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()

  " if NERDTree is not active in the current tab, try to mirror it
  if s:nerdtree_globally_active && !l:nerdtree_open
    let l:previous_winnr = winnr("$")
    silent NERDTreeMirror

    " if the window count of current tab changed, it means that NERDTreeMirror
    " was successful and we should move focus to the next window
    if l:previous_winnr != winnr("$")
      wincmd w
    endif

    " restoring focus to NERDTree with RestoreFocus makes windows behave
    " wrong, so make sure it does not focus NERDTree
    let s:is_nerdtree_globally_focused = 0
  endif
endfun

" close NERDTree across all tabs
fun! s:NERDTreeCloseAllTabs()
  let s:nerdtree_globally_active = 0

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo silent NERDTreeClose
  exe 'tabn ' . l:current_tab
endfun

" switch NERDTree on for current tab -- mirror it if possible, otherwise create it
fun! s:NERDTreeMirrorOrCreate()
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
endfun

" switch NERDTree on for all tabs while making sure there is only one NERDTree buffer
fun! s:NERDTreeMirrorOrCreateAllTabs()
  let s:nerdtree_globally_active = 1

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo call s:NERDTreeMirrorOrCreate()
  exe 'tabn ' . l:current_tab
endfun

" toggle NERDTree in current tab and match the state in all other tabs
fun! s:NERDTreeToggleAllTabs()
  let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()
  let s:disable_handlers_for_tabdo = 1

  if l:nerdtree_open
    call s:NERDTreeCloseAllTabs()
  else
    call s:NERDTreeMirrorOrCreateAllTabs()
    " force focus to NERDTree in current tab
    if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
      exe bufwinnr(t:NERDTreeBufName) . "wincmd w"
    endif
  endif

  let s:disable_handlers_for_tabdo = 0
endfun

" toggle NERDTree in current tab, use mirror if possible
fun! s:NERDTreeMirrorToggle()
  let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()

  if l:nerdtree_open
    silent NERDTreeClose
  else
    call s:NERDTreeMirrorOrCreate()
  endif
endfun

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
fun! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1 && winnr("$") == 1
    q
  endif
endfun

" === focus functions ===

" if the current window is NERDTree, move focus to the next window
fun! s:NERDTreeFocus()
  if !s:IsCurrentWindowNERDTree() && exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
    exe bufwinnr(t:NERDTreeBufName) . "wincmd w"
  endif
endfun

" if the current window is NERDTree, move focus to the next window
fun! s:NERDTreeUnfocus()
  " save current window so that it's focus can be restored after switching
  " back to this tab
  let t:NERDTreeTabLastWindow = winnr()
  if s:IsCurrentWindowNERDTree()
    wincmd w
  endif
endfun

fun! s:SaveGlobalFocus()
  let s:is_nerdtree_globally_focused = s:IsCurrentWindowNERDTree()
endfun

" restore focus to the window that was focused before leaving current tab
fun! s:RestoreFocus()
  if g:nerdtree_tabs_synchronize_focus
    if s:is_nerdtree_globally_focused
      call s:NERDTreeFocus()
    elseif exists("t:NERDTreeTabLastWindow") && exists("t:NERDTreeBufName") && t:NERDTreeTabLastWindow != bufwinnr(t:NERDTreeBufName)
      exe t:NERDTreeTabLastWindow . "wincmd w"
    endif
  elseif exists("t:NERDTreeTabLastWindow")
    exe t:NERDTreeTabLastWindow . "wincmd w"
  endif
endfun

fun! s:ShouldFocusBeOnNERDTreeAfterStartup()
  return strlen(bufname('$')) == 0 || !getbufvar('$', '&modifiable')
endfun

" === utility functions ===

" check if NERDTree is open in current tab
fun! s:IsNERDTreeOpenInCurrentTab()
  return exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
endfun

" check if NERDTree is present in current tab (not necessarily visible)
fun! s:IsNERDTreePresentInCurrentTab()
  return exists("t:NERDTreeBufName")
endfun

" returns 1 if current window is NERDTree, false otherwise
fun! s:IsCurrentWindowNERDTree()
  return exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) == winnr()
endfun

" === NERDTree view manipulation (scroll and cursor positions) ===

fun! s:SaveNERDTreeViewIfPossible()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) == winnr()
    " save scroll and cursor etc.
    let s:nerdtree_view = winsaveview()

    " save buffer name (to be able to correct desync by commands spawning
    " a new NERDTree instance)
    let s:nerdtree_buffer = bufname("%")
  endif
endfun

fun! s:RestoreNERDTreeViewIfPossible()
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
endfun

" === event handlers ===

fun! s:LoadPlugin()
  if exists('g:nerdtree_tabs_loaded')
    return
  endif

  autocmd VimEnter * call <SID>VimEnterHandler()
  autocmd TabEnter * call <SID>TabEnterHandler()
  autocmd TabLeave * call <SID>TabLeaveHandler()
  autocmd WinEnter * call <SID>WinEnterHandler()
  autocmd WinLeave * call <SID>WinLeaveHandler()

  let g:nerdtree_tabs_loaded = 1
endfun

fun! s:TabEnterHandler()
  if s:disable_handlers_for_tabdo
    return
  endif

  if g:nerdtree_tabs_open_on_new_tab
    call s:NERDTreeMirrorIfGloballyActive()
  endif
  if g:nerdtree_tabs_synchronize_view
    call s:RestoreNERDTreeViewIfPossible()
  endif

  if g:nerdtree_tabs_focus_on_files
    call s:NERDTreeUnfocus()
  else
    call s:RestoreFocus()
  endif
endfun

fun! s:TabLeaveHandler()
  if g:nerdtree_tabs_meaningful_tab_names
    call s:SaveGlobalFocus()
    call s:NERDTreeUnfocus()
  endif
endfun

fun! s:WinEnterHandler()
  if s:disable_handlers_for_tabdo
    return
  endif

  if g:nerdtree_tabs_autoclose
    call s:CloseIfOnlyNerdTreeLeft()
  endif
endfun

fun! s:WinLeaveHandler()
  if s:disable_handlers_for_tabdo
    return
  endif

  if g:nerdtree_tabs_synchronize_view
    call s:SaveNERDTreeViewIfPossible()
  endif
endfun

fun! s:VimEnterHandler()
  let l:open_nerd_tree_on_startup = (g:nerdtree_tabs_open_on_console_startup && !has('gui_running')) ||
                                  \ (g:nerdtree_tabs_open_on_gui_startup && has('gui_running'))
  " this makes sure that globally_active is true when using 'gvim .'
  let s:nerdtree_globally_active = l:open_nerd_tree_on_startup

  if l:open_nerd_tree_on_startup
    let l:focus_file = !s:ShouldFocusBeOnNERDTreeAfterStartup()
    let l:main_bufnr = bufnr('%')

    call s:NERDTreeMirrorOrCreateAllTabs()

    if l:focus_file && g:nerdtree_tabs_smart_startup_focus
      exe bufwinnr(l:main_bufnr) . "wincmd w"
    endif
  endif
endfun

call s:LoadPlugin()

