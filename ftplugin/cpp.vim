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

let s:is_fun = 0

command! -nargs=0 CopyCode call <sid>copy_code() 
command! -nargs=0 PasteCode call <sid>paste_code()
command! -nargs=0 GoToFunImpl call cppmode#go_to_fun_impl#go_to_fun_impl()
command! -nargs=0 FormatFunParam call cppmode#format_fun_param#format_function_param()
command! -nargs=0 FormatIf call cppmode#format_if#format_if()
command! -nargs=0 Switch call cppmode#switch#switch_file()

" 拷贝代码
function! s:copy_code()
    if <sid>is_function()
        let s:is_fun = 1
        call cppmode#gen_fun#copy_function()
    else
        let s:is_fun = 0
        call cppmode#gen_var#copy_variate()
    endif
endfunction

" 粘贴代码
function! s:paste_code()
    if s:is_fun
        call cppmode#gen_fun#paste_function()
    else
        call cppmode#gen_var#paste_variate()
    endif
endfunction

" 判断是否是函数
function! s:is_function()
    let text = cppmode#util#get_current_row_text()
    return cppmode#util#is_contains(text, "(") && cppmode#util#is_contains(text, ")")
endfunction

