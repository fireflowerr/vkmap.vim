if exists("b:current_syntax")
  finish
endif

syntax sync fromstart

syn match vkmapMap '\S' contained
syn match vkMapB '\[\|\]' contained
syn match vkmapBrac '\[[^\]]\+\]' contained contains=vkmapMap,vkmapB
syn match vkmapGroup '+\S\+' contained
syn match vkmapFile '.*' contains=vkmapBrac,vkmapGroup

hi def link vkmapFile Comment
hi def link vkmapMap Special
hi def link vkMapB Character
hi def link vkmapGroup Function

let b:current_syntax = 'vkmap'
