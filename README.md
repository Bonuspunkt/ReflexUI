# ReflexUI

## where can i download widgets
[here](https://bonuspunkt.github.io/reflexUI)

## developing under windows
well basically just open notepad and start to edit :D

if want some stuff to stay sane, try the following setup

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


### Reflex 0.33.4 workaround
since the require was replaced with a custom implementation,
i use the following code to inline my modules
``` C#
using System;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

class Program
{
    static Regex requireRegex = new Regex(@"local\s+(?<fieldName>\S+)\s*=\s*require\s+""(?<path>[^""]+)""");
    static bool needsSave = false;

    private static string workingDirectory = Path.Combine(Directory.GetCurrentDirectory(), "base");
    private static string OutputPath;

    static void Main(string[] args)
    {
        OutputPath = args[0];

        FileSystemWatcher watcher = new FileSystemWatcher(workingDirectory, "*.lua");
        watcher.Changed += (sender, e) => ProcessFile(e.FullPath);
        watcher.Created += (sender, e) => ProcessFile(e.FullPath);
        watcher.Deleted += (sender, e) => ProcessFile(e.FullPath);
        watcher.IncludeSubdirectories = true;
        watcher.EnableRaisingEvents = true;

        var files = Directory.GetFiles(workingDirectory, "*.lua", SearchOption.AllDirectories);

        foreach (var file in files)
        {
            ProcessFile(file);
        }

        Console.WriteLine("Press [enter] to exit");
        Console.ReadLine();
    }

    private static void ProcessFile(string file)
    {
        needsSave = false;
        try
        {
            Console.WriteLine("processing {0}", file);
            var patched = LoadContent(file);

            if (needsSave)
            {
                var combinedFile = Path.GetFullPath(Path.Combine(OutputPath, Path.GetFileNameWithoutExtension(file) + ".lua"));
                Console.WriteLine("combining to {0}", combinedFile);
                File.WriteAllText(combinedFile, patched, Encoding.UTF8);
                Console.WriteLine("combined");
            }
            else
            {
                Console.WriteLine("nothing to do");
            }
        }
        catch
        {
            Console.WriteLine("failed");
        }
    }

    private static string LoadContent(string path)
    {
        var content = File.ReadAllText(path);
        MatchEvaluator replacer = match => Replace(match, path);
        return requireRegex.Replace(content, replacer);

    }

    private static string Replace(Match match, string path)
    {
        needsSave = true;
        var targetPath = match.Result("${path}");
        Console.WriteLine("  found {0}", targetPath);
        if (targetPath.StartsWith(".")) // enabled relative requires
        {
            targetPath = Path.Combine(Path.GetDirectoryName(path), targetPath);
        }
        targetPath = Path.GetFullPath(targetPath);
        Console.WriteLine("  resolving to {0}", targetPath);

        return match.Result(
            "local ${fieldName} = (function()" + Environment.NewLine +
            "-- inlined " + match.Result("${path}") + Environment.NewLine +
            LoadContent(targetPath + ".lua") + Environment.NewLine +
            "end)()");
    }
}
```
compile with
``` batch
C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc /out:mergeLUA.exe .\Program.cs
```
run it with `mergeLUA <outputDirectory>`
