" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppfun
" Create Date: 2018-05-01
" License: MIT
" ==============================================================

" 函数所在行
let s:fun_row_num = 0

function! cppfun#format_fun_param#format_function_param()
    let s:fun_row_num = line(".")
    let fun = <sid>get_function()
    call <sid>delete_current_line()
    call cppfun#util#write_text_at_current_line(<sid>format_fun_param(fun))
    call cppfun#util#set_cursor_position(s:fun_row_num)
    call cppfun#util#code_alignment()
endfunction

" 获得函数
function! s:get_function()
    return getline(".")
endfunction

" 删除当前行
function! s:delete_current_line()
    execute "normal dd"
endfunction

" 格式化函数参数
function! s:format_fun_param(fun)
    let result = cppfun#util#replace_string(a:fun, ",", ",\n")
    return result . "\n"
endfunction
