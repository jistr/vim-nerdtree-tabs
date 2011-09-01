
" global on/off NERDTree state
let g:nerd_tree_is_active = 0

" automatic NERDTree mirroring on tab switch
" when having just one window in the tab
function NERDTreeMirrorIfActive()
  if winnr("$") < 2 && g:nerd_tree_is_active
    NERDTreeMirror

    " hack to move the focus from the NERDTree to the main window
    wincmd p
    wincmd l
  endif
endfunction

function NERDTreeCloseAllTabs()
  let g:nerd_tree_is_active = 0
  let l:current_tab = tabpagenr()
  tabdo silent NERDTreeClose
  exe 'tabn ' . l:current_tab
endfunction

function NERDTreeMirrorOrCreate()
  let l:active_buffers_current_tab = map(filter(range(0, bufnr('$')), 'bufwinnr(v:val)>=0'), 'bufname(v:val)')
  let l:nerd_tree_active = -1 != match(l:active_buffers_current_tab, 'NERD_tree_\d\+')
  let l:previous_winnr = winnr("$")
  if !l:nerd_tree_active
    silent NERDTreeMirror
    if l:previous_winnr == winnr("$")
      silent NERDTreeToggle
    endif
  endif
endfunction

function NERDTreeMirrorOrCreateAllTabs()
  let g:nerd_tree_is_active = 1
  let l:current_tab = tabpagenr()
  tabdo call NERDTreeMirrorOrCreate()
  exe 'tabn ' . l:current_tab
endfunction

function NERDTreeToggleAllTabs()
  let l:active_buffers_current_tab = map(filter(range(0, bufnr('$')), 'bufwinnr(v:val)>=0'), 'bufname(v:val)')
  let l:nerd_tree_active = -1 != match(l:active_buffers_current_tab, 'NERD_tree_\d\+')
  if l:nerd_tree_active
    call NERDTreeCloseAllTabs()
  else
    call NERDTreeMirrorOrCreateAllTabs()
  endif
endfunction

function NERDTreeUnfocus()
  if match(bufname('%'), 'NERD_tree_\d\+') == 0
    wincmd w
  endif
endfunction

autocmd GuiEnter * silent call NERDTreeMirrorOrCreateAllTabs()
autocmd TabEnter * silent call NERDTreeMirrorIfActive()
autocmd TabLeave * silent call NERDTreeUnfocus()
