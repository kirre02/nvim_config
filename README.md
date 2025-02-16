# My IDE config for Neovim

>why did I make this repo?

This is a config that would provide me with a starting that is fully featured as I am someone who is new to Neovim.

### Install Neovim

You can install Neovim from package managers e.g brew, apt, pacman etc.. just remember that when you update packages Neovim may upgrade to a newer version.

if you want to make sure that Neovim only upgrade when you want it to then I recommend to install it from source:
  **NOTE** Verify the required [build prerequisites](https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites) for your system.
  ```sh
git clone https://github.com/neovim/neovim.git
cd neovim
git checkout release-0.8
make CMAKE_BUILD_TYPE=Release
sudo make install
```
### Install config
Make sure to remove or move your current `nvim` directory

```sh
git clone https://github.com/LunarVim/nvim-basic-ide.git ~/.config/nvim
```

Run `nvim` and wait for the plugins to be installed

# Configuration

### LSP

To add a new LSP

First Enter:

```
:Mason
```

use jk or arrow keys to move through the list of LSPs and press `i` on the Language Server you wish to install

Next you will need to add the server to this list: [servers](https://github.com/kirre02/nvim_config/blob/main/lua/user/lsp/mason.lua)

Note: Builtin LSP doesn't contain all lsps from [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#terraform_lsp).

If you want to install any from there, for example terraform_lsp(which adds more functionality than terraformls, like complete resource listing),

1. You can add the lsp name in the [lsp block](https://github.com/kirre02/nvim_config/blob/main/lua/user/lsp/mason.lua)

```lua
-- lua/usr/lsp/lsp-installer.lua
local servers = {
	"sumneko_lua",
	"cssls",
	"html",
	"tsserver",
	"pyright",
	"bashls",
	"jsonls",
	"yamlls",
  "terraform_lsp" -- New LSP
}
```
