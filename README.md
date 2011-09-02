# NERDTree and tabs together in Vim, painlessly

## Installation

1. Copy the plugin to your vim config dir (via pathogen or any way you want).

2. Map :NERDTreeTabsToggle command to some combo so you don't have to use it as
   a command. Alternatively, you can use plug-mapping like this:

        map <Leader>n <plug>NERDTreeTabsToggle<CR>

3. Celebrate.

## Features

In short, this vim plugin aims at making **NERDTree feel like a true panel**,
independent of tabs. That is done by keeping the NERDTree synchronized between
tabs as much as possible. Read on for details.

### One command, open everywhere, close everywhere

You'll get one new command: `:NERDTreeTabsToggle`

For the needs of most of us, this is the only command to operate NERDTree from
now on, so make sure to map it on a key combo ;) Press it once, NERDTree opens
in all tabs (even in new tabs created from now on); press it again, NERDTree
closes in all tabs.

### Just one NERDTree

Tired of having a fully collapsed NERDTree every time you open a new tab?
Vim-nerdtree-tabs will keep them all synchronized. You will get just one
NERDTree buffer for all your tabs.

### Meaningful tab captions

You know the feeling when you want to switch to *that file* and you have 8 tabs
open and they are all named 'NERD_tree_1'? Won't happen again. When leaving
a tab, vim-nerdtree-tabs moves focus out of NERDTree so that the tab caption is
the name of the file you are editing.

### Close the file = close the tab

Tab with NERDTree and a file won't hang open when you close the file. NERDTree
will close automatically and so will the tab.

## Credits

* The tab autoclose feature is stolen from Carl Lerche & Yehuda Katz's
  [Janus](https://github.com/carlhuda/janus). Thanks, guys!

