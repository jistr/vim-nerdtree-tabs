# NERDTree and tabs together in Vim, painlessly

## Features

This plugin aims at making NERDTree feel like a true panel, independent of tabs.

* **Just one NERDTree**, always and ever. It will always look the same in
  all tabs, including expanded/collapsed nodes, scroll position etc.

* Open in all tabs / close in all tabs. Do this via `:NERDTreeTabsToggle`

* Meaningful tab captions for inactive tabs. No more captions like 'NERD_tree_1'.

* When you close a file, the tab closes with it. No NERDTree hanging open.

* Autoopen NERDTree on GVim / MacVim startup.

Many of these features can be switched off. See section Configuration.

## Installation

1. If you haven't already, install NERDTree (see https://github.com/scrooloose/nerdtree)

2.  Install the plugin **through Pathogen**:

        cd ~/.vim/bundle
        git clone https://github.com/jistr/vim-nerdtree-tabs.git

    Or **through Vundle**:

        Bundle 'jistr/vim-nerdtree-tabs'

    Or **through Janus**:

        cd ~/.janus
        git clone https://github.com/jistr/vim-nerdtree-tabs.git

3. Map :NERDTreeTabsToggle command to some combo so you don't have to type it.
   Alternatively, you can use plug-mapping instead of a command, like this:

        map <Leader>n <plug>NERDTreeTabsToggle<CR>

4. Celebrate.

## Commands and Mappings

Vim-nerdtree-tabs provides these commands:

* `:NERDTreeTabsOpen` switches NERDTree on for all tabs.

* `:NERDTreeTabsClose` switches NERDTree off for all tabs.

* `:NERDTreeTabsToggle` toggles NERDTree on/off for all tabs.

* `:NERDTreeTabsFind` find currently opened file and select it

* `:NERDTreeMirrorOpen` acts as `:NERDTreeMirror`, but smarter: When opening,
  it first tries to use an existing tree (i.e. previously closed in this tab or
  perform a mirror of another tab's tree). If all this fails, a new tree is
  created. It is recommended that you use this command instead of
  `:NERDTreeMirror`.

* `:NERDTreeMirrorToggle` toggles NERDTree on/off in current tab, using
  the same behavior as `:NERDTreeMirrorOpen`.

* `:NERDTreeSteppedOpen` focuses the NERDTree, opening one first if none is present.

* `:NERDTreeSteppedClose` unfocuses the NERDTree, or closes/hides it if it was
  not focused.

* `:NERDTreeFocusToggle` focus the NERDTree or create it if focus is
  on a file, unfocus NERDTree if focus is on NERDTree

There are also plug-mappings available with the same functionality:

* `<plug>NERDTreeTabsOpen`
* `<plug>NERDTreeTabsClose`
* `<plug>NERDTreeTabsToggle`
* `<plug>NERDTreeTabsFind`
* `<plug>NERDTreeMirrorOpen`
* `<plug>NERDTreeMirrorToggle`
* `<plug>NERDTreeSteppedOpen`
* `<plug>NERDTreeSteppedClose`

## Configuration

You can switch on/off some features of the plugin by setting global vars to 1
(for on) or 0 (for off) in your vimrc. Here are the options and their default
values:

* `g:nerdtree_tabs_open_on_gui_startup` (default: `1`)  
  Open NERDTree on gvim/macvim startup

* `g:nerdtree_tabs_open_on_console_startup` (default: `0`)  
  Open NERDTree on console vim startup

* `g:nerdtree_tabs_no_startup_for_diff` (default: `1`)  
  Do not open NERDTree if vim starts in diff mode

* `g:nerdtree_tabs_smart_startup_focus` (default: `1`)  
  On startup, focus NERDTree if opening a directory, focus file if opening
  a file. (When set to `2`, always focus file window after startup).

* `g:nerdtree_tabs_open_on_new_tab` (default: `1`)  
  Open NERDTree on new tab creation (if NERDTree was globally opened by
  :NERDTreeTabsToggle)

* `g:nerdtree_tabs_meaningful_tab_names` (default: `1`)  
  Unfocus NERDTree when leaving a tab for descriptive tab names

* `g:nerdtree_tabs_autoclose` (default: `1`)  
  Close current tab if there is only one window in it and it's NERDTree

* `g:nerdtree_tabs_synchronize_view` (default: `1`)  
  Synchronize view of all NERDTree windows (scroll and cursor position)

* `g:nerdtree_tabs_synchronize_focus` (default: `1`)  
  Synchronize focus when switching windows (focus NERDTree after tab switch
  if and only if it was focused before tab switch)

* `g:nerdtree_tabs_focus_on_files` (default: `0`)  
  When switching into a tab, make sure that focus is on the file window,
  not in the NERDTree window. (Note that this can get annoying if you use
  NERDTree's feature "open in new tab silently", as you will lose focus on the
  NERDTree.)

* `g:nerdtree_tabs_startup_cd` (default: `1`)  
  When given a directory name as a command line parameter when launching Vim,
  `:cd` into it.

* `g:nerdtree_tabs_autofind` (default: `0`)  
  Automatically find and select currently opened file in NERDTree.

### Example

To run NERDTreeTabs on console vim startup, put into your .vimrc:

    let g:nerdtree_tabs_open_on_console_startup=1

## Credits

The tab autoclose feature is stolen from Carl Lerche & Yehuda Katz's
[Janus](https://github.com/carlhuda/janus). Thanks, guys!

