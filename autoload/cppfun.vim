" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppfun
" Create Date: 2018-05-01
" License: MIT
" ==============================================================

" 函数所在行代码
let s:function_line = ""
" 函数所在类名
let s:class_name = ""

" 拷贝函数
function! cppfun#CopyFunction()
    let s:function_line = getline(".")
    echo s:function_line

    let s:class_name = GetClassNameOfFunction()
endfunction

" 粘贴函数
function! cppfun#PasteFunction()
    execute "normal o" . GetFunctionSkeleton()
    call SetCursorPosInFunction()
endfunction

" 获得函数所在类名
function! GetClassNameOfFunction()
    let current_num  = line('.')

    while current_num >= 1
        let line = getline(current_num)
        if IsContains(line, "class ")
            return ParseClassName(line)
        endif
        let current_num = current_num - 1
    endwhile

    return ""
endfunction

" 判断字符串(列表)包含
function! IsContains(main, sub)
    return match(a:main, a:sub) != -1
endfunction

" 解析类名
function! ParseClassName(line)
    let list = split(a:line, ":")
    let list = split(list[0], "class ")
    let temp = ""

    if len(list) == 1
        let temp = list[0]
    elseif len(list) == 2
        let temp = list[1]
    endif

    let class_name = ""

    for i in range(0, len(temp) - 1)
        if temp[i] != " " && temp[i] != "{" && temp[i] != "*" && temp[i] != "/"
            let class_name = class_name . temp[i]
        endif
    endfor

    return class_name
endfunction

" 获得函数骨架代码
function! GetFunctionSkeleton()
    let key_words = ["inline", "static", "virtual", "override", "final"]
    let skeleton = EraseChar(TrimLeft(EraseStringList(s:function_line, key_words)), ";")

    if IsContains(skeleton, s:class_name . "(")
        let skeleton = GetDefaultFunction(skeleton)
    else
        let skeleton = GetNormalFunction(skeleton)
    endif

    return skeleton . "\n{\n\n}\n"
endfunction

" 删除字符串左边空格和制表符
function! TrimLeft(str)
    let status = 1
    let result = ""

    for i in range(0, len(a:str) - 1)
        if status == 1 && a:str[i] != " " && a:str[i] != "\t"
            let result = result . a:str[i]
            let status = 2
        elseif status == 2
            let result = result . a:str[i]
        endif
    endfor

    return result
endfunction

" 删除字符串列表
function! EraseStringList(str, list)
    let result = a:str

    for i in range(0, len(a:list) - 1)
        let result = substitute(result, a:list[i], "", "")
    endfor
    
    return result
endfunction

"删除特定字符
function! EraseChar(str, token)
    let result = ""

    for i in range(0, len(a:str) - 1)
        if a:str[i] != a:token
            let result = result . a:str[i]
        endif
    endfor

    return result
endfunction

" 获得默认类成员函数（构造函数、析构函数等没有返回值的函数）
function! GetDefaultFunction(fun)
    return s:class_name . "::" . a:fun
endfunction

" 获得一般类成员函数
function! GetNormalFunction(fun)
    let pos = stridx(a:fun, "(")
    let temp = strpart(a:fun, 0, pos)
    let fun_pos = strridx(temp, " ")
    return strpart(a:fun, 0, fun_pos) . " " . s:class_name . "::" . strpart(a:fun, fun_pos + 1, len(a:fun))
endfunction

" 设置光标位置
function! SetCursorPosInFunction()
    let pos = [0, line(".") - 2, 0, 0]  
    call setpos(".", pos)  
endfunction
