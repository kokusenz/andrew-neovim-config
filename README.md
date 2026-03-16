## Dependencies, that are not in init.lua:
git, ripgrep, fd, vim plug

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
