" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppfun
" Create Date: 2018-05-01
" License: MIT
" ==============================================================

" 函数所在行
let s:fun_row_num = 0

function! cppfun#format_fun_param#FormatFunctionParam()
    let s:fun_row_num = line(".")
    let fun = <sid>GetFunction()
    call <sid>DeleteCurrentLine()
    call cppfun#util#WriteTextAtCurrentLine(<sid>FormatFunctionParam(fun))
    call cppfun#util#SetCursorPosition(s:fun_row_num)
    call cppfun#util#CodeAlignment()
endfunction

" 获得函数
function! s:GetFunction()
    return getline(".")
endfunction

" 删除当前行
function! s:DeleteCurrentLine()
    execute "normal dd"
endfunction

" 格式化函数参数
function! s:FormatFunctionParam(fun)
    let result = cppfun#util#ReplaceString(a:fun, ",", ",\n")
    return result . "\n"
endfunction
