# vim-nerdtree-tabs changelog

## v1.3.0

* Focus synchronization - ability to have focus on NERDTree after tab switch
  if and only if it was focused before tab switch. Switched on by default.

## v1.2.1

* Smart startup focus fixed.

## v1.2.0

* Loading process refactoring (should fix some glitches and hopefully not
  break anything else). Directory structure has changed in this release,
  a new pull of the repository is required for the plugin to work properly.

## v1.1.2

* Smart focus - on startup, focus NERDTree if opening a directory, focus the
  file when opening a file.

## v1.1.1

* About 50% speedup when toggling NERDTree on across all tabs.

## v1.1.0

* Meaningful tab names feature doesn't collide with opening new tabs silently.
  To accomplish that, tab switching now preserves window focus. The original
  behavior that always kept focus in the window with file being edited can be
  restored by `let g:nerdtree_tabs_focus_on_files = 1`.
* Removed glitches when sourcing the plugin more than once.

## v1.0.1

* Plugin is usable with vundle.

## v1.0.0

* NERDTree view synchronization (cursor position and scroll) across tabs
* Fix: focus is now on NERDTree when opening it in all tabs.
* If you create more NERDTree instances, nerdtree-tabs now tries hard to sync
  all tabs to the last opened one.

## v0.2.0

* Better solution for opening NERDTree on tab creation (fixes wrong behavior in
  improbable situations)
* Global variables for configuration
* Tab autoclose
* Option to open NERDTree on console vim startup, stays false by default
* Readme


## v0.1.0

* New mappings and a command, otherwise original functionality preserved while making it namespaced
