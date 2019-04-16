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
