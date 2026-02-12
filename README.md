# Neovim Dotfiles

My personal Neovim configuration.

| module | name |
| --- | --- |
| Plugin Manager | [lazy.nvim](https://github.com/folke/lazy.nvim) |
| LSP | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) |
| Package Manager | [mason](https://github.com/mason-org/mason.nvim) |
| Formatter | [conform.nvim](https://github.com/stevearc/conform.nvim) |
| Linter | [nvim-lint](https://github.com/mfussenegger/nvim-lint) |
| AI Assistant | [copilot](https://www.npmjs.com/package/@github/copilot-language-server) |
| Debugger | [vimspector](https://github.com/puremourning/vimspector) |

## Usage

Linux/macOS soft link to home config folder `~/.config/nvim`.

```shell
ln -sf $PWD ~/.config/nvim
```

The first launch will be a bit slow; neovim will automatically install the relevant plugins and dependencies.

## Support Programming Languages

The following programming languages that I use are mainly supported and can be added as needed.

### Lua

[lua_ls](https://github.com/luals/lua-language-server)
[lazydev.nvim](https://github.com/folke/lazydev.nvim)

### Go

[gopls](https://github.com/golang/tools/tree/master/gopls)

### Python

[pyright](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#pyright) + [ruff](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ruff)

virtual environment use [venv-selector](https://github.com/linux-cultist/venv-selector.nvim)

### Nix

[nixd](https://github.com/nix-community/nixd)

NOTE: nixd need manual install

### Rust

[rust_analyzer](https://github.com/rust-lang/rust-analyzer)

### C/C++

[clangd](https://clangd.llvm.org/installation.html)

NOTE: clangd need manual install in aarch64 platform, mason not support it yet.
