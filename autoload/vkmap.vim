" A visual listing of key mappings

fun! vkmap#print_lines(def)
  " a:maps = {  'leader': { 'type': 'label | leader
  let l:width = &columns - 2 * g:vkmap#outer_padding
  let l:header_pad = &columns / 2 - strlen(a:def.key) / 2
  let l:header = s:insert_char('', ' ', l:header_pad)
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
      let l:col = l:col[0 : g:vkmap#col_width]
    endif
    let l:entry += [l:col]

  endfor

  let l:entry = sort(l:entry)
  let l:lines = s:format_entries(l:entry)
  let l:lines = [l:header] + l:lines
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
  let l:line = s:insert_char(' ', ' ', g:vkmap#outer_padding)
  for l:entry in a:e
  let l:delta = g:vkmap#col_width - strlen(l:entry)

    if g:vkmap#col_width + g:vkmap#inner_padding + strlen(l:line) > l:width
      let l:lines += [l:line]
      let l:entry = s:insert_char(l:entry, ' ', l:delta)
      let l:line = s:insert_char('', ' ', g:vkmap#outer_padding) . entry
    else
      let l:entry = s:insert_char(l:entry, ' ', l:delta + g:vkmap#inner_padding)
      let l:line = l:line . entry
    endif

  endfor
  if strlen(l:line) > 0
    let l:lines += [l:line]
  endif

  return l:lines

endfun

fun! s:insert_char(str, char, qty)
  let l:i = 0
  let l:str = a:str
  while i < a:qty
    let i += 1
    let l:str = l:str . a:char
  endwhile
  return l:str
endfun

fun! s:sort(entries)
  let l:e = [a:entries[0]]
  let l:i = 1
  let l:l = len(a:entries)

  while l:i < l:l
    let s1 = a:entries[l:i]

    let l:j = 0
    while s:string_cmp(s1, a:entries[j] < 0)
      let l:j += 1
    endwhile

    let l:e = l:e[0 : l:j - 1] + [l:s1] + l:e[l:j - 1 : len(l:e)]

  endfor

  return l:e
endfun

"return 0 if the same 1 if s1 greater than s2, -1 otherwise
fun! s:strng_cmp(s1, s2)
  if a:s1 =~ a:s1
    return 0
  endif

  let l:l = strlen(a:s1)
  let l:i = 0
  while l:i < l:l
    let l:c1 = strgetchar(s1, l:i)
    let l:c2 = strgetchar(s2, l:i)

    if l:c1 < l:c2
      return -1
    elseif l:c1 > l:c2
      return 1
    endif
  endwhile

endfun

fun! vkmap#arm_repeat(def)
  let s:arm = exists('a:def.key_can') ? a:def.key_can : a:def.key
  let s:arm = s:arm . nr2char(getchar())
endfun

fun! vkmap#repeat()
  let l:lookup = vkmap#util#lookup(s:arm)
  if type(l:lookup) == 4
    call vwm#open(l:lookup.lid)
  else
    let l:cmd = vkmap#util#get_mapping(s:arm)
    if type(l:cmd) == 1
      execute(l:cmd)
    endif
  endif
endfun

