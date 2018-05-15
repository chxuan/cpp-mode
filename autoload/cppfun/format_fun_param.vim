" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppfun
" Create Date: 2018-05-01
" License: MIT
" ==============================================================

" 函数所在行
let s:fun_row_num = 0

" 格式化函数参数
function! cppfun#format_fun_param#format_function_param()
    if <sid>is_ready_format()
        call <sid>recover_format_param()
    else
        call <sid>format_param()
    endif
    " let s:fun_row_num = line(".")
    " let fun = <sid>get_function()
    " call <sid>delete_current_line()
    " call cppfun#util#write_text_at_current_row(<sid>format_fun_param(fun))
    " call cppfun#util#set_cursor_position(s:fun_row_num)
    " call cppfun#util#code_alignment()
endfunction

" 检查是否已经格式化
function! s:is_ready_format()
    let text = cppfun#util#get_current_row_text()

    if cppfun#util#is_contains(text, "(") && cppfun#util#is_contains(text, ")")
        return 0
    endif

    return 1
endfunction

" 格式化函数参数
function! s:format_param()
    " let result = cppfun#util#replace_string(a:fun, ",", ",\n")
    " return result . "\n"
    echo "format_param"
endfunction

" 恢复格式化函数参数
function! s:recover_format_param()
    echo "recover_format_param"
endfunction

" 获得函数
function! s:get_function()
    return getline(".")
endfunction

" 删除当前行
function! s:delete_current_line()
    execute "normal dd"
endfunction

