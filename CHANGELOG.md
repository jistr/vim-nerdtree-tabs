# vim-nerdtree-tabs changelog

## v1.4.5

* Add NERDTreeFocusToggle function. (Thanks orthez.)

* More general refactoring and cleanup. (Thanks techlivezheng.)

## v1.4.4

* Option to always focus file window after startup. (Thanks rr-.)

## v1.4.3

* Partial fix for #32. When directory is given as an argument, two nerdtrees
  are open, but both now point into the correct directory. (Thanks szajbus.)

## v1.4.2

* Friendlier when using together with MiniBufExplorer. (Thanks techlivezheng.)

* Do not open NERDTree by default when starting Vim in diff mode. (Thanks
  techlivezheng.)

## v1.4.1

* Fix "cd into" feature for paths that include spaces. (Thanks nybblr.)

## v1.4.0

* When synchronizing NERDTree scroll and cursor position, synchronize also
  NERDTree window width. (Thanks EinfachToll.)

* When Vim is given a directory as a parameter, `:cd` into it. (Thanks DAddYE.)

* New commands `NERDTreeTabsOpen`, `NERDTreeTabsClose` and
  `NERDTreeMirrorOpen`. They are not a new functionality, just externalize
  stuff that was previously accessible only inside the plugin.

* New commands `NERDTreeSteppedOpen` and `NERDTreeSteppedClose` for combined
  opening/closing of a NERDTree and focus switching. Works locally for a tab.
  (Thanks ereOn.)

* Fixed an error when restoring a session caused by accessing an undefined
  variable. (Thanks ereOn.)

* Fixed opening two NERDTrees when `NERDTreeHijackNetrw = 1` and launching
  with a directory name as a parameter.

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
