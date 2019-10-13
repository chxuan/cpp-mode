" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppmode
" Create Date: 2019-10-13
" License: MIT
" ==============================================================

if exists("g:cppmode_loaded")
    finish
endif

let g:cppmode_loaded = 1

command! -nargs=0 FormatFunParam call cppmode#format_fun_param#format_function_param()
command! -nargs=0 FormatIf call cppmode#format_if#format_if()
command! -nargs=0 Switch call cppmode#switch#switch_file()
