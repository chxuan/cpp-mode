" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppfun
" Create Date: 2018-05-01
" License: MIT
" ==============================================================

" 删除字符串左边空格和制表符
function! cppfun#util#TrimLeft(str)
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
function! cppfun#util#EraseStringList(str, list)
    let result = a:str

    for i in range(0, len(a:list) - 1)
        let result = cppfun#util#ReplaceString(result, a:list[i], "")
    endfor
    
    return result
endfunction

" 替换字符串
function! cppfun#util#ReplaceString(str, src, target)
    " return substitute(a:str, a:src, a:target, "")
    return substitute(a:str, a:src, a:target, "g")
endfunction

"删除特定字符
function! cppfun#util#EraseChar(str, token)
    let result = ""

    for i in range(0, len(a:str) - 1)
        if a:str[i] != a:token
            let result = result . a:str[i]
        endif
    endfor

    return result
endfunction

" 判断字符串(列表)包含
function! cppfun#util#IsContains(main, sub)
    return match(a:main, a:sub) != -1
endfunction

" 设置光标位置
function! cppfun#util#SetCursorPosition(line_num)
    let pos = [0, a:line_num, 0, 0]  
    call setpos(".", pos)
endfunction

" 在当前行写入文本
function! cppfun#util#WriteTextAtCurrentLine(text)
    execute "normal i" . a:text
endfunction

" 在下一行行写入文本
function! cppfun#util#WriteTextAtNextLine(text)
    execute "normal o" . a:text
endfunction

" 从当前行开始对齐
function! cppfun#util#CodeAlignment()
    execute "normal =G"
endfunction
