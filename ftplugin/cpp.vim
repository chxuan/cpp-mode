" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppmode
" Create Date: 2018-05-01
" License: MIT
" ==============================================================

if exists("g:cppmode_loaded")
    finish
endif

let g:cppmode_loaded = 1

command! -nargs=0 CopyFun :call cppmode#gen_fun#copy_function() 
command! -nargs=0 PasteFun :call cppmode#gen_fun#paste_function()
command! -nargs=0 GoToDefinition :call cppmode#go_to_definition#go_to_definition()
command! -nargs=0 FormatFunParam :call cppmode#format_fun_param#format_function_param()
command! -nargs=0 FormatIf :call cppmode#format_if#format_if()
command! -nargs=0 Switch :call cppmode#switch#switch_file()
