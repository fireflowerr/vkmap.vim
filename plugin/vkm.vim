" VisualKeymap interface

" init globals {{{
if !exists('g:vkmap#menus')
  let g:vkmap#menus = []
endif
if !exists('g:vkmap#col_width')
  let g:vkmap#col_width = 18
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
if !exists('g:vkmap#pos')
  let g:vkmap#pos = 'bot'
endif
"}}}

"normalize layouts {{{
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
"}}}

"generate vwm layouts {{{
fun! s:get_buf_node(pos)
  if a:pos == 'float'
    let l:Driver = function('s:gen_layouts_float')

  elseif a:pos == 'top' || a:pos == 'bot' || a:pos == 'left' || a:pos == 'right'
    let l:Driver = function('s:gen_layouts_reg')

  else
    echoerr "Invalid argument to fun s:get_buf_node"

  endif

  let l:l = len(g:vkmap#menus)
  let l:i = 0
  while l:i < l:l
    let l:node = {}

    call s:gen_root(l:node, l:i)
    call l:Driver(l:node, a:pos)

    let g:vwm#layouts += [l:node]

    let l:i += 1
  endwhile

endfun


fun! s:gen_root(node, i)

  let l:def = g:vkmap#menus[a:i]

  execute('let a:node.name = "vkmap' . a:i . '"')
  " Store root dependent infromation in a temprorary var
  execute("let a:node.tmp = ['edit __vkm" . a:i . "__']")
  let a:node.tmp += ['call vkmap#print_lines(g:vkmap#menus[' . a:i . '])']
  let a:node.tmp += ['call setpos(".", [0,0,0])']

  let a:node.opnAftr = ['redraw']
  let a:node.opnAftr += ['call vkmap#arm_repeat(g:vkmap#menus[' . a:i . '])']
  let a:node.opnAftr += ['call vwm#close("' . a:node.name . '")']
  let a:node.opnAftr += ['call vkmap#repeat(g:vkmap#menus[' . a:i . '].mode)']

  " bind layout to key
  execute(l:def.mode . 'noremap ' . l:def.key . ' :<C-u>VwmOpen ' . a:node.name . '<CR>')
endfun

fun! s:gen_layouts_reg(node, pos)

  let a:node.cache = 0
  let l:content = {
        \  'set': ['nobl', 'bh=wipe', 'noswapfile', 'ft=vkmap', 'nomodifiable', 'nomodified', 'nornu', 'nonu'],
        \  'focus': 1
        \}
  let l:content.init = a:node.tmp
  unlet a:node.tmp

  let l:height = exists('l:def.height') ? l:def.height : g:vkmap#height
  if a:pos == 'top' || a:pos == 'bot'
    let l:content.h_sz = l:height

  else
    let l:content.v_sz = l:height

  endif

  execute('let a:node.' . a:pos . ' = l:content')
endfun

fun! s:gen_layouts_float(node, pos)
  let l:Y = function('vkmap#util#get_y')

  let a:node.cache = 0
  let l:Width = function('vkmap#util#get_width')
  let l:height = exists('l:def.height') ? l:def.height : g:vkmap#height

  let a:node.float = {
        \  'x': g:vkmap#float_padding,
        \  'y': l:Y,
        \  'width': l:Width,
        \  'height': l:height,
        \  'focusable': 1,
        \  'focus': 1,
        \  'set': ['nobl', 'bh=wipe', 'noswapfile', 'ft=vkmap', 'nomodifiable', 'nomodified', 'nornu', 'nonu'],
        \}
  let a:node.float.init = a:node.tmp
  unlet a:node.tmp

endfun
"}}}

fun! s:init()
  call s:normalize_root()
  call s:get_buf_node(g:vkmap#pos)

  " If vwm was sourced first, this is nessecary
  if exists('g:vwm#active')
    VwmReinit
  endif
endfun


call s:init()
au BufRead,BufNewFile __vkm* set filetype=vkmap
