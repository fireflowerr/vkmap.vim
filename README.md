# vkmap.vim

A quick popup to help remember vim keymaps.
![](https://gist.githubusercontent.com/paroxayte/925ae461adafe0bb5d4a86219f2abd7a/raw/dd2b992163d8e5b76650dc131b4dd77082b3c7f4/expose.gif)

## Features

* Block on prompt - Take a second to remember your mappings
* Floating window support in nvim
* Does not require any additional configuration on your key mappings, just register the maps you already have!
* Smooth - vkmap will never impede the flow of your keypresses

## Installation

Vkmap requires [vwm.vim](https://github.com/paroxayte/vwm.vim) for window creation.

* **dein**: `call dein#add('paroxayte/vkmap.vim')`
* **vimplug:** `Plug 'paroxayte/vkmap.vim'`

## Examples

```vim
" Configure visual keymap interface
let g:vkmap#col_width = 18
let g:vkmap#outer_padding = 1
let g:vkmap#inner_padding = 16
let g:vkmap#floating = 1
let g:vkmap#height = 6

let s:main = {
      \  'key': '<Space>',
      \  'mode': 'n',
      \  'maps':
      \  [
      \    {
      \      'key': 'l',
      \      'dscpt': 'lang-server',
      \      'leader': 1
      \    },
      \    {
      \      'key': 'o',
      \      'dscpt': 'toggle tree',
      \    },
      \    {
      \      'key': 't',
      \      'dscpt': 'toggle terms',
      \    },
      \    {
      \      'key': 'r',
      \      'dscpt': 'refresh',
      \    }
      \  ]
      \}

let s:lsp = {
      \  'key':'<Space>l',
      \  'mode': 'n',
      \  'maps':
      \  [
      \    {
      \      'key': 'd',
      \      'dscpt': 'definition',
      \    },
      \    {
      \      'key': 'i',
      \      'dscpt': 'info',
      \    },
      \    {
      \      'key': 'n',
      \      'dscpt': 'next',
      \    },
      \    {
      \      'key': 'p',
      \      'dscpt': 'prev',
      \    },
      \    {
      \      'key': 'f',
      \      'dscpt': 'find refs',
      \    },
      \    {
      \      'key': 'r',
      \      'dscpt': 'rename',
      \    },
      \    {
      \      'key': 'a',
      \      'dscpt': 'action',
      \    },
      \  ]
      \}
let g:vkmap#menus = [s:main, s:lsp]
```

## FAQ

**Q**: There are already several plugins that do the same thing. Why choose vkmap?<Br/>
**A**: When I made vkmap, I was not aware of these other plugins. However, there are some
features/quriks vkmap has that, to me, makes it worth maintaining. Unlike other plugins, vkmap is
very transparent. It does very little other than displaying a menu, yet this minimalism allows it
to do MORE. Vkmap can accept multiple key presses between mappings (something that to my knowledge
other plugins cannot). Vkmap does not add any unnecessary validation or overhead. It is effectively a transparent
layer hidden in the typehead population.

**Q**: How can I change the color of the floating menu in Nvim?<Br/>
**A**: The color of floating windows is controlled by hi NormalFloat. To change the background color
try `hi NormalFloat guibg=**my_color**`

**Q**: How does vkmap.vim work?<Br/>
**A**: After the delay has passed that distinguishes a new keypress (see `:help timeoutlen`) from a sequence, the vkmap menu
will appear. At this point vim will bock until a key is pressed. Upon key press the window closes
and the menu's "key" attribute will be rebroadcasted with the latest key press appended to it. The
user is then free to continue adding keys to the sequence or finalize it.
