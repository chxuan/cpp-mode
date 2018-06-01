" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppfun
" Create Date: 2018-05-31
" License: MIT
" ==============================================================

" 转到定义
function! cppfun#go_to_definition#go_to_definition()
    let suffix = cppfun#util#get_current_file_suffix()

    if suffix == "h"
        let cpp_file = <sid>get_cpp_file_path()
        if cppfun#util#is_file_exists(cpp_file)
            call <sid>go_to_fun_definition(cpp_file)
            return
        endif
    endif

    let file_path = cppfun#util#get_current_file_path()
    call <sid>go_to_fun_definition(file_path)
endfunction

" 获取cpp文件路径
function! s:get_cpp_file_path()
    let file_path = cppfun#util#get_current_file_path()
    return cppfun#util#substr(file_path, 0, len(file_path) - 1) . "cpp"
endfunction

" 转到函数定义
function! s:go_to_fun_definition(file_path)
    let fun_name = cppfun#util#get_current_cursor_word()
    let lines = cppfun#util#read_file(a:file_path)
    let row_num = <sid>get_row_num(lines, "::" . fun_name)

    if row_num != -1
        if a:file_path != cppfun#util#get_current_file_path()
            call cppfun#util#open_window(a:file_path)
        endif
        call cppfun#util#set_cursor_position(row_num)
    endif

endfunction

" 获得行号
function! s:get_row_num(lines, target)
    for i in range(0, len(a:lines) - 1)
        if cppfun#util#is_contains(a:lines[i], a:target)
            return i + 1
        endif
    endfor

    return -1
endfunction

