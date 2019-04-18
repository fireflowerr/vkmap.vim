# vkmap.vim

A quick popup to help remember vim keymaps.
![](./.github/expose.gif)

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
      \      'leader': 0
      \    },
      \    {
      \      'key': 't',
      \      'dscpt': 'toggle terms',
      \      'leader': 0
      \    },
      \    {
      \      'key': 'r',
      \      'dscpt': 'refresh',
      \      'leader': 0
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
      \      'leader': 0
      \    },
      \    {
      \      'key': 'i',
      \      'dscpt': 'info',
      \      'leader': 0
      \    },
      \    {
      \      'key': 'n',
      \      'dscpt': 'next',
      \      'leader': 0
      \    },
      \    {
      \      'key': 'p',
      \      'dscpt': 'prev',
      \      'leader': 0
      \    },
      \    {
      \      'key': 'f',
      \      'dscpt': 'find refs',
      \      'leader': 0
      \    },
      \    {
      \      'key': 'r',
      \      'dscpt': 'rename',
      \      'leader': 0
      \    },
      \    {
      \      'key': 'a',
      \      'dscpt': 'action',
      \      'leader': 0
      \    },
      \  ]
      \}
let g:vkmap#menus = [s:main, s:lsp]
```

## FAQ

**Q**: How can I change the color of the floating menu in Nvim?<Br/>
**A**: The color of floating windows is controlled by hi NormalFloat. To change the background color
try `hi NormalFloat guibg=**my_color**`

**Q**: How does vkmap.vim work?<Br/>
**A**: After the delay has passed that distinguishes a new keypress from a sequence, the vkmap menu
will appear. At this point vim will bock until a key is pressed. Upon key press the window closes
and the menu's "key" attribute will be rebroadcasted with the latest key press appended to it. The
user is then free to continue adding keys to the sequence or finalize it.

## Exaples
see https://github.com/paroxayte/vkmap.vim#examples
