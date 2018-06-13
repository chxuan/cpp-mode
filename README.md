cppfun: A C++ IDE for vim
===============================================

安装
------------
    
如果你使用[Vundle][1]插件管理器, 将 `Plugin 'chxuan/cppfun'` 加到 `~/.vimrc` 然后执行 `:PluginInstall`.

使用
------------

请将以下配置加到 `~/.vimrc`，如果不喜欢以下映射，可根据个人喜好更改。

    nnoremap <leader>y :CopyFun<cr>
    nnoremap <leader>p :PasteFun<cr>
    nnoremap <leader>U :GoToDefinition<cr>
    nnoremap <leader><leader>fp :FormatFunParam<cr>
    nnoremap <leader><leader>if :FormatIf<cr>
    nnoremap <silent> <leader>a :Switch<cr>

截图
------------

![][3]

License
------------

This software is licensed under the [MIT license][2]. © 2018 chxuan


  [1]: https://github.com/VundleVim/Vundle.vim
  [2]: https://github.com/chxuan/cppfun/blob/master/LICENSE
  [3]: https://raw.githubusercontent.com/chxuan/cppfun/master/screenshots/cppfun.gif
