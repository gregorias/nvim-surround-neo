<!-- markdownlint-disable MD013 MD033 MD041 -->

Nvim-surround-neo (NSN) is a Neovim plugin.
It is an extension for [nvim-surround][nvim-surround] aimed at better [Which
Key][which-key] support.

This plugin essentially provides two things:

- Full Which Key support. You’ll get hints for surrounds and motions.
- Flipped argument order. Instead providing a motion first and then a surround,
  NSN asks for the surround first and motion last.
  I think this is how Neovim operators should idiomatically work — by expecting
  the motion as the last argument.
  Somewhat coincidentally, this flip is necessary for Which Key to provide
  hints for both arguments.

## ⚡️ Requirements

- Neovim 0.11+
- Required plugin dependencies:
  - [nvim-surround][nvim-surround]
  - [Which Key][which-key]

## 📦 Installation

Install the plugin with your preferred package manager, such as [Lazy][lazy]:

```lua
{
  "gregorias/nvim-surround-neo",
  dependencies = {
    "kylechui/nvim-surround",
    "folke/which-key",
  },
}
```

## 🚀 Usage

> [!NOTE]
> TODO

## ⚙️ Configuration

> [!NOTE]
> TODO

## ⚠️ Limitations

You can not let any map overlap with an NSN map, because NSN uses WK’s `expand`
functionality.

## 🙏 Acknowledgments

Thanks to [kylechui](https://github.com/kylechui) for
[nvim-surround][nvim-surround], which is a staple in my Neovim workflow.

## 🔗 See also

- [Coerce](https://github.com/gregorias/coerce.nvim) — My Neovim plugin for
  for keyword coercion.
- [Coop](https://github.com/gregorias/coop.nvim) — My Neovim plugin for
  structured concurrency with coroutines.
- [Toggle](https://github.com/gregorias/toggle.nvim) — My Neovim plugin for
  toggling options.

[lazy]: https://github.com/folke/lazy.nvim
[nvim-surround]: https://github.com/kylechui/nvim-surround
[which-key]: https://github.com/folke/which-key.nvim
