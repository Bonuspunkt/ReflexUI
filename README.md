# ReflexUI

## installation
- on the right side is download zip button
- extract the content to `<steam>\steamapps\common\Reflex\base\internal\ui` and rename `ReflexUI-master` to `bonus`
- start reflex and setup your new widgets


## getting luacheck to run on windows
this is optional if you want a little bit of help while developing
### download
- [LuaForWindows](https://code.google.com/p/luaforwindows/)
- [Luacheck](https://github.com/mpeterv/luacheck)

### install
- install `LuaForWindows`
- extract `luacheck`
  - place `bin\luacheck.lua` at `C:\Program Files (x86)\Lua\5.1\`
  - create `C:\Program Files (x86)\Lua\5.1\luacheck.bat`
    ``` batch
    @ECHO OFF
    SETLOCAL
    "%LUA_DEV%\lua" "%LUA_DEV%\luacheck.lua" %*
    ENDLOCAL

    ```
  - copy the directory `src\luacheck` to `C:\Program Files (x86)\Lua\5.1\Lua`

### setting up an editor
- install [Atom](http://atom.io)
- `File` -> `Settings` -> `Install`
  - `language-lua` (syntax highlighting)
  - `linter`
  - `linter-luacheck`
- click `settings` after `linter-luacheck` has successfully installed
- set `Executable` to `C:\Program Files (x86)\Lua\5.1\luacheck`
