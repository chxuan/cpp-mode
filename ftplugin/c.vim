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

command! -nargs=0 Switch call cppmode#switch#switch_file()
