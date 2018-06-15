" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppmode
" Create Date: 2018-06-15
" License: MIT
" ==============================================================

" 变量声明
let s:var_declaration = ""
" 类名
let s:class_name = ""

" 拷贝变量
function! cppmode#gen_var#copy_variate()
    let s:var_declaration = <sid>get_var_declaration()
    echo s:var_declaration

    let row_num = <sid>get_row_num_of_class_name()
    let s:class_name = <sid>get_class_name_of_var(row_num)
endfunction

" 粘贴变量
function! cppmode#gen_var#paste_variate()
    call cppmode#util#write_text_at_next_row(<sid>get_var_skeleton())
endfunction

" 获得变量声明
function! s:get_var_declaration()
    return cppmode#util#get_current_row_text()
endfunction

" 获得类名所在行号
function! s:get_row_num_of_class_name()
    let current_num = cppmode#util#get_current_row_num()

    while current_num >= 1
        let text = cppmode#util#get_row_text(current_num)
        if (cppmode#util#is_contains(text, "class ") || cppmode#util#is_contains(text, "struct ")) && !cppmode#util#is_contains(text, "template")
            return current_num
        endif
        let current_num -= 1
    endwhile

    return -1
endfunction

" 获得函数所在类名
function! s:get_class_name_of_var(row_num)
    let text = cppmode#util#get_row_text(a:row_num)
    return <sid>parse_class_name(text)
endfunction

" 解析类名
function! s:parse_class_name(text)
    return matchlist(a:text, '\(\<class\>\|\<struct\>\)\s\+\(\w[a-zA-Z0-9_]*\)')[2]
endfunction

" 获得变量骨架代码
function! s:get_var_skeleton()
    let skeleton = <sid>remove_var_key_words()
    let pos = cppmode#util#find_r(skeleton, " ")

    return cppmode#util#substr(skeleton, 0, pos + 1) . s:class_name . "::" . cppmode#util#substr(skeleton, pos + 1, len(skeleton))
endfunction

" 去除变量关键字
function! s:remove_var_key_words()
    let key_words = ["static"]
    return cppmode#util#trim_left(cppmode#util#erase_string_list(s:var_declaration, key_words))
endfunction

