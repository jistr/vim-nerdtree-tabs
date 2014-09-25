" === plugin configuration variables === {{{
"
" open NERDTree on gvim/macvim startup
if !exists('g:nerdtree_tabs_open_on_gui_startup')
  let g:nerdtree_tabs_open_on_gui_startup = 1
endif

" open NERDTree on console vim startup (off by default)
if !exists('g:nerdtree_tabs_open_on_console_startup')
  let g:nerdtree_tabs_open_on_console_startup = 0
endif

" do not open NERDTree if vim starts in diff mode
if !exists('g:nerdtree_tabs_no_startup_for_diff')
    let g:nerdtree_tabs_no_startup_for_diff = 1
endif

" On startup - focus NERDTree when opening a directory, focus the file if
" editing a specified file. When set to `2`, always focus file after startup.
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

" when starting up with a directory name as a parameter, cd into it
if !exists('g:nerdtree_tabs_startup_cd')
  let g:nerdtree_tabs_startup_cd = 1
endif

" automatically find and select currently opened file
if !exists('g:nerdtree_tabs_autofind')
  let g:nerdtree_tabs_autofind = 0
endif
"
" }}}
" === plugin mappings === {{{
"
noremap <silent> <script> <Plug>NERDTreeTabsOpen     :call <SID>NERDTreeOpenAllTabs()
noremap <silent> <script> <Plug>NERDTreeTabsClose    :call <SID>NERDTreeCloseAllTabs()
noremap <silent> <script> <Plug>NERDTreeTabsToggle   :call <SID>NERDTreeToggleAllTabs()
noremap <silent> <script> <Plug>NERDTreeTabsFind     :call <SID>NERDTreeFindFile()
noremap <silent> <script> <Plug>NERDTreeMirrorOpen   :call <SID>NERDTreeMirrorOrCreate()
noremap <silent> <script> <Plug>NERDTreeMirrorToggle :call <SID>NERDTreeMirrorToggle()
noremap <silent> <script> <Plug>NERDTreeSteppedOpen  :call <SID>NERDTreeSteppedOpen()
noremap <silent> <script> <Plug>NERDTreeSteppedClose :call <SID>NERDTreeSteppedClose()
noremap <silent> <script> <Plug>NERDTreeFocusToggle  :call <SID>NERDTreeFocusToggle()
"
" }}}
" === plugin commands === {{{
"
command! NERDTreeTabsOpen     call <SID>NERDTreeOpenAllTabs()
command! NERDTreeTabsClose    call <SID>NERDTreeCloseAllTabs()
command! NERDTreeTabsToggle   call <SID>NERDTreeToggleAllTabs()
command! NERDTreeTabsFind     call <SID>NERDTreeFindFile()
command! NERDTreeMirrorOpen   call <SID>NERDTreeMirrorOrCreate()
command! NERDTreeMirrorToggle call <SID>NERDTreeMirrorToggle()
command! NERDTreeSteppedOpen  call <SID>NERDTreeSteppedOpen()
command! NERDTreeSteppedClose call <SID>NERDTreeSteppedClose()
command! NERDTreeFocusToggle  call <SID>NERDTreeFocusToggle()
"
" }}}
" === plugin functions === {{{
"
" === NERDTree manipulation (opening, closing etc.) === {{{
"
" s:NERDTreeMirrorOrCreate() {{{
"
" switch NERDTree on for current tab -- mirror it if possible, otherwise create it
fun! s:NERDTreeMirrorOrCreate()
  let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()

  " if NERDTree is not active in the current tab, try to mirror it
  if !l:nerdtree_open
    let l:previous_winnr = winnr("$")

    silent NERDTreeMirror

    " if the window count of current tab didn't increase after NERDTreeMirror,
    " it means NERDTreeMirror was unsuccessful and a new NERDTree has to be created
    if l:previous_winnr == winnr("$")
      silent NERDTreeToggle
    endif
  endif
endfun

" }}}
" s:NERDTreeMirrorToggle() {{{
"
" toggle NERDTree in current tab, use mirror if possible
fun! s:NERDTreeMirrorToggle()
  let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()

  if l:nerdtree_open
    silent NERDTreeClose
  else
    call s:NERDTreeMirrorOrCreate()
  endif
endfun

" }}}
" s:NERDTreeOpenAllTabs() {{{
"
" switch NERDTree on for all tabs while making sure there is only one NERDTree buffer
fun! s:NERDTreeOpenAllTabs()
  let s:nerdtree_globally_active = 1

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo call s:NERDTreeMirrorOrCreate()
  exe 'tabn ' . l:current_tab
endfun

" }}}
" s:NERDTreeCloseAllTabs() {{{
"
" close NERDTree across all tabs
fun! s:NERDTreeCloseAllTabs()
  let s:nerdtree_globally_active = 0

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo silent NERDTreeClose
  exe 'tabn ' . l:current_tab
endfun

" }}}
" s:NERDTreeToggleAllTabs() {{{
"
" toggle NERDTree in current tab and match the state in all other tabs
fun! s:NERDTreeToggleAllTabs()
  let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()
  let s:disable_handlers_for_tabdo = 1

  if l:nerdtree_open
    call s:NERDTreeCloseAllTabs()
  else
    call s:NERDTreeOpenAllTabs()
    " force focus to NERDTree in current tab
    if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
      exe bufwinnr(t:NERDTreeBufName) . "wincmd w"
    endif
  endif

  let s:disable_handlers_for_tabdo = 0
endfun

" }}}
" s:NERDTreeSteppedOpen() {{{
"
" focus the NERDTree view, creating one first if none is present
fun! s:NERDTreeSteppedOpen()
  if !s:IsCurrentWindowNERDTree()
    if s:IsNERDTreeOpenInCurrentTab()
      call s:NERDTreeFocus()
    else
      call s:NERDTreeMirrorOrCreate()
    endif
  endif
endfun

" }}}
" s:NERDTreeSteppedClose{() {{{
"
" unfocus the NERDTree view or closes it if it hadn't had focus at the time of
" the call
fun! s:NERDTreeSteppedClose()
  if s:IsCurrentWindowNERDTree()
    call s:NERDTreeUnfocus()
  else
    let l:nerdtree_open = s:IsNERDTreeOpenInCurrentTab()

    if l:nerdtree_open
      silent NERDTreeClose
    endif
  endif
endfun

" }}}
" s:NERDTreeFocusToggle() {{{
"
" focus the NERDTree view or creates it if in a file,
" or unfocus NERDTree view if in NERDTree
fun! s:NERDTreeFocusToggle()
  let s:disable_handlers_for_tabdo = 1
  if s:IsCurrentWindowNERDTree()
    call s:NERDTreeUnfocus()
  else
    if !s:IsNERDTreeOpenInCurrentTab()
      call s:NERDTreeOpenAllTabs()
    endif
    call s:NERDTreeFocus()
  endif
  let s:disable_handlers_for_tabdo = 0
endfun
" }}}
"
" === NERDTree manipulation (opening, closing etc.) === }}}
" === focus functions === {{{
"
" s:NERDTreeFocus() {{{
"
" if the current window is NERDTree, move focus to the next window
fun! s:NERDTreeFocus()
  if !s:IsCurrentWindowNERDTree() && exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
    exe bufwinnr(t:NERDTreeBufName) . "wincmd w"
  endif
endfun

" }}}
" s:NERDTreeUnfocus() {{{
"
" if the current window is NERDTree, move focus to the next window
fun! s:NERDTreeUnfocus()
  " save current window so that it's focus can be restored after switching
  " back to this tab
  let t:NERDTreeTabLastWindow = winnr()
  if s:IsCurrentWindowNERDTree()
    let l:winNum = s:NextNormalWindow()
    if l:winNum != -1
      exec l:winNum.'wincmd w'
    else
      wincmd w
    endif
  endif
endfun

" }}}
" s:NERDTreeRestoreFocus() {{{
"
" restore focus to the window that was focused before leaving current tab
fun! s:NERDTreeRestoreFocus()
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

" }}}
" s:SaveGlobalFocus() {{{
"
fun! s:SaveGlobalFocus()
  let s:is_nerdtree_globally_focused = s:IsCurrentWindowNERDTree()
endfun

" }}}
" s:IfFocusOnStartup() {{{
"
fun! s:IfFocusOnStartup()
  return strlen(bufname('$')) == 0 || !getbufvar('$', '&modifiable')
endfun

" }}}
"
" === focus functions === }}}
" === utility functions === {{{
"
" s:NextNormalWindow() {{{
"
" find next window with a normal buffer
fun! s:NextNormalWindow()
  let l:i = 1
  while(l:i <= winnr('$'))
    let l:buf = winbufnr(l:i)

    " skip unlisted buffers
    if buflisted(l:buf) == 0
      let l:i = l:i + 1
      continue
    endif

    " skip un-modifiable buffers
    if getbufvar(l:buf, '&modifiable') != 1
      let l:i = l:i + 1
      continue
    endif

    " skip temporary buffers with buftype set
    if empty(getbufvar(l:buf, "&buftype")) != 1
      let l:i = l:i + 1
      continue
    endif

    return l:i
  endwhile
  return -1
endfun

" }}}
" s:CloseIfOnlyNerdTreeLeft() {{{
"
" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
fun! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1 && winnr("$") == 1
    q
  endif
endfun

" }}}
" s:IsCurrentWindowNERDTree() {{{
"
" returns 1 if current window is NERDTree, false otherwise
fun! s:IsCurrentWindowNERDTree()
  return exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) == winnr()
endfun

" }}}
" s:IsNERDTreeOpenInCurrentTab() {{{
"
" check if NERDTree is open in current tab
fun! s:IsNERDTreeOpenInCurrentTab()
  return exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
endfun

" }}}
" s:IsNERDTreePresentInCurrentTab() {{{
"
" check if NERDTree is present in current tab (not necessarily visible)
fun! s:IsNERDTreePresentInCurrentTab()
  return exists("t:NERDTreeBufName")
endfun

" }}}
"
" === utility functions === }}}
" === NERDTree view manipulation (scroll and cursor positions) === {{{
"
" s:SaveNERDTreeViewIfPossible() {{{
"
fun! s:SaveNERDTreeViewIfPossible()
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) == winnr()
    " save scroll and cursor etc.
    let s:nerdtree_view = winsaveview()

    " save NERDTree window width
    let s:nerdtree_width = winwidth(winnr())

    " save buffer name (to be able to correct desync by commands spawning
    " a new NERDTree instance)
    let s:nerdtree_buffer = bufname("%")
  endif
endfun

" }}}
" s:RestoreNERDTreeViewIfPossible() {{{
"
fun! s:RestoreNERDTreeViewIfPossible()
  " if nerdtree exists in current tab, it is the current window and if saved
  " state is available, restore it
  let l:view_state_saved = exists('s:nerdtree_view') && exists('s:nerdtree_width')
  if s:IsNERDTreeOpenInCurrentTab() && l:view_state_saved
    let l:current_winnr = winnr()
    let l:nerdtree_winnr = bufwinnr(t:NERDTreeBufName)

    " switch to NERDTree window
    exe l:nerdtree_winnr . "wincmd w"
    " load the correct NERDTree buffer if not already loaded
    if exists('s:nerdtree_buffer') && t:NERDTreeBufName != s:nerdtree_buffer
      silent NERDTreeClose
      silent NERDTreeMirror
    endif
    " restore cursor, scroll and window width
    call winrestview(s:nerdtree_view)
    exe "vertical resize " . s:nerdtree_width

    " switch back to whatever window was focused before
    exe l:current_winnr . "wincmd w"
  endif
endfun

" }}}
" s:NERDTreeFindFile() {{{
"
fun! s:NERDTreeFindFile()
  if s:IsNERDTreeOpenInCurrentTab()
    silent NERDTreeFind
  endif
endfun

" }}}
"
" === NERDTree view manipulation (scroll and cursor positions) === }}}
"
" === plugin functions ===  }}}
" === plugin event handlers === {{{
"
" s:LoadPlugin() {{{
"
fun! s:LoadPlugin()
  if exists('g:nerdtree_tabs_loaded')
    return
  endif

  let g:NERDTreeHijackNetrw = 0

  let s:disable_handlers_for_tabdo = 0

  " global on/off NERDTree state
  " the exists check is to enable script reloading without resetting the state
  if !exists('s:nerdtree_globally_active')
    let s:nerdtree_globally_active = 0
  endif

  " global focused/unfocused NERDTree state
  " the exists check is to enable script reloading without resetting the state
  if !exists('s:is_nerdtree_globally_focused')
    call s:SaveGlobalFocus()
  end

  augroup NERDTreeTabs
    autocmd!
    autocmd VimEnter * call <SID>VimEnterHandler()
    autocmd TabEnter * call <SID>TabEnterHandler()
    autocmd TabLeave * call <SID>TabLeaveHandler()
    autocmd WinEnter * call <SID>WinEnterHandler()
    autocmd WinLeave * call <SID>WinLeaveHandler()
    autocmd BufWinEnter * call <SID>BufWinEnterHandler()
    autocmd BufRead * call <SID>BufReadHandler()
  augroup END

  let g:nerdtree_tabs_loaded = 1
endfun

" }}}
" s:VimEnterHandler() {{{
"
fun! s:VimEnterHandler()
  " if the argument to vim is a directory, cd into it
  if g:nerdtree_tabs_startup_cd && isdirectory(argv(0))
    exe 'cd ' . escape(argv(0), '\ ')
  endif

  let l:open_nerd_tree_on_startup = (g:nerdtree_tabs_open_on_console_startup && !has('gui_running')) ||
                                  \ (g:nerdtree_tabs_open_on_gui_startup && has('gui_running'))

  if g:nerdtree_tabs_no_startup_for_diff && &diff
      let l:open_nerd_tree_on_startup = 0
  endif

  " this makes sure that globally_active is true when using 'gvim .'
  let s:nerdtree_globally_active = l:open_nerd_tree_on_startup

  if l:open_nerd_tree_on_startup
    let l:focus_file = !s:IfFocusOnStartup()
    let l:main_bufnr = bufnr('%')

    if !s:IsNERDTreePresentInCurrentTab()
      call s:NERDTreeOpenAllTabs()
    endif

    if (l:focus_file && g:nerdtree_tabs_smart_startup_focus == 1) || g:nerdtree_tabs_smart_startup_focus == 2
      exe bufwinnr(l:main_bufnr) . "wincmd w"
    endif
  endif
endfun

" }}} s:NewTabCreated {{{
"
" A flag to indicate that a new tab has just been created.
"
" We will handle the remaining work for this newly created tab separately in
" BufWinEnter event.
"
let s:NewTabCreated = 0

" }}}
" s:TabEnterHandler() {{{
"
fun! s:TabEnterHandler()
  if s:disable_handlers_for_tabdo
    return
  endif

  if g:nerdtree_tabs_open_on_new_tab && s:nerdtree_globally_active && !s:IsNERDTreeOpenInCurrentTab()
    call s:NERDTreeMirrorOrCreate()

    " move focus to the previous window
    wincmd p

    " Turn on the 'NewTabCreated' flag
    let s:NewTabCreated = 1
  endif

  if g:nerdtree_tabs_synchronize_view
    call s:RestoreNERDTreeViewIfPossible()
  endif

  if g:nerdtree_tabs_focus_on_files
    call s:NERDTreeUnfocus()
  " Do not restore focus on newly created tab here
  elseif !s:NewTabCreated
    call s:NERDTreeRestoreFocus()
  endif
endfun

" }}}
" s:TabLeaveHandler() {{{
"
fun! s:TabLeaveHandler()
  if g:nerdtree_tabs_meaningful_tab_names
    call s:SaveGlobalFocus()
    call s:NERDTreeUnfocus()
  endif
endfun

" }}}
" s:WinEnterHandler() {{{
"
fun! s:WinEnterHandler()
  if s:disable_handlers_for_tabdo
    return
  endif

  if g:nerdtree_tabs_autoclose
    call s:CloseIfOnlyNerdTreeLeft()
  endif
endfun

" }}}
" s:WinLeaveHandler() {{{
"
fun! s:WinLeaveHandler()
  if s:disable_handlers_for_tabdo
    return
  endif

  if g:nerdtree_tabs_synchronize_view
    call s:SaveNERDTreeViewIfPossible()
  endif
endfun

" }}}
" s:BufWinEnterHandler() {{{
"
" BufWinEnter event only gets triggered after a new buffer has been
" successfully loaded, it is a proper time to finish the remaining
" work for newly opened tab.
"
fun! s:BufWinEnterHandler()
  if s:NewTabCreated
    " Turn off the 'NewTabCreated' flag
    let s:NewTabCreated = 0

    " Restore focus to NERDTree if necessary
    if !g:nerdtree_tabs_focus_on_files
      call s:NERDTreeRestoreFocus()
    endif
  endif
endfun

" }}}
" s:BufReadHandler() {{{
"
" BufRead event gets triggered after a new buffer has been
" successfully read from file.
"
fun! s:BufReadHandler()
  " Refresh NERDTree to show currently opened file
  if g:nerdtree_tabs_autofind
    call s:NERDTreeFindFile()
    call s:NERDTreeUnfocus()
  endif
endfun

" }}}
"
" === plugin event handlers === }}}

call s:LoadPlugin()
