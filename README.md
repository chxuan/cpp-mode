cpp-mode: A C++ IDE for vim
===============================================

![][1]

安装
------------
    
- `vim-plug`

    Plug 'chxuan/cpp-mode'

- `Vundle`

    Plugin 'chxuan/cpp-mode'

使用
------------

- `:CopyFun`

    拷贝函数，和`:PasteFun`结合使用

- `:PasteFun`

    生成函数实现，和`:CopyFun`结合使用

- `:GoToDefinition`
    
    转到函数实现，该功能可替代ycm提供的转到函数实现（因为ycm转到函数实现经常不成功）

- `:Switch`

    c++头文件和实现文件切换

- `:FormatFunParam`

    格式化函数参数，用于函数参数列表过多的情况

- `:FormatIf`

    格式化if条件，用于if条件判断过多的情况


License
------------

This software is licensed under the [MIT license][2]. © 2018 chxuan


  [1]: https://raw.githubusercontent.com/chxuan/cpp-mode/master/screenshots/cpp-mode.gif
  [2]: https://github.com/chxuan/cpp-mode/blob/master/LICENSE
