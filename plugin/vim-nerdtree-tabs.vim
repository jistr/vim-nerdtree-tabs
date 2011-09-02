" TODO: add configuration options
" TODO: preserve NERDTree cursor and scroll position across tabs

" global on/off NERDTree state
let s:nerd_tree_is_active = 0

" automatic NERDTree mirroring on tab switch
" when having just one window in the tab
function s:NERDTreeMirrorIfActive()
  if winnr("$") < 2 && s:nerd_tree_is_active
    NERDTreeMirror

    " hack to move the focus from the NERDTree to the main window
    " FIXME: make this less stupid and error prone
    wincmd p
    wincmd l
  endif
endfunction

" close NERDTree across all tabs
function s:NERDTreeCloseAllTabs()
  let s:nerd_tree_is_active = 0

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo silent NERDTreeClose
  exe 'tabn ' . l:current_tab
endfunction

" switch NERDTree on for current tab -- mirror it if possible, otherwise create it
function s:NERDTreeMirrorOrCreate()
  " is NERDTree active in the current tab?
  let l:active_buffers_current_tab = map(filter(range(0, bufnr('$')), 'bufwinnr(v:val)>=0'), 'bufname(v:val)')
  let l:nerd_tree_active = -1 != match(l:active_buffers_current_tab, 'NERD_tree_\d\+')

  " if NERDTree is not active in the current tab, try to mirror it
  let l:previous_winnr = winnr("$")
  if !l:nerd_tree_active
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
  let s:nerd_tree_is_active = 1

  " tabdo doesn't preserve current tab - save it and restore it afterwards
  let l:current_tab = tabpagenr()
  tabdo call s:NERDTreeMirrorOrCreate()
  exe 'tabn ' . l:current_tab
endfunction

" toggle NERDTree in current tab and match the state in all other tabs
function s:NERDTreeToggleAllTabs()
  " is NERDTree active in the current tab?
  let l:active_buffers_current_tab = map(filter(range(0, bufnr('$')), 'bufwinnr(v:val)>=0'), 'bufname(v:val)')
  let l:nerd_tree_active = -1 != match(l:active_buffers_current_tab, 'NERD_tree_\d\+')

  if l:nerd_tree_active
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

" === event handlers ===

fun s:GuiEnterHandler()
  call s:NERDTreeMirrorOrCreateAllTabs()
endfun

fun s:TabEnterHandler()
  call s:NERDTreeMirrorIfActive()
endfun

fun s:TabLeaveHandler()
  call s:NERDTreeUnfocus()
endfun

autocmd GuiEnter * silent call <SID>GuiEnterHandler()
autocmd TabEnter * silent call <SID>TabEnterHandler()
autocmd TabLeave * silent call <SID>TabLeaveHandler()

" === plugin mappings ===
noremap <silent> <unique> <script> <Plug>NERDTreeTabsToggle :call <SID>NERDTreeToggleAllTabs()

" === plugin commands ===
command NERDTreeTabsToggle call <SID>NERDTreeToggleAllTabs()
