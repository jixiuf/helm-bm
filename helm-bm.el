;;; helm-bm.el ---  Visible Bookmark bm.el helm interface

;; Copyright (C) 2013 by 纪秀峰

;; Author: 纪秀峰 <jixiuf@gmail.com>
;; URL: https://github.com/jixiuf/helm-bm
;; Version: 1.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; `helm-bm.el' is bm.el `helm' interface.
;;
;; https://github.com/joodland/bm
;; http://www.emacswiki.org/emacs/VisibleBookmarks

;;
;; 1.  (require 'bm)
;;     (global-set-key (kbd "<C-f2>") 'bm-toggle)
;;     (global-set-key (kbd "<f2>")   'bm-next)
;;     (global-set-key (kbd "<S-f2>") 'bm-previous)

;; 2  To use this package, add these lines to your init.el or .emacs file:

;;     (require 'helm-bm)
;;     (global-set-key (kbd "M-*")  'helm-bm)
;;

(require 'helm)
(require 'helm-utils)
(require 'bm)

(defgroup helm-bm nil
  "bm.el helm interface."
  :group 'helm)

(defcustom helm-bm-default-binding 'global
  "default keybinding for `helm-bm' ,
if `global'  `helm-bm' List Bookmarks in All Buffers ,
             `C-uM-x:helm-bm' List Bookmarks in Current Buffer,
if `buffer'  `helm-bm' List Bookmarks in Current Buffer,
             `C-uM-x:helm-bm' List Bookmarks in All Buffers "
  :type '(choice (const :tag "List Bookmarks in All Buffers" global)
                 (const :tag "List Bookmarks in Current Buffer" buffer))
  :group 'helm-bm)


(defun helm-bm-global-init()
  "Init function for `helm-source-bm-global'."
  (with-current-buffer (helm-candidate-buffer 'global)
    (insert (bm-show-extract-bookmarks bm-in-lifo-order t))))

(defvar helm-source-bm-global
  '((name . "Visible Bookmarks in All Buffers")
    (init . helm-bm-global-init)
    (candidates-in-buffer)
    (get-line . buffer-substring)
    (persistent-action . helm-bm-goto-bookmark-persistent-action)
    (action . (("Goto bookmark" . helm-bm-goto-bookmark-action)
               ("Remove bookmark" . helm-bm-remove-bookmark-action))))
  "All Visible Bookmarks")

(defun helm-bm-init()
  "Init function for `helm-source-bm'"
  (with-current-buffer (helm-candidate-buffer 'global)
    (insert (bm-show-extract-bookmarks bm-in-lifo-order))))

(defvar helm-source-bm
  '((name . "Visible Bookmarks in Current Buffer ")
    (init . helm-bm-init)
    (candidates-in-buffer)
    (get-line . buffer-substring)
    (persistent-action . helm-bm-goto-bookmark-persistent-action)
    (action . (("Goto bookmark" . helm-bm-goto-bookmark-action)
               ("Remove bookmark" . helm-bm-remove-bookmark-action))))
  " Visible Bookmarks In Current Buffer")

(defun helm-bm-goto-bookmark-action(_c)
  (let* ((c (helm-get-selection nil 'withprop))
         (buffer-name (get-text-property 0 'bm-buffer c))
         (bookmark (get-text-property 0 'bm-bookmark c)))
    (if (null buffer-name)
        (message "No bookmark here.")
      (switch-to-buffer (get-buffer buffer-name))
      (bm-goto bookmark))))

(defun helm-bm-goto-bookmark-persistent-action(_c)
  (let* ((c (helm-get-selection nil 'withprop))
         (buffer-name (get-text-property 0 'bm-buffer c))
         (bookmark (get-text-property 0 'bm-bookmark c)))
    (if (null buffer-name)
        (message "No bookmark here.")
      (switch-to-buffer (get-buffer buffer-name))
      (bm-goto bookmark)
      (when (equal bm-highlight-style 'bm-highlight-only-fringe)
        (helm-match-line-color-current-line)))))


(defun helm-bm-remove-bookmark-action(_c)
  (let* ((c (helm-get-selection nil 'withprop))
         (buffer-name (get-text-property 0 'bm-buffer c))
         (bookmark (get-text-property 0 'bm-bookmark c)))
    (if (null buffer-name)
        (message "No bookmark here.")
      (bm-bookmark-remove bookmark))))


;;;###autoload
(defun helm-bm(&optional argv)
  "Preconfigured `helm' to list \"bm.el\" bookmarks."
  (interactive)
  (let ((helm-quit-if-no-candidate #'(lambda() (message "No Bookmark(s) found."))))
    (if (equal helm-bm-default-binding 'global)
        (if (= 1 (prefix-numeric-value current-prefix-arg))
            (helm :sources '(helm-source-bm-global)
                  :buffer "*helm bm*")
          (helm :sources '(helm-source-bm)
                :buffer "*helm bm*"))
      (if (= 1 (prefix-numeric-value current-prefix-arg))
          (helm :sources '(helm-source-bm)
                :buffer "*helm bm*")
        (helm :sources '(helm-source-bm-global)
              :buffer "*helm bm*")))))


(provide 'helm-bm)

;; Local Variables:
;; coding: utf-8
;; End:

;;; helm-bm.el ends here
