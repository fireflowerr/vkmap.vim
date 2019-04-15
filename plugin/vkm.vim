" VisualKeymap interface

if !exists('g:vkmap#menus')
  let g:vkmap#menus = []
endif

fun! s:init()
  let l:l = len(g:vkmap#menus)
  let l:i = 0
  while l:i < l:l
    let l:def = g:vkmap#menus[l:i]
    execute('nnoremap ' . l:def.key . ' :edit __vkm' . l:i . '__ <Bar> call vkmap#print_lines(g:vkmap#menus[' . l:i . '])<CR>')
    let l:i += 1
  endwhile
endfun

call s:init()

command! -nargs=0 VkmReinit call s:init()

au BufRead,BufNewFile __vkm* set filetype=vkmap syntax=vkmap
