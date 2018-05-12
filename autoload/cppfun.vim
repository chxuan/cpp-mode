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
" 拷贝函数时，光标所在行
let s:fun_row_num = 0

" 拷贝函数
function! cppfun#CopyFunction()
    let s:fun_row_num = line('.')
    let s:fun_declaration = GetFunctionDeclaration()
    let s:fun_template_declaration = GetFunctionTemplateDeclaration()
    echo s:fun_template_declaration
    echo s:fun_declaration

    let line_num = GetLineNumOfClassName()
    let s:class_name = GetClassNameOfFunction(line_num)
    let s:class_template_declaration = GetClassTemplateDeclaration(line_num)
endfunction

" 粘贴函数
function! cppfun#PasteFunction()
    execute "normal o" . GetFunctionSkeleton()
    call SetCursorPosition(line('.') - 2)
endfunction

" 获得函数声明
function! GetFunctionDeclaration()
    return getline(".")
endfunction

" 获得函数模板声明
function! GetFunctionTemplateDeclaration()
    let current_num  = line('.')
    let line = getline(current_num - 1)

    if IsContains(line, "template")
        return line
    else
        return ""
    endif
endfunction

" 获得类名所在行号
function! GetLineNumOfClassName()
    let line_num = search('\%(\<class\>\|\<struct\>\)\_\s\+\w\+\_\s\+\%(:\%(\_\s*\w\+\)\{1,2}\)\?\_\s*{', 'b')
    call SetCursorPosition(s:fun_row_num)
    return line_num
endfunction

" 获得函数所在类名
function! GetClassNameOfFunction(line_num)
    let line = getline(a:line_num)
    return ParseClassName(line)
endfunction

" 获得类模板声明
function! GetClassTemplateDeclaration(line_num)
    let line = getline(a:line_num - 1)

    if IsContains(line, "template")
        return line
    else
        return ""
    endif
endfunction

" 判断字符串(列表)包含
function! IsContains(main, sub)
    return match(a:main, a:sub) != -1
endfunction

" 解析类名
function! ParseClassName(line)
    return matchlist(a:line, '\(\<class\>\|\<struct\>\)\s\+\(\w[a-zA-Z0-9_]*\)')[2]
endfunction

" 获得函数骨架代码
function! GetFunctionSkeleton()
    let skeleton = RemoveFunctionKeyWords()

    if IsContains(skeleton, s:class_name . "(")
        let skeleton = GetDefaultFunction(skeleton)
    else
        let skeleton = GetNormalFunction(skeleton)
    endif

    if IsContains(skeleton, "=")
        let skeleton = CleanFunctionParamValue(skeleton)
    endif

    if s:fun_template_declaration != ""
        let skeleton = AddFunctionTemplate(skeleton)
    endif

    if s:class_template_declaration != ""
        let skeleton = AddClassTemplate(skeleton)
    endif

    return AddFunctionBody(skeleton)
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
        let result = ReplaceString(result, a:list[i], "")
    endfor
    
    return result
endfunction

" 替换字符串
function! ReplaceString(str, src, target)
    return substitute(a:str, a:src, a:target, "")
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

" 去除函数关键字
function! RemoveFunctionKeyWords()
    let key_words = ["inline", "static", "virtual", "explicit", "override", "final"]
    return EraseChar(TrimLeft(EraseStringList(s:fun_declaration, key_words)), ";")
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

" 注释函数默认参数值
function! CleanFunctionParamValue(fun)
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
function! AddFunctionTemplate(fun)
    return TrimLeft(s:fun_template_declaration) . "\n" . a:fun
endfunction

" 增加类模板
function! AddClassTemplate(fun)
    let type = GetClassTemplateType()
    return s:class_template_declaration . "\n" . ReplaceString(a:fun, "::", type . "::")
endfunction

" 获得类类型
function! GetClassTemplateType()
    let key_words = ["template", "typename", "class"]
    return EraseChar(EraseStringList(s:class_template_declaration, key_words), " ")
endfunction

" 增加函数体
function! AddFunctionBody(fun)
    return a:fun . "\n{\n\n}\n"
endfunction

" 设置光标位置
function! SetCursorPosition(line_num)
    let pos = [0, a:line_num, 0, 0]  
    call setpos(".", pos)
endfunction
