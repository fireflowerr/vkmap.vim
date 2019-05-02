" VisualKeymap interface

if !exists('g:vkmap#menus')
  let g:vkmap#menus = []
endif
if !exists('g:vkmap#col_width')
  let g:vkmap#col_width = 18
endif
if !exists('g:vkmap#floating') && exists('*nvim_open_win')
  let g:vkmap#floating = 0
endif
" use vwm to handle window population
if !exists('g:vwm#layouts')
  let g:vwm#layouts=[]
endif
if !exists('g:vkmap#height')
  let g:vkmap#height = &lines * 1 / 5
endif
if !exists('g:vkmap#outer_padding')
  let g:vkmap#outer_padding = 1
endif
if !exists('g:vkmap#inner_padding')
  let g:vkmap#inner_padding = 16
endif
if !exists('g:vkmap#float_padding')
  let g:vkmap#float_padding = 3
endif

fun! s:normalize_root()

  let l:i = 0
  let l:l = len(g:vkmap#menus)
  while l:i < l:l

    let l:menu = g:vkmap#menus[l:i]

    if !exists('l:menu.key')
      unlet g:vkmap#menus[l:i]
      let l:l -= 1
      echoerr "removed malformed menu at index " . l:i
    endif
    if !exists('l:menu.maps')
      let l:menu.maps = []
    else
      call s:normalize_maps(l:menu.maps)
    endif

    let l:i += 1
  endwhile

endfun

fun! s:normalize_maps(maps)

  let l:i = 0
  let l:l = len(a:maps)
  while l:i < l:l
    let l:map = a:maps[l:i]

    if !exists('l:map.key')
      unlet l:map[l:i]
      let l:l -= 1
      echoerr "removed malformed map entry"
    endif
    if !exists('l:map.leader')
      let l:map.leader = 0
    endif
    if !exists('l:map.dscpt')
      let l:map.dscpt = ''
    endif
    if exists('l:map.mode')

      if l:map.mode != 'v'
        let l:map.mode = 'n'
      endif

    endif

  let l:i += 1
  endwhile
endfun


fun! s:init()
  call s:normalize_root()
  if g:vkmap#floating
    call s:gen_layouts_float()
  else
    call s:gen_layouts_reg()
  endif

  if exists('g:vwm#active')
    VwmReinit
  endif
endfun

fun! s:gen_layouts_reg()
  let l:l = len(g:vkmap#menus)
  let l:i = 0
  while l:i < l:l

    let l:def = g:vkmap#menus[l:i]
    let l:height = exists('l:def.height') ? l:def.height : g:vkmap#height

    let l:layout = {}
    execute('let l:layout.name = "vkmap' . l:i . '"')
    let l:def.lid = l:layout.name
    let l:layout.cache = 0
    let l:bot = {
          \  'h_sz': l:height,
          \  'set': ['nobl', 'bh=hide', 'noswapfile', 'ft=vkmap', 'nomodifiable', 'nomodified', 'nornu', 'nonu'],
          \  'focus': 1
          \}

    execute("let l:init = ['edit __vkm" . l:i . "__']")
    let l:init += ['call vkmap#print_lines(g:vkmap#menus[' . l:i . '])']
    let l:init += ['call setpos(".", [0,0,0])']

    let l:opnAftr = ['redraw']
    let l:opnAftr += ['call vkmap#arm_repeat(g:vkmap#menus[' . l:i . '])']
    let l:opnAftr += ['call vwm#close("' . l:layout.name . '")']
    let l:opnAftr += ['call vkmap#repeat("' . l:def.mode . '")']
    execute(l:def.mode . 'noremap ' . l:def.key . ' :<C-u>VwmOpen ' . l:layout.name . '<CR>')

    let l:bot.init = l:init
    let l:layout.bot = l:bot
    let l:layout.opnAftr = l:opnAftr
    let g:vwm#layouts += [l:layout]
    let l:i += 1
  endwhile
endfun

fun! s:gen_layouts_float()
  let l:Y = function('vkmap#util#get_y')

  let l:l = len(g:vkmap#menus)
  let l:i = 0
  while l:i < l:l

    let l:def = g:vkmap#menus[l:i]
    let l:height = exists('l:def.height') ? l:def.height : g:vkmap#height

    let l:layout = {}
    execute('let l:layout.name = "vkmap' . l:i . '"')
    let l:def.lid = l:layout.name
    let l:layout.cache = 0
    let l:Width = function('vkmap#util#get_width')
    let l:float = {
          \  'x': g:vkmap#float_padding,
          \  'y': l:Y,
          \  'width': l:Width,
          \  'height': l:height,
          \  'focusable': 1,
          \  'focus': 1,
          \  'set': ['nobl', 'bh=hide', 'noswapfile', 'ft=vkmap', 'nomodifiable', 'nomodified', 'nornu', 'nonu'],
          \}

    execute("let l:init = ['edit __vkm" . l:i . "__']")
    let l:init += ['call vkmap#print_lines(g:vkmap#menus[' . l:i . '])']
    let l:init += ['call setpos(".", [0,0,0])']

    let l:opnAftr = ['redraw']
    let l:opnAftr += ['call vkmap#arm_repeat(g:vkmap#menus[' . l:i . '])']
    let l:opnAftr += ['call vwm#close("' . l:layout.name . '")']
    let l:opnAftr += ['call vkmap#repeat("' . l:def.mode . '")']
    execute(l:def.mode . 'noremap ' . l:def.key . ' :<C-u>VwmOpen ' . l:layout.name . '<CR>')

    let l:float.init = l:init
    let l:layout.float = l:float
    let l:layout.opnAftr = l:opnAftr
    let g:vwm#layouts += [l:layout]
    let l:i += 1
  endwhile
endfun

call s:init()
au BufRead,BufNewFile __vkm* set filetype=vkmap
