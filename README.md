helm-bm
=======

Visible Bookmark bm.el helm interface

List All bookmarks using helm.el

List Bookmarks in current buffer in helm.el

```
 1.
     (require 'bm)
     (global-set-key (kbd "<C-f2>") 'bm-toggle)
     (global-set-key (kbd "<f2>")   'bm-next)
     (global-set-key (kbd "<S-f2>") 'bm-previous)

 2  To use this package, add these lines to your init.el or .emacs file:
     (require 'helm-bm)
     (global-set-key (kbd "M-*")  'helm-bm)

```
