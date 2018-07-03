" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppmode
" Create Date: 2018-06-13
" License: MIT
" ==============================================================

" .h -> .cpp or .cpp -> .h
function! cppmode#switch#switch_file()
    let suffix = cppmode#util#get_current_file_suffix()
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
    let file_path = cppmode#util#get_current_file_path()
    let paths = []
    let name = ""

    if a:suffix == "cpp"
        let name = cppmode#util#substr(file_path, 0, len(file_path) - 3)
    elseif a:suffix == "cc"
        let name = cppmode#util#substr(file_path, 0, len(file_path) - 2)
    endif

    call add(paths, name . "h")
    call add(paths, name . "hpp")

    return paths
endfunction

" 获得实现文件
function! s:get_implement_file_path(suffix)
    let file_path = cppmode#util#get_current_file_path()
    let paths = []
    let name = ""

    if a:suffix == "h"
        let name = cppmode#util#substr(file_path, 0, len(file_path) - 1)
    elseif a:suffix == "hpp"
        let name = cppmode#util#substr(file_path, 0, len(file_path) - 3)
    endif

    call add(paths, name . "cpp")
    call add(paths, name . "cc")

    return paths
endfunction

