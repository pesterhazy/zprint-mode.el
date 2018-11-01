# zprint-mode.el

Integrates [zprint](https://github.com/kkinnear/zprint), the pretty-printer for Clojure(Script) files, into Emacs

zprint-mode reformats files quickly (<100ms) because it uses [precompiled native binaries](https://github.com/kkinnear/zprint/blob/master/doc/graalvm.md) of zprint. It works on macOS or Linux.

## Installation

Download zprint-mode.el and save it somewhere where emacs can find it, e.g. `~/.emacs.d/lisp/`.

You only need zprint-mode.el - the zprint graalvm binary is downloaded automagically on first run.

You will probably need to add that directory to Emacs's load path:

```
# e.g.
(add-to-list 'load-path "~/.emacs.d/lisp/")
```

Then you will need to require the package:

```
(require 'zprint-mode)
```

## Manual usage

Filter the current buffer through zprint my invoking `M-x zprint`.

If a region is selected, only that region will be pretty-printed.

You can set up a keyboard shortcut if that's your thing:

```
(global-set-key (kbd "C-c p") 'zprint)
```

Or if you're running Spacemacs or otherwise using Evil mode:

```
(evil-leader/set-key "op" 'zprint)
```

## Automatic usage

Alternatively, you can enable zprint-mode in the current buffer. With zprint-mode enabled, the current buffer is auto-formatted whenever you save.

```
M-x zprint-mode
```

If you're feeling adventurous, you can enable zprint-mode for all Clojure(Script) files:

```
(add-hook 'clojure-mode-hook 'zprint-mode)
(add-hook 'clojurescript-mode-hook 'zprint-mode)
```

## Author

Paulus Esterhazy <pesterhazy@gmail.com>
