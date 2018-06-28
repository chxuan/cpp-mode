cpp-mode: A C++ IDE for vim
===============================================

![][1]

## 安装
    
- `vim-plug`

    Plug 'chxuan/cpp-mode'

- `Vundle`

    Plugin 'chxuan/cpp-mode'

## 使用

- `:CopyCode`

    拷贝函数或变量，和`:PasteCode`结合使用

- `:PasteCode`

    生成函数实现或变量定义，和`:CopyCode`结合使用

- `:GoToFunImpl`
    
    转到函数实现，该功能可替代ycm提供的转到函数实现（因为ycm转到函数实现经常不成功）

- `:Switch`

    c++头文件和实现文件切换

- `:FormatFunParam`

    格式化函数参数，用于函数参数列表过多的情况

- `:FormatIf`

    格式化if条件，用于if条件判断过多的情况

## 参考配置

请将以下配置加到 `~/.vimrc`，如果不喜欢以下映射，可根据个人喜好更改。

    nnoremap <leader>y :CopyCode<cr>
    nnoremap <leader>p :PasteCode<cr>
    nnoremap <leader>U :GoToFunImpl<cr>
    nnoremap <silent> <leader>a :Switch<cr>
    nnoremap <leader><leader>fp :FormatFunParam<cr>
    nnoremap <leader><leader>if :FormatIf<cr>

## License

This software is licensed under the [MIT license][2]. © 2018 chxuan


  [1]: https://raw.githubusercontent.com/chxuan/cpp-mode/master/screenshots/cpp-mode.gif
  [2]: https://github.com/chxuan/cpp-mode/blob/master/LICENSE
