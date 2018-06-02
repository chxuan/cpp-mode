" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppfun
" Create Date: 2018-05-31
" License: MIT
" ==============================================================

" 转到定义
function! cppfun#go_to_definition#go_to_definition()
    let suffix = cppfun#util#get_current_file_suffix()
    call <sid>go_to_definition_by_suffix(suffix)
endfunction

" 通过后缀名判断来转到函数定义
function! s:go_to_definition_by_suffix(suffix)
    if a:suffix == "h"
        let paths = <sid>get_implement_file_paths()
        for i in range(0, len(paths) - 1)
            if cppfun#util#is_file_exists(paths[i])
                call <sid>go_to_fun_definition(paths[i])
                return
            endif
        endfor
    endif

    let file_path = cppfun#util#get_current_file_path()
    call <sid>go_to_fun_definition(file_path)
endfunction

" 获取可能存在的实现文件
function! s:get_implement_file_paths()
    let file_path = cppfun#util#get_current_file_path()
    let cpp_file = cppfun#util#substr(file_path, 0, len(file_path) - 1) . "cpp"

    let paths = []
    call add(paths, cpp_file)

    return paths
endfunction

" 转到函数定义
function! s:go_to_fun_definition(file_path)
    let fun_name = cppfun#util#get_current_cursor_word()
    let lines = cppfun#util#read_file(a:file_path)
    let row_num = <sid>get_row_num(lines, "::" . fun_name . "(")

    if row_num != -1
        if a:file_path != cppfun#util#get_current_file_path()
            call cppfun#util#open_window(a:file_path)
        endif

        let text = cppfun#util#get_row_text(row_num)
        let col_num = cppfun#util#find(text, "::" . fun_name . "(") + 3
        call cppfun#util#set_cursor_position(row_num, col_num)
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

