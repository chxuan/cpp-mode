" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppfun
" Create Date: 2018-06-13
" License: MIT
" ==============================================================

" .h -> .cpp or .cpp -> .h
function! cppfun#switch#switch_file()
    let suffix = cppfun#util#get_current_file_suffix()
    if suffix == "h"
        call <sid>switch_to_implement_file()    
    elseif suffix == "cpp"
        call <sid>switch_to_head_file()
    endif
endfunction

" 转换到头文件
function! s:switch_to_head_file()
    let file_path = <sid>get_head_file_path()
    call cppfun#util#open_tab(file_path)
endfunction

" 转换到实现文件
function! s:switch_to_implement_file()
    let file_path = <sid>get_implement_file_path()
    call cppfun#util#open_tab(file_path)
endfunction

" 获得头文件
function! s:get_head_file_path()
    let file_path = cppfun#util#get_current_file_path()
    let head_file = cppfun#util#substr(file_path, 0, len(file_path) - 3) . "h"
    return head_file
endfunction

" 获得实现文件
function! s:get_implement_file_path()
    let file_path = cppfun#util#get_current_file_path()
    let cpp_file = cppfun#util#substr(file_path, 0, len(file_path) - 1) . "cpp"
    return cpp_file
endfunction

