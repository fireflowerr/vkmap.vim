" VisualKeymap interface

if !exists('g:vkmap#menus')
  let g:vkmap#menus = []
endif
if !exists('g:vkmap#floating')
  let g:vkmap#floating = 0
endif
" need to use vwm to handle window population
if !exists('g:vwm#layouts')
  let g:vwm#layouts=[]
endif
if !exists('g:vkmap#height')
  let g:vkmap#height = &co * 2 / 5
endif


fun! s:init()
  for l:entry in g:vkmap#menus
    if !exists('l:entry.key_can')
      let l:entry.key_can = l:entry.key
    endif
  endfor

  let l:y = &lines * 2 / 5
  let l:width = &co - 6
  let l:height = 9

  let l:l = len(g:vkmap#menus)
  let l:i = 0
  while l:i < l:l

    let l:def = g:vkmap#menus[l:i]
    let l:layout = {}
    execute('let l:layout.name = "vkmap' . l:i . '"')
    let l:def.lid = l:layout.name
    let l:layout.cache = 0
    let l:float = {
          \  'x': 3,
          \  'y': 50,
          \  'width': 210 - 6,
          \  'height': l:height,
          \  'close_on_press': 0,
          \  'focusable': 0,
          \  'focus': 0,
          \  'set': ['nobl', 'bh=hide', 'noswapfile', 'ft=vkmap', 'nomodifiable', 'nomodified', 'nornu', 'nonu'],
          \}

    execute("let l:init = ['edit __vkm" . l:i . "__']")
    let l:init += ['call vkmap#print_lines(g:vkmap#menus[' . l:i . '])']
    let l:init += ['call setpos(".", [0,0,0])']

    let l:opnAftr = ['redraw!']
    let l:opnAftr += ['call vkmap#arm_repeat(g:vkmap#menus[' . l:i . '])']
    let l:opnAftr += ['call vwm#close("' . l:layout.name . '")']
    let l:opnAftr += ['call vkmap#repeat()']
    execute('nnoremap ' . l:def.key . ' :VwmOpen ' . l:layout.name . '<CR>')

		let l:float.init = l:init
		let l:layout.float = l:float
    let l:layout.opnAftr = l:opnAftr
		let g:vwm#layouts += [l:layout]
    let l:i += 1
  endwhile

  if exists('g:vwm#active')
    VwmReinit
  endif
endfun

call s:init()

command! -nargs=0 VkmReinit call s:init()
au BufRead,BufNewFile __vkm* set filetype=vkmap
