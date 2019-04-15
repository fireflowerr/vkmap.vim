" Syntax highligting for vkmap filetype

if exists("b:current_syntax")
  finish
endif

syn match vkOther '.'
syn match vkmapMap '\S' contained
syn match vkMapB '\[\|\]' contained
syn match vkmapBrac '\[[^\]]\+\]' contains=vkmapMap,vkmapB

hi! link vkOther Comment
hi! link vkmapMap Special
hi! link vkMapB Character

"let b:current_syntax = 'vkmap'
