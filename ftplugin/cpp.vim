" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppfun
" Create Date: 2018-05-01
" License: MIT
" ==============================================================

if exists("g:cppfun_loaded")
    finish
endif

let g:cppfun_loaded = 1

command! -nargs=0 CopyFun :call cppfun#gen_fun#copy_function() 
command! -nargs=0 PasteFun :call cppfun#gen_fun#paste_function()
command! -nargs=0 FormatFunParam :call cppfun#format_fun_param#format_function_param()
command! -nargs=0 FormatIf :call cppfun#format_if#format_if()
