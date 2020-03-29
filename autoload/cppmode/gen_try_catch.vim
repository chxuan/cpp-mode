" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppmode
" Create Date: 2020-03-28
" License: MIT
" ==============================================================

" 生成try catch代码
function! cppmode#gen_try_catch#gen_code()
    let curr = cppmode#util#get_current_row_num()
    let text = cppmode#util#get_current_row_text()
    let skeleton = <sid>get_try_catch_skeleton(text)
    call cppmode#util#delete_current_row()
    call cppmode#util#write_text_at_current_row(skeleton)
    call cppmode#util#set_cursor_position(curr, 0)
    call cppmode#util#set_code_alignment(8)
    call cppmode#util#set_cursor_position(curr + 6, 0)
endfunction

" 生成代码骨架
function! s:get_try_catch_skeleton(text)
    return "try\n{\n" . a:text . "\n}\ncatch (std::exception& e)\n{\n\n}\n"
endfunction

