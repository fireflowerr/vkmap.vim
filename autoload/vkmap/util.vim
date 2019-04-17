" Utility functions...

fun! vkmap#util#lookup(seq)
  for l:menu in g:vkmap#menus

    if a:seq == l:menu.key || a:seq == l:menu.key_can
      return l:menu
    endif

  endfor
  return -1
endfun

fun! vkmap#util#get_mapping(seq)
  let l:cmd = maparg(a:seq)
  let l:l = strlen(l:cmd)

  if l:l <= 0
    return 0
  endif

  return l:cmd[1 : l:l - 5]
endfun

fun! vkmap#util#insert_char(str, char, qty)
  let l:i = 0
  let l:str = a:str
  while i < a:qty
    let i += 1
    let l:str = l:str . a:char
  endwhile
  return l:str
endfun

fun! vkmap#util#sort(entries)
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
fun! vkmap#util#string_cmp(s1, s2)
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

fun! vkmap#util#get_width()
  return &co  - 2 * g:vkmap#float_padding
endfun

fun! vkmap#util#get_y()
  return &lines + &cmdheight - g:vkmap#height
endfun
