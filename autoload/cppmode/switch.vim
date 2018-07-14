" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppmode
" Create Date: 2018-06-13
" License: MIT
" ==============================================================

" .h -> .cpp or .cpp -> .h
function! cppmode#switch#switch_file()
    let suffix = cppmode#util#get_file_suffix()
    if suffix == "h" || suffix == "hpp"
        call <sid>switch_to_implement_file(suffix)    
    elseif suffix == "cc" || suffix == "cpp"
        call <sid>switch_to_head_file(suffix)
    endif
endfunction

" 转换到头文件
function! s:switch_to_head_file(suffix)
    let paths = <sid>get_head_file_path(a:suffix)

    for i in range(0, len(paths) - 1)
        if cppmode#util#is_exist(paths[i])
            call cppmode#util#open_tab(paths[i])
            return
        endif
    endfor
    
    call cppmode#util#open_tab(paths[0])
endfunction

" 转换到实现文件
function! s:switch_to_implement_file(suffix)
    let paths = <sid>get_implement_file_path(a:suffix)

    for i in range(0, len(paths) - 1)
        if cppmode#util#is_exist(paths[i])
            call cppmode#util#open_tab(paths[i])
            return
        endif
    endfor
    
    call cppmode#util#open_tab(paths[0])
endfunction

" 获得头文件
function! s:get_head_file_path(suffix)
    let paths = []
    let name = cppmode#util#get_base_name_with_path()

    call add(paths, name . ".h")
    call add(paths, name . ".hpp")

    return paths
endfunction

" 获得实现文件
function! s:get_implement_file_path(suffix)
    let paths = []
    let name = cppmode#util#get_base_name_with_path()

    call add(paths, name . ".cpp")
    call add(paths, name . ".cc")

    return paths
endfunction

