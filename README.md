## Dependencies:
brew install fzf ripgrep
brew install lua-language-server (optional, only if need lua)
npm install --global typescript-language-server prettier some-sass-language-server @angular/language-server

git-delta, if using 'diff'.

## Set Up:
Clone repository and replace your current `nvim` folder with this one
mv ~/.config/nvim ~/.config/nvim-old

## Install Plugins:
Navigate to init.lua
install plugins using Vim Plug
:PlugInstall

To install omnisharp for c#, dowload a release from the releases link (I have downloaded omnisharp-osx-arm-64-net6.0. Place into desired path, configure path in lsp.lua to hit either OmniSharp or run. If access error, make sure run/OmniSharp is executable by `chmod +x ~/[path]`
https://github.com/omnisharp/omnisharp-roslyn#downloading-omnisharp
if hitting error code 131, try uninstalling and reinstalling dotnet from the official website. Then, run `echo export DOTNET_ROOT=/usr/local/dotnet' >> ~/.zprofile` then `exec $SHELL -l # reload shell`. Check that the DOTNET_ROOT is set by running `dotnet --info`. 

### Keybinds
| Category                   | Mapping                                   | Action                                                                  |
|----------------------------|-------------------------------------------|-------------------------------------------------------------------------|
| **File Explorer**           | `-`                             | Return to the **file‑tree** view                                        |
| **fzf.lua**                | `<leader><leader>`                        | **Find files**                                                          |
|                            | `<leader>bf`                              | **Buffers** picker                                                      |
|                            | `<leader>gs`                              | **Git status** picker                                                   |
|                            | `<leader>gh`                              | **Git diff** picker                                                     |
|                            | `<leader>gr`                              | **Grep** (search text)                                                  |
|                            | `<leader>ga`                              | **Grep again** (resume previous grep)                                   |
|                            | `<leader>8` (visual mode)                 | **Grep visual** selection                                               |
|                            | `<leader>gl`                              | **Live grep** (search text across files)                                |
|                            | `<leader>fr`                              | **LSP references**                                                      |
|                            | `<leader>gi`                              | **LSP implementations**                                                 |
|                            | `<leader>cs`                              | **Colorscheme** picker                                                  |
|                            | `<leader>co`                              | **Quickfix** picker                                                     |
|                            | `alt-a` (in fzf picker)                   | **Select all** items and accept                                         |
| **LSP Actions**            | `<leader>gd`                              | **Go to definition**                                                    |
|                            | `<leader>hv`                              | **Hover** documentation                                                 |
|                            | `<leader>ca`                              | **Code action** (quick‑fix / import)                                    |
|                            | `<leader>fm`                              | **Format** current buffer                                               |
|                            | `<leader>ls`                              | **Stop LSP client** for current buffer                                  |
| **Window / Pane Navigation** | `<leader>wl` · `<leader>wh` · `<leader>wk` · `<leader>wj` | Move to the pane **right / left / up / down**                           |
|                            | `:vsp`                                    | Open a **vertical split**                                               |
|                            | `:vertical resize ±N`                     | **Resize** the current split by *N* columns                             |
| **Quickfix Navigation**     | `<leader>cn`                              | **Next** quickfix item                                                  |
|                            | `<leader>cp`                              | **Previous** quickfix item                                              |
| **Diagnostics**            | `<leader>do`                              | **Toggle** diagnostics on/off                                          |
|                            | `<leader>dd`                              | **Open floating** diagnostic window                                    |
|                            | `<leader>de`                              | **Toggle** between virtual text and virtual lines                      |
|                            | `<leader>da`                              | **Toggle** between current line only and all lines diagnostics         |
|                            | `<leader>db`                              | **Diagnostics** (current document) picker                              |
|                            | `<leader>dw`                              | **Diagnostics** (workspace) picker                                     |
| **Git/Diff**               | `<leader>dl`                              | **Open** diff'd files pane                                             |
|                            | `<leader>dm`                              | **Open** diff'd files menu                                             |
|                            | `,,`                                      | **jump to** vim ui select                                              |
|                            | `<leader>uc`                              | **Clear** diff markings from current buffer                            |
| **CLI Legend**            | `<leader>cl`                              | **Toggle** custom cli legend on/off                                     |
| **Argpoon**               | `<leader>hh`                              | **Add** current buffer to argument list and navigate to it              |
|                            | `<leader>hd`                              | **Delete** current buffer from argument list                           |
|                            | `<leader>hs`                              | Show **argpoon menu** (select from argument list)                      |
|                            | `<leader>h1-9`                            | **Navigate** to argument 1-9                                           |
|                            | `<C-h>1-9`                                | **Move** current buffer to position 1-9                                |
|                            | `<C-h>a-z`                                | **Move** current buffer to position 10-35 (a=10, b=11, ..., z=35)      |

### Argpoon (Argument List Management)
See keybinds table above for all argpoon navigation and repositioning shortcuts.

Commands for managing the argument list (directory-specific):
- `:ArgStash` (or `:ArgS`) - Save current argument list for the current directory to `~/.local/share/nvim/argpoon_history.json`
- `:ArgRestore` (or `:ArgR`) - Restore argument list for the current directory from saved file (does not clear existing args)

### C# Development
For C# files (`.cs`), the following commands are available:
- `:make` - Build the project using `dotnet build` (errors only, warnings filtered)
- `:DotnetTest` - Run tests using `dotnet test` and populate quickfix with failures
- `:copen` - Open the quickfix window to view build errors or test failures
