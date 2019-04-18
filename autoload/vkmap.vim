" A visual listing of key mappings

fun! vkmap#print_lines(def)
  " a:maps = {  'leader': { 'type': 'label | leader
  let l:width = &columns - 2 * g:vkmap#outer_padding
  let l:header_pad = &columns / 2 - strlen(a:def.key) / 2
  let l:header = vkmap#util#insert_char('', ' ', l:header_pad)
  let l:header = l:header . a:def.key


  let l:entry = []
  for m in a:def.maps

    let l:col = ''
    let l:col = l:col . '[' . m.key . '] '
    if m.leader
      let l:col = l:col . '+'
    endif
    let l:col = l:col . m.dscpt

    if strlen(l:col) > g:vkmap#col_width
      let l:col = l:col[0 : g:vkmap#col_width - 3] . '...'
    endif
    let l:entry += [l:col]

  endfor

  let l:entry = sort(l:entry)
  let l:lines = s:format_entries(l:entry)
  let l:lines = [l:header, ''] + l:lines
  let l:line_index = 0
  let l:wh = winheight(0)
  for line in l:lines
    call append(l:line_index, line)
    let l:line_index += 1
  endfor

  while l:line_index < l:wh
    call append(l:line_index, ' ')
    let l:line_index += 1
  endwhile


endfun

fun! s:format_entries(e)
  let l:width = &columns - 2 * g:vkmap#outer_padding

  let l:lines = []
  let l:line = vkmap#util#insert_char(' ', ' ', g:vkmap#outer_padding)
  for l:entry in a:e
  let l:delta = g:vkmap#col_width - strlen(l:entry)

    if g:vkmap#col_width + g:vkmap#inner_padding + strlen(l:line) > l:width
      let l:lines += [l:line]
      let l:entry = vkmap#util#insert_char(l:entry, ' ', l:delta)
      let l:line = vkmap#util#insert_char(' ', ' ', g:vkmap#outer_padding) . entry
    else
      let l:entry = vkmap#util#insert_char(l:entry, ' ', l:delta + g:vkmap#inner_padding)
      let l:line = l:line . entry
    endif

  endfor
  if strlen(l:line) > 0
    let l:lines += [l:line]
  endif

  return l:lines

endfun

fun! vkmap#arm_repeat(def)
  let s:arm = a:def.key . nr2char(getchar())
endfun

fun! vkmap#repeat(mode)
  " Prevent endless recursion by mapping to an unprintable character which maps to the target
  " mapping
  let l:keys = substitute(s:arm, '<', '\\<', 'g')
  let l:cmd = vkmap#util#get_mapping(s:arm)
  if type(l:cmd) == 1
    execute(a:mode . 'map <buffer>  ' . s:arm)
    call feedkeys(s:get_mode_pre(a:mode) . '')
  endif

endfun

fun! s:get_mode_pre(mode)
  if a:mode == 'v'
    return '`<' . visualmode() . '`>'
  endif

  return ''
endfun
