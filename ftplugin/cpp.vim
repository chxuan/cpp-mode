" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppfun
" Create Date: 2018-05-01
" License: MIT
" ==============================================================

if exists('g:cppfun_loaded')
    finish
endif

let g:cppfun_loaded = 1

command! -nargs=0 CopyFun :call cppfun#CopyFunction() 
command! -nargs=0 PasteFun :call cppfun#PasteFunction()
