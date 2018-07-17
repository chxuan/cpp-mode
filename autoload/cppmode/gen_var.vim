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
    return search('^\<struct\>\|\<class\>\s\+.\+\n{', 'bnz')
endfunction

" 获得函数所在类名
function! s:get_class_name_of_var(row_num)
    let text = cppmode#util#get_row_text(a:row_num)
    return <sid>parse_class_name(text)
endfunction

" 解析类名
function! s:parse_class_name(text)
    return matchlist(a:text, '\(\<class\>\|\<struct\>\)\s\+\(\w\+\)')[2]
endfunction

" 获得变量骨架代码
function! s:get_var_skeleton()
    let ret = matchlist(s:var_declaration, '\s*static\s\+\(.\+\)\s\+\(\w\+\);')
    return ret[1] . " " . s:class_name . "::" . ret[2] . ";"
endfunction

