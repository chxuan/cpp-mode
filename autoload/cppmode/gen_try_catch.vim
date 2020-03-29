" ==============================================================
" Author: chxuan <787280310@qq.com>
" Repository: https://github.com/chxuan/cppmode
" Create Date: 2020-03-28
" License: MIT
" ==============================================================

" 生成try catch代码
function! cppmode#gen_try_catch#gen_code()
    let curr = cppmode#util#get_current_row_num()
    let skeleton = <sid>get_try_catch_skeleton()
    call cppmode#util#write_text_at_last_row(skeleton)
    call cppmode#util#set_cursor_position(curr, 0)
    let cnt = cppmode#util#get_char_count(@", "\n")
    call cppmode#util#set_code_alignment(7 + cnt)
    call cppmode#util#set_cursor_position(curr + cnt + 5, 0)
endfunction

" 生成代码骨架
function! s:get_try_catch_skeleton()
    return "try\n{\n" . @" . "}\ncatch (std::exception& e)\n{\n\n}\n"
endfunction
