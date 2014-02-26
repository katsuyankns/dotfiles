;;;;;;;;;;;;
;;; TODO ;;;
;;;;;;;;;;;;

; elisp list

;;;;;;;;;;;;;;;
;;; general ;;;
;;;;;;;;;;;;;;;

(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)

(load-theme 'wombat t)

(setq inhibit-startup-message t)
(setq frame-title-format "%f")
(global-linum-mode t)
(global-hl-line-mode t)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(setq show-paren-delay 0)
(setq show-paren-style 'mixed)
(show-paren-mode t)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(setq display-time-24hr-format t)
(display-time-mode t)

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

(setq completion-ignore-case t)
(global-auto-revert-mode 1)
(setq visible-bell t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq-default kill-read-only-ok t)
(windmove-default-keybindings 'super)

(cua-mode t)
(setq cua-enable-cua-keys nil)

(require 'tramp)
(setq tramp-default-method "ssh")

(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elisp")

;;;;;;;;;;;;;;;
;;; package ;;;
;;;;;;;;;;;;;;;

(require 'package)
(setq package-user-dir "~/.emacs.d/elisp/elpa/")
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
(package-refresh-contents)

(require 'cl)
(defvar installing-package-list
  '(
; util-command
    all
    all-ext
    redo+
		move-text
    multi-term
		buffer-move
		point-undo
		shell-pop

; key-bind
    key-chord
		key-combo
		guide-key
		free-keys

; highlight
		auto-highlight-symbol
		highlight-symbol

; auto-complete
    auto-complete
		fuzzy
		pos-tip

; buffer
    popwin
		yascroll

; flymake
    flycheck
    flymake-ruby
		flymake-jslint

; helm
    helm
		helm-descbinds

; er/mc
		expand-region
		multiple-cursors

; git
    magit
		git-gutter

; ruby
    rsense
		ruby-mode
		ruby-end
		ruby-block
    inf-ruby
    rinari

; python
    ;jedi

; go
    ;go-mode

    ))

  (let ((not-installed (loop for x in installing-package-list
                              when (not (package-installed-p x))
                              collect x)))
    (when not-installed
      (package-refresh-contents)
      (dolist (pkg not-installed)
        (package-install pkg))))

;;;;;;;;;;;;;;
;;; el-get ;;;
;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match that used by the user's shell.

This is particularly useful under Mac OSX, where GUI apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

;;;;;;;;;;;;
;;; labo ;;;
;;;;;;;;;;;;

;; util-command

;; (require 'all-ext)

;; (require 'move-text)

;; (require 'redo+)

(global-undo-tree-mode)

;; (require 'point-undo)

;; key-chord
(require 'key-chord)

;; key-combo
(require 'key-combo)
(key-combo-mode t)

;; auto-complete
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
               "~/.emacs.d/elisp/ac-dict")
  ; (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;; helm
(require 'helm-config)
(helm-mode t)
(helm-descbinds-mode t)
(define-key helm-map (kbd "C-c C-a") 'all-from-helm-occur)

;; popwin
(require 'popwin)
(popwin-mode t)
(setq display-buffer-function 'popwin:display-buffer)
(setq popwin:popup-window-position 'bottom)

;; flymake


;; expand-region
(require 'expand-region)

;; multiple-cursors
(require 'multiple-cursors)

;; highlight
(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)

(require 'highlight-symbol)
(setq highlight-symbol-colors '("DarkOrange" "DodgerBlue1" "DeepPink1"))

(global-set-key (kbd "C-@") 'highlight-symbol-at-point)
(global-set-key (kbd "C-x C-@") 'highlight-symbol-remove-all)

;;;;;;;;;;;;;;;;;;;;;;;;;
;;; original-function ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(defun kill-line-or-region ()
 "kill region if active only or kill line normally"
  (interactive)
  (if (region-active-p)
      (call-interactively 'kill-region)
    (call-interactively 'kill-line)))

(defun copy-line-or-region (&optional arg)
 "copy region if active only or copy line normally"
  (interactive)
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (kill-ring-save (line-beginning-position) (line-beginning-position 2))))

(defun elisp-mode-hooks ()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))

;;;;;;;;;;;;
;;; hook ;;;
;;;;;;;;;;;;

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)

;;;;;;;;;;;;;;;;;;;;;;
;;; function-alias ;;;
;;;;;;;;;;;;;;;;;;;;;;

(defalias 'dtw 'delete-trailing-whitespace)
(defalias 'exit 'save-buffers-kill-terminal)
(defalias 'rom 'read-only-mode)
(defalias 'ttl 'toggle-truncate-lines)

;;;;;;;;;;;;;;;;
;;; key-bind ;;;
;;;;;;;;;;;;;;;;

;(global-set-key (kbd "C-") ')

;; C (Top Priority)

; "C-a" move-beginning-of-line
; "C-b" backward-char
; "C-c" #
; "C-d" delete-char
; "C-e" move-end-of-line
; "C-f" forward-char
; "C-g" keyboard-quit
(keyboard-translate ?\C-h ?\C-?) ;help-command > C-?
; "C-i" indent-for-tab-command
; "C-j" newline-and-indent
(global-set-key (kbd "C-k") 'kill-line-or-region) ;upgraded
; "C-l" recenter-top-bottom
; "C-m" newline
; "C-n" next-line
; "C-o" open-line
; "C-p" previous-line
; "C-q" quoted-insert ?
; "C-r" isearch-backward
; "C-s" isearch-forward
; "C-t" transpose-chars
; "C-u" universal-argument
; "C-v" cua-scroll-up
(global-set-key (kbd "C-w") 'backward-kill-word) ;kill-region > C-k
; "C-x" #
; "C-y" cua-paste
(global-set-key (kbd "C-z") 'other-window) ;suspend-frame > none
(global-set-key (kbd "C-;") 'helm-mini) ;new
(global-set-key (kbd "C-'") 'dabbrev-expand) ;shortcut < M-/
(global-set-key (kbd "C-,") 'er/expand-region) ;new(expand-region)
(global-set-key (kbd "C-.") 'mc/mark-all-like-this-dwim) ;new(multiple-cursors)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this) ;new(multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this) ;new(multiple-cursors)
(global-set-key (kbd "C-?") 'help-command) ;new
; "C-\" toggle-input-method
(define-key global-map[C-tab] 'auto-complete) ;new
(define-key global-map [S-C-tab]
  (lambda () (interactive) (other-window -1))) ;new
(global-set-key (kbd "C-!") 'shell-command) ;shortcut < M-!
; "C-@" highlight-symbol-at-point
(global-set-key (kbd "C-%") 'query-replace) ;shortcut < M-%

;; C-S

(global-set-key (kbd "C-S-a") 'beginning-of-line)
(global-set-key (kbd "C-S-b") 'backward-word)
;(global-set-key (kbd "C-S-c") ')
(global-set-key (kbd "C-S-e") 'end-of-line)

;; M

; "M-a" backward-sentence
; "M-b" backward-word
; "M-c" capitalize-word
; "M-d" kill-word
; "M-e" forward-sentence
; "M-f" forward-word
(global-set-key (kbd "M-g") 'goto-line) ;shortcut < M-g g
; "M-h" mark-paragraph
; "M-i" tab-to-tab-stop ?
; "M-j" indent-new-comment-line ?
(global-set-key (kbd "M-k") 'kill-whole-line) ;kill-sentence > none
; "M-l" downcase-word
; "M-m" back-to-indentation
(global-set-key (kbd "M-n") 'move-text-down) ;new(move-text)
; "M-o" #font
(global-set-key (kbd "M-p") 'move-text-up) ;new(move-text)
; "M-q" fill-paragraph ?
(global-set-key (kbd "M-r") 'isearch-backward-regexp) ;move-to-window-line > none
(global-set-key (kbd "M-s") 'isearch-forward-regexp) ;prefix > none
; "M-t" transpose-words
; "M-u" upcase-word
; "M-v" cua-scroll-down
(global-set-key (kbd "M-w") 'backward-kill-sentence) ;kill-ring-save > M-y
; "M-x" execute-extended-command
(global-set-key (kbd "M-y") 'copy-line-or-region) ;show-kill-ring > C-x y
; "M-z" zap-to-char
(global-set-key (kbd "M-?") 'help-for-help) ;new
(global-set-key (kbd "M-[") 'point-undo);new
(global-set-key (kbd "M-]") 'point-redo) ;new;

;; M-S

;; s

; "s-a" mark-whole-buffer
(global-set-key (kbd "s-0") 'delete-window) ;shortcut < C-x 0
(global-set-key (kbd "s-1") 'delete-other-windows) ;shortcut < C-x 1
(global-set-key (kbd "s-2") 'split-window-vertically) ;shortcut < C-x 2
(global-set-key (kbd "s-3") 'split-window-horizontally) ;shortcut < C-x 3
(global-set-key (kbd "s-,") 'windmove-left) ;customize > none
(global-set-key (kbd "s-.") 'windmove-right) ;new

;; C-M

; "C-M-a" beginning-of-defun
; "C-M-b" backward-sexp
; "C-M-c" exit-recursive-edit
; "C-M-d" down-list
; "C-M-e" end-of-defun
; "C-M-f" forward-sexp
; "C-M-g"
; "C-M-h" mark-defun
; "C-M-i" auto-complete
; "C-M-j" indent-new-comment-line
; "C-M-k" kill-sexp
; "C-M-l" reposition-window
; "C-M-m"
; "C-M-n" forward-list
; "C-M-o" split-line
; "C-M-p" backward-list

;; C-x (New Window)

(global-set-key (kbd "C-x a") 'helm-ag) ;
(global-set-key (kbd "C-x b") 'helm-buffers-list) ;upgraded(helm)
; "C-x c" #
; "C-x d" dired
(global-set-key (kbd "C-x e") 'eshell) ;kmacro-end-or-call-macro > none
(global-set-key (kbd "C-x f") 'helm-for-files) ;set-fill-column > none
(global-set-key (kbd "C-x g") 'helm-do-grep) ;new
(global-set-key (kbd "C-x h") 'info) ;mark-whole-buffer > C-x C-a
(global-set-key (kbd "C-x i") 'helm-imenu) ;insert-file > none
(global-set-key (kbd "C-x m") 'multi-term) ;compose-mail > none
(global-set-key (kbd "C-x o") 'helm-occur) ;other-window > C-tab
(global-set-key (kbd "C-x p") 'package-list-packages-no-fetch)
(global-set-key (kbd "C-x t") 'shell-pop) ;new
(global-set-key (kbd "C-x x") 'helm-M-x) ;new
(global-set-key (kbd "C-x y") 'helm-show-kill-ring) ;new
(global-set-key (kbd "C-x ?") 'info) ;new
(global-set-key (kbd "C-x ;") 'helm-resume) ; new

;; C-x C

; "C-x C-a" ahs-edit-mode
(global-set-key (kbd "C-x C-b") 'switch-to-buffer) ;upgraded
(global-set-key (kbd "C-x C-k") 'kill-this-buffer) ;edit-kbd-macro > none
(global-set-key (kbd "C-x C-p") 'package-install) ;mark-page > none
(global-set-key (kbd "C-x C-q") 'query-replace) ;shortcut < M-%
(global-set-key (kbd "C-x C-r") 'helm-recentf) ;find-file-read-onle > none
(global-set-key (kbd "C-x C-t") 'transpose-paragraphs) ;transpose-line > M-n
(global-set-key (kbd "C-x C-,") 'er/contract-region) ;new(expand-region)
(global-set-key (kbd "C-x C-.") 'mc/edit-lines) ;new(multiple-cursors)
(global-set-key (kbd "C-x C-/") 'redo) ;new(redo+)
