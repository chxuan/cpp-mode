" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppmode
" Create Date: 2018-05-31
" License: MIT
" ==============================================================

" 转到定义
function! cppmode#go_to_fun_impl#go_to_fun_impl()
    if <sid>go_to_impl_in_impl_file() == -1
        if <sid>go_to_impl_in_head_file() == -1
            echo "Not found function implement"
        endif
    endif
endfunction

" 在实现文件查找函数实现
function! s:go_to_impl_in_impl_file()
    let file_path = <sid>get_impl_file_path()

    if cppmode#util#is_exist(file_path)
        return <sid>go_to_impl_with_class(file_path)
    endif

    return -1
endfunction

" 在头文件查找函数实现
function! s:go_to_impl_in_head_file()
    let file_path = <sid>get_head_file_path()

    if cppmode#util#is_exist(file_path)
        if <sid>go_to_impl_with_class(file_path) == 1
            return 1
        else
            return <sid>go_to_impl_not_with_class(file_path)
        endif
    endif

    return -1
endfunction

" 获得实现文件路径
function! s:get_impl_file_path()
    let file_path = cppmode#util#get_file_path()
    let suffix = cppmode#util#get_file_suffix()

    if suffix == "cpp"
        return file_path
    elseif suffix == "h"
        return cppmode#util#substr(file_path, 0, len(file_path) - 1) . "cpp"
    else
        return ""
    endif

endfunction

" 获得头文件路径
function! s:get_head_file_path()
    let file_path = cppmode#util#get_file_path()
    let suffix = cppmode#util#get_file_suffix()

    if suffix == "h"
        return file_path
    elseif suffix == "cpp"
        return cppmode#util#substr(file_path, 0, len(file_path) - 3) . "h"
    else
        return ""
    endif

endfunction

" 转到函数实现
function! s:go_to_impl_with_class(file_path)
    let fun_name = cppmode#util#get_cursor_word()
    let lines = cppmode#util#read_file(a:file_path)
    let row_num = <sid>get_row_num_with_class(lines, fun_name)

    if row_num > 0
        if a:file_path != cppmode#util#get_file_path()
            call cppmode#util#open_tab(a:file_path)
        endif

        let text = cppmode#util#get_row_text(row_num)
        let col_num = cppmode#util#find(text, "::" . fun_name . "(") + 3
        call cppmode#util#set_cursor_position(row_num, col_num)

        return 1
    endif

    return -1
endfunction

" 转到函数实现
function! s:go_to_impl_not_with_class(file_path)
    let fun_name = cppmode#util#get_cursor_word()
    let lines = cppmode#util#read_file(a:file_path)
    let row_num = <sid>get_row_num_not_with_class(lines, fun_name)

    if row_num > 0
        if a:file_path != cppmode#util#get_file_path()
            call cppmode#util#open_tab(a:file_path)
        endif

        let text = cppmode#util#get_row_text(row_num)
        let col_num = cppmode#util#find(text, fun_name) + 1
        call cppmode#util#set_cursor_position(row_num, col_num)

        return 1
    endif

    return -1
endfunction

" 获得行号
function! s:get_row_num_with_class(lines, fun_name)
    let target = "::" . a:fun_name . "("

    for i in range(0, len(a:lines) - 1)
        if cppmode#util#is_contains(a:lines[i], target) && !cppmode#util#is_contains(a:lines[i], ";")
            return i + 1
        endif
    endfor

    return -1
endfunction

" 获得行号
function! s:get_row_num_not_with_class(lines, fun_name)
    let target = a:fun_name . "("

    for i in range(0, len(a:lines) - 1)
        if cppmode#util#is_contains(a:lines[i], target) && (cppmode#util#is_contains(a:lines[i], "{") && cppmode#util#is_contains(a:lines[i], "}") || cppmode#util#is_contains(a:lines[i + 1], "{"))
            return i + 1
        endif
    endfor

    return -1
endfunction

