" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppfun
" Create Date: 2018-05-01
" License: MIT
" ==============================================================

" 函数声明
let s:fun_declaration = ""
" 函数模板声明
let s:fun_template_declaration = ""
" 类名
let s:class_name = ""
" 模板类声明
let s:class_template_declaration = ""

" 拷贝函数
function! cppfun#gen_fun#copy_function()
    let s:fun_declaration = <sid>get_fun_declaration()
    let s:fun_template_declaration = <sid>get_fun_template_declaration()
    echo s:fun_template_declaration
    echo s:fun_declaration

    let row_num = <sid>get_row_num_of_class_name()
    let s:class_name = <sid>get_class_name_of_fun(row_num)
    let s:class_template_declaration = <sid>get_class_template_declaration(row_num)
endfunction

" 粘贴函数
function! cppfun#gen_fun#paste_function()
    call cppfun#util#write_text_at_next_row(<sid>get_fun_skeleton())
    call cppfun#util#set_cursor_position(cppfun#util#get_current_row_num() - 2)
endfunction

" 获得函数声明
function! s:get_fun_declaration()
    return cppfun#util#get_current_row_text()
endfunction

" 获得函数模板声明
function! s:get_fun_template_declaration()
    let current_num = cppfun#util#get_current_row_num()
    let text = cppfun#util#get_row_text(current_num - 1)

    if cppfun#util#is_contains(text, "template")
        return text
    else
        return ""
    endif
endfunction

" 获得类名所在行号
function! s:get_row_num_of_class_name()
    let current_num = cppfun#util#get_current_row_num()

    while current_num >= 1
        let text = cppfun#util#get_row_text(current_num)
        if (cppfun#util#is_contains(text, "class ") || cppfun#util#is_contains(text, "struct ")) && !cppfun#util#is_contains(text, "template")
            return current_num
        endif
        let current_num = current_num - 1
    endwhile

    return -1
endfunction

" 获得函数所在类名
function! s:get_class_name_of_fun(row_num)
    let text = cppfun#util#get_row_text(a:row_num)
    return <sid>parse_class_name(text)
endfunction

" 获得类模板声明
function! s:get_class_template_declaration(row_num)
    let text = cppfun#util#get_row_text(a:row_num - 1)

    if cppfun#util#is_contains(text, "template")
        return text
    else
        return ""
    endif
endfunction

" 解析类名
function! s:parse_class_name(text)
    return matchlist(a:text, '\(\<class\>\|\<struct\>\)\s\+\(\w[a-zA-Z0-9_]*\)')[2]
endfunction

" 获得函数骨架代码
function! s:get_fun_skeleton()
    let skeleton = <sid>remove_fun_key_words()

    if cppfun#util#is_contains(skeleton, s:class_name . "(")
        let skeleton = <sid>get_default_fun(skeleton)
    else
        let skeleton = <sid>get_normal_fun(skeleton)
    endif

    if cppfun#util#is_contains(skeleton, "=")
        let skeleton = <sid>clean_fun_param_value(skeleton)
    endif

    if s:fun_template_declaration != ""
        let skeleton = <sid>add_fun_template(skeleton)
    endif

    if s:class_template_declaration != ""
        let skeleton = <sid>add_class_template(skeleton)
    endif

    return <sid>add_fun_body(skeleton)
endfunction

" 去除函数关键字
function! s:remove_fun_key_words()
    let key_words = ["inline", "static", "virtual", "explicit", "override", "final"]
    return cppfun#util#erase_char(cppfun#util#trim_left(cppfun#util#erase_string_list(s:fun_declaration, key_words)), ";")
endfunction

" 获得默认类成员函数（构造函数、析构函数等没有返回值的函数）
function! s:get_default_fun(fun)
    return s:class_name . "::" . a:fun
endfunction

" 获得一般类成员函数
function! s:get_normal_fun(fun)
    let pos = stridx(a:fun, "(")
    let temp = strpart(a:fun, 0, pos)
    let fun_pos = strridx(temp, " ")

    return strpart(a:fun, 0, fun_pos) . " " . s:class_name . "::" . strpart(a:fun, fun_pos + 1, len(a:fun))
endfunction

" 注释函数默认参数值
function! s:clean_fun_param_value(fun)
    let status = 0
    let result = ""

    for i in range(0, len(a:fun) - 1)
        if a:fun[i] == "="
            let result = result . "/*"
            let status = 1
        elseif status == 1 && (a:fun[i] == "," || a:fun[i] == ")")
            let result = result . "*/"
            let status = 0
        endif

        let result = result . a:fun[i]
    endfor

    return result
endfunction

" 增加函数模板
function! s:add_fun_template(fun)
    return cppfun#util#trim_left(s:fun_template_declaration) . "\n" . a:fun
endfunction

" 增加类模板
function! s:add_class_template(fun)
    let type = <sid>get_class_template_type()
    return s:class_template_declaration . "\n" . cppfun#util#replace_string(a:fun, "::", type . "::")
endfunction

" 获得类类型
function! s:get_class_template_type()
    let key_words = ["template", "typename", "class"]
    return cppfun#util#erase_char(cppfun#util#erase_string_list(s:class_template_declaration, key_words), " ")
endfunction

" 增加函数体
function! s:add_fun_body(fun)
    return a:fun . "\n{\n\n}\n"
endfunction

