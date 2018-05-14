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
function! cppfun#gen_fun#CopyFunction()
    let s:fun_declaration = <sid>GetFunctionDeclaration()
    let s:fun_template_declaration = <sid>GetFunctionTemplateDeclaration()
    echo s:fun_template_declaration
    echo s:fun_declaration

    let line_num = <sid>GetLineNumOfClassName()
    let s:class_name = <sid>GetClassNameOfFunction(line_num)
    let s:class_template_declaration = <sid>GetClassTemplateDeclaration(line_num)
endfunction

" 粘贴函数
function! cppfun#gen_fun#PasteFunction()
    execute "normal o" . <sid>GetFunctionSkeleton()
    call cppfun#util#SetCursorPosition(line('.') - 2)
endfunction

" 获得函数声明
function! s:GetFunctionDeclaration()
    return getline(".")
endfunction

" 获得函数模板声明
function! s:GetFunctionTemplateDeclaration()
    let current_num  = line('.')
    let line = getline(current_num - 1)

    if cppfun#util#IsContains(line, "template")
        return line
    else
        return ""
    endif
endfunction

" 获得类名所在行号
function! s:GetLineNumOfClassName()
    let current_num  = line('.')

    while current_num >= 1
        let line = getline(current_num)
        if (cppfun#util#IsContains(line, "class ") || cppfun#util#IsContains(line, "struct ")) && !cppfun#util#IsContains(line, "template")
            return current_num
        endif
        let current_num = current_num - 1
    endwhile

    return -1
endfunction

" 获得函数所在类名
function! s:GetClassNameOfFunction(line_num)
    let line = getline(a:line_num)
    return <sid>ParseClassName(line)
endfunction

" 获得类模板声明
function! s:GetClassTemplateDeclaration(line_num)
    let line = getline(a:line_num - 1)

    if cppfun#util#IsContains(line, "template")
        return line
    else
        return ""
    endif
endfunction

" 解析类名
function! s:ParseClassName(line)
    return matchlist(a:line, '\(\<class\>\|\<struct\>\)\s\+\(\w[a-zA-Z0-9_]*\)')[2]
endfunction

" 获得函数骨架代码
function! s:GetFunctionSkeleton()
    let skeleton = <sid>RemoveFunctionKeyWords()

    if cppfun#util#IsContains(skeleton, s:class_name . "(")
        let skeleton = <sid>GetDefaultFunction(skeleton)
    else
        let skeleton = <sid>GetNormalFunction(skeleton)
    endif

    if cppfun#util#IsContains(skeleton, "=")
        let skeleton = <sid>CleanFunctionParamValue(skeleton)
    endif

    if s:fun_template_declaration != ""
        let skeleton = <sid>AddFunctionTemplate(skeleton)
    endif

    if s:class_template_declaration != ""
        let skeleton = <sid>AddClassTemplate(skeleton)
    endif

    return <sid>AddFunctionBody(skeleton)
endfunction

" 去除函数关键字
function! s:RemoveFunctionKeyWords()
    let key_words = ["inline", "static", "virtual", "explicit", "override", "final"]
    return cppfun#util#EraseChar(cppfun#util#TrimLeft(cppfun#util#EraseStringList(s:fun_declaration, key_words)), ";")
endfunction

" 获得默认类成员函数（构造函数、析构函数等没有返回值的函数）
function! s:GetDefaultFunction(fun)
    return s:class_name . "::" . a:fun
endfunction

" 获得一般类成员函数
function! s:GetNormalFunction(fun)
    let pos = stridx(a:fun, "(")
    let temp = strpart(a:fun, 0, pos)
    let fun_pos = strridx(temp, " ")

    return strpart(a:fun, 0, fun_pos) . " " . s:class_name . "::" . strpart(a:fun, fun_pos + 1, len(a:fun))
endfunction

" 注释函数默认参数值
function! s:CleanFunctionParamValue(fun)
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
function! s:AddFunctionTemplate(fun)
    return cppfun#util#TrimLeft(s:fun_template_declaration) . "\n" . a:fun
endfunction

" 增加类模板
function! s:AddClassTemplate(fun)
    let type = <sid>GetClassTemplateType()
    return s:class_template_declaration . "\n" . cppfun#util#ReplaceString(a:fun, "::", type . "::")
endfunction

" 获得类类型
function! s:GetClassTemplateType()
    let key_words = ["template", "typename", "class"]
    return cppfun#util#EraseChar(cppfun#util#EraseStringList(s:class_template_declaration, key_words), " ")
endfunction

" 增加函数体
function! s:AddFunctionBody(fun)
    return a:fun . "\n{\n\n}\n"
endfunction

