;;; init.el -*- lexical-binding: t; -*-

;; ──────────────────────────────────────────────────────────────
;; Package Management
;; ──────────────────────────────────────────────────────────────

(defun eug/focus-or-create-frame ()
  (let ((frames (cl-remove-if-not (lambda (f) (eq (framep f) 'ns)) (frame-list))))
    (if frames
        (select-frame-set-input-focus (car frames))
      (select-frame-set-input-focus
       (make-frame '((window-system . ns)))))))


(when (daemonp)
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (select-frame-set-input-focus frame)
              (raise-frame frame)
              (x-focus-frame frame))))

(setq debug-on-error t)
;; todo umut
(setq dashboard-footer-messages '(""))


(load-theme 'modus-operandi)
(require 'package)
(setq package-archives
      '(("melpa"  . "https://melpa.org/packages/")
        ("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)


(unless package-archive-contents
  (package-refresh-contents))
(require 'use-package)
(setq use-package-always-ensure t)

;; ──────────────────────────────────────────────────────────────
;; Sane Defaults
;; ──────────────────────────────────────────────────────────────

(setq-default
 delete-by-moving-to-trash t
 tab-width 4
 indent-tabs-mode nil
 uniquify-buffer-name-style 'forward
 window-combination-resize t
 x-stretch-cursor t
 fill-column 80)

(setq
 confirm-kill-emacs nil
 undo-limit 80000000
 auto-save-default t
 inhibit-compacting-font-caches t
 truncate-string-ellipsis "…"
 scroll-margin 2
 scroll-conservatively 101
 scroll-preserve-screen-position t
 auto-window-vscroll nil
 fast-but-imprecise-scrolling t
 ring-bell-function 'ignore
 create-lockfiles nil
 make-backup-files nil
 custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

;; Backups in one place
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory))))

;; Maximize frame after init (avoids macOS sizing bugs)
;;(add-hook 'emacs-startup-hook #'toggle-frame-maximized)

;; Clean UI
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

;; Dashboard
(use-package dashboard
  :demand t
  :config
  (setq dashboard-center-content t
        dashboard-banner-logo-title nil
        dashboard-startup-banner (expand-file-name "GnuLove.png" user-emacs-directory)
        dashboard-items '((recents  . 5)
                          (projects . 5))
        initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
  (dashboard-setup-startup-hook))

;; Relative line numbers in code
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; Built-in quality of life
(recentf-mode 1)
(setq recentf-max-saved-items 100)
(save-place-mode 1)
(savehist-mode 1)
(global-auto-revert-mode 1)
(electric-pair-mode 1)
(show-paren-mode 1)
(global-hl-line-mode 1)
(pixel-scroll-precision-mode 1)
(winner-mode 1)

;; Short answers, no dialogs
(setq use-short-answers t)
(setq vc-follow-symlinks t)

;; UTF-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; macOS
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'super
        mac-command-modifier 'meta
        ns-use-proxy-icon nil
        ns-pop-up-frames nil))

;; ──────────────────────────────────────────────────────────────
;; Fonts
;; ──────────────────────────────────────────────────────────────

(set-face-attribute 'default nil
                    :family "JetBrainsMono Nerd Font Mono"
                    :height 150)

;; ──────────────────────────────────────────────────────────────
;; Theme (auto sunrise/sunset switching)
;; ──────────────────────────────────────────────────────────────

(setq calendar-latitude 39.9
      calendar-longitude 32.9)

(use-package circadian
  :config
  (setq circadian-themes '((:sunrise . modus-operandi)
                           (:sunset  . modus-vivendi)))
  (circadian-setup))

;; ──────────────────────────────────────────────────────────────
;; Modeline & Icons
;; ──────────────────────────────────────────────────────────────

(use-package nerd-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25
        doom-modeline-bar-width 4
        doom-modeline-project-name t
        doom-modeline-buffer-encoding nil))

;; ──────────────────────────────────────────────────────────────
;; Evil
;; ──────────────────────────────────────────────────────────────

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump t
        evil-want-fine-undo t
        evil-undo-system 'undo-redo
        evil-respect-visual-line-mode t
        evil-split-window-below t
        evil-vsplit-window-right t)
  :config
  (evil-mode 1)
  (setq evil-insert-state-message nil)

  (defun eug/lookup-documentation ()
    "Show documentation for symbol at point.
Tries eglot hover, then eldoc, then falls back to describe-symbol."
    (interactive)
    (cond
     ((and (bound-and-true-p eglot--managed-mode)
           (eglot-hover-info (thing-at-point 'symbol)))
      (eldoc-doc-buffer t))
     ((derived-mode-p 'emacs-lisp-mode)
      (describe-symbol (symbol-at-point))
      (pop-to-buffer "*Help*"))
     ((eldoc-doc-buffer t))
     (t (message "No documentation found for: %s" (thing-at-point 'symbol)))))

  (setq evil-lookup-func #'eug/lookup-documentation)

  (defun eug/find-file-in-repo ()
    "Find file from the git repository root, ignoring extra root markers."
    (interactive)
    (let ((root (locate-dominating-file default-directory ".git")))
      (if root
          (let ((default-directory root))
            (project-find-file))
        (user-error "Not inside a git repository")))))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

;; ──────────────────────────────────────────────────────────────
;; Keybindings
;; ──────────────────────────────────────────────────────────────


;; By settings these we lose some keybinding but we have evil alternatives
;; These makes terminal operations file tree ops very easy
;; M-h: mark-paragraph -> evil vip
;; M-k: kill-sentence  -> evil D
;; M-l: downcase-word  -> evil uw
;; M-hjkl for window navigation (all states)
(define-key evil-normal-state-map (kbd "M-h") #'evil-window-left)
(define-key evil-normal-state-map (kbd "M-j") #'evil-window-down)
(define-key evil-normal-state-map (kbd "M-k") #'evil-window-up)
(define-key evil-normal-state-map (kbd "M-l") #'evil-window-right)
(define-key evil-insert-state-map (kbd "M-h") #'evil-window-left)
(define-key evil-insert-state-map (kbd "M-j") #'evil-window-down)
(define-key evil-insert-state-map (kbd "M-k") #'evil-window-up)
(define-key evil-insert-state-map (kbd "M-l") #'evil-window-right)

;; SPC leader (Doom-style)

(use-package general
  :config
  (general-evil-setup)

  (general-create-definer eug/leader
    :keymaps 'override
    :states '(normal insert visual emacs treemacs)
    :prefix "SPC"
    :global-prefix "M-SPC")

  (general-create-definer eug/local-leader
    :keymaps 'override
    :states '(normal visual)
    :prefix ",")

  (eug/leader
    "SPC" '(execute-extended-command :wk "M-x")
    "u"   '(universal-argument :wk "Universal argument")
    "."   '(eug/vterm-toggle :wk "Terminal")
    ","   '(consult-buffer :wk "Switch buffer")

    ;; Buffer
    "b"  '(:ignore t :wk "Buffer")
    "bb" '(consult-buffer :wk "Switch")
    "bd" '(kill-current-buffer :wk "Kill")
    "bn" '(next-buffer :wk "Next")
    "bp" '(previous-buffer :wk "Prev")
    "br" '(revert-buffer :wk "Revert")
    "bs" '((lambda () (interactive) (switch-to-buffer "*scratch*")) :wk "Scratch")

    ;; File
    "f"  '(:ignore t :wk "File")
    "ff" '(find-file :wk "Find")
    "fr" '(consult-recent-file :wk "Recent")
    "fs" '(save-buffer :wk "Save")
    "fS" '(write-file :wk "Save as")
    "fd" '(dired-jump :wk "Dired here")

    ;; Git
    "g"  '(:ignore t :wk "Git")
    "gg" '(magit-status :wk "Status")
    "gb" '(magit-blame :wk "Blame")
    "gl" '(magit-log-current :wk "Log")
    "gd" '(diff-hl-show-hunk :wk "Diff hunk")
    "gn" '(diff-hl-next-hunk :wk "Next hunk")
    "gp" '(diff-hl-previous-hunk :wk "Prev hunk")

    ;; Help
    "h"  '(:ignore t :wk "Help")
    "hf" '(describe-function :wk "Function")
    "hv" '(describe-variable :wk "Variable")
    "hk" '(describe-key :wk "Key")
    "hm" '(describe-mode :wk "Mode")
    "hi" '(info :wk "Info")

    ;; Open
    "o"  '(:ignore t :wk "Open")
    "of" '(eug/treemacs-open :wk "File explorer")
    "od" '(dired-jump :wk "Dired")

    ;; Project
    "p"  '(:ignore t :wk "Project")
    "pp" '(project-switch-project :wk "Switch")
    "pf" '(project-find-file :wk "Find file")
    "pb" '(consult-project-buffer :wk "Buffer")
    "pd" '(project-dired :wk "Dired")
    "pk" '(project-kill-buffers :wk "Kill buffers")
    "pc" '(project-compile :wk "Compile")
    "ps" '(project-shell-command :wk "Shell cmd")
    "pt" '(project-vterm :wk "Terminal")
    "pF" '(eug/find-file-in-repo :wk "Find file (repo root)")

    ;; Search
    "s"  '(:ignore t :wk "Search")
    "ss" '(consult-line :wk "Buffer")
    "sp" '(consult-ripgrep :wk "Ripgrep")
    "si" '(consult-imenu :wk "Imenu")
    "sf" '(consult-find :wk "Find file")

    ;; Code (LSP)
    "c"  '(:ignore t :wk "Code")
    "ca" '(eglot-code-actions :wk "Actions")
    "cr" '(eglot-rename :wk "Rename")
    "cf" '(eglot-format :wk "Format")
    "cd" '(flymake-show-buffer-diagnostics :wk "Diagnostics")

    ;; Toggle
    "t"  '(:ignore t :wk "Toggle")
    "tT" '(consult-theme :wk "Theme")
    "tt" '(eug/vterm-toggle-side :wk "Terminal side")
    "tl" '(display-line-numbers-mode :wk "Line numbers")
    "tz" '(writeroom-mode :wk "Zen")

    ;; Window
    "w"  '(:ignore t :wk "Window")
    "wv" '(evil-window-vsplit :wk "V-split")
    "ws" '(evil-window-split :wk "H-split")
    "wd" '(evil-window-delete :wk "Delete")
    "ww" '(evil-window-next :wk "Next")
    "wh" '(evil-window-left :wk "Left")
    "wj" '(evil-window-down :wk "Down")
    "wk" '(evil-window-up :wk "Up")
    "wl" '(evil-window-right :wk "Right")
    "w=" '(balance-windows :wk "Balance")

    ;; Quit
    "q"  '(:ignore t :wk "Quit")
    "qq" '(delete-frame :wk "Close frame")
    "qQ" '(save-buffers-kill-emacs :wk "Kill Emacs")))

(use-package which-key
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3
        which-key-popup-type 'side-window
        which-key-side-window-location 'bottom
        which-key-side-window-max-height 0.33
        which-key-min-display-lines 6
        which-key-sort-order 'which-key-key-order-alpha))

;; ──────────────────────────────────────────────────────────────
;; Completion: Vertico + Orderless + Consult + Marginalia
;; ──────────────────────────────────────────────────────────────

(use-package vertico
  :init (vertico-mode)
  :config
  (setq vertico-cycle t
        vertico-count 15))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :config
  (setq consult-narrow-key "<"
        consult-preview-key "M-."
        consult-preview-throttle 0)
  ;; Disable heavy hooks during preview to avoid lag
  (setq consult-preview-allowed-hooks nil))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)))


;; In-buffer completion
(use-package corfu
  :init (global-corfu-mode)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-preselect 'first)
  :bind (:map corfu-map
              ("TAB" . corfu-insert)
              ([tab] . corfu-insert)
              ("RET" . corfu-insert)
              ([return] . corfu-insert)))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

;; ──────────────────────────────────────────────────────────────
;; File Explorer: Treemacs
;; ──────────────────────────────────────────────────────────────

(defun eug/treemacs-open ()
  "Toggle treemacs. When opening fresh, root at the current project.
If no project is known, prompt to add one via `project-remember-project'."
  (interactive)
  (if (treemacs-get-local-window)
      (treemacs)
    (let ((proj (project-current nil)))
      (unless proj
        (let* ((root (read-directory-name "Add project root: "))
               (new-proj (cons 'transient root)))
          (project-remember-project new-proj)
          (setq proj new-proj)))
      (treemacs--init (project-root proj)))))

(defun eug/treemacs-sync-on-buffer-switch ()
  "Refresh treemacs to follow the current buffer's project."
  (when (and (treemacs-get-local-window)
             (buffer-file-name))
    (treemacs--follow)))

(use-package treemacs
  :config
  (setq treemacs-width 30
        treemacs-is-never-other-window nil
        treemacs-show-hidden-files t)
  (treemacs-follow-mode t)
  (treemacs-project-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (add-hook 'window-selection-change-functions
            (lambda (_frame) (eug/treemacs-sync-on-buffer-switch))))

(use-package treemacs-evil
  :after (treemacs evil)
  :config
  (define-key evil-treemacs-state-map (kbd "SPC") nil)
  (define-key evil-treemacs-state-map (kbd "M-h") #'evil-window-left)
  (define-key evil-treemacs-state-map (kbd "M-j") #'evil-window-down)
  (define-key evil-treemacs-state-map (kbd "M-k") #'evil-window-up)
  (define-key evil-treemacs-state-map (kbd "M-l") #'evil-window-right))

(use-package treemacs-magit
  :after (treemacs magit))

(use-package treemacs-nerd-icons
  :after (treemacs nerd-icons)
  :config
  (treemacs-load-theme "nerd-icons"))

;; ──────────────────────────────────────────────────────────────
;; Tree-sitter (built-in to Emacs 30)
;; ──────────────────────────────────────────────────────────────

;; treesit-auto handles grammar installation and mode remapping
;; NOTE: First run will compile grammars (needs a C compiler).
;; If CrowdStrike kills this, install grammars manually or on
;; a personal machine and copy ~/.emacs.d/tree-sitter/ over.
(use-package treesit-auto
  :config
  (setq treesit-auto-install 'prompt)
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; ──────────────────────────────────────────────────────────────
;; LSP: Eglot (built-in to Emacs 30)
;; ──────────────────────────────────────────────────────────────


;; in .zshrc
;; export PATH="$HOME/go/bin:$PATH"
;; go install golang.org/x/tools/gopls@latest
(use-package eglot
  :ensure nil
  :hook
  ((go-ts-mode     . eglot-ensure)
   (c-ts-mode      . eglot-ensure)
   (python-ts-mode . eglot-ensure)
   (bash-ts-mode   . eglot-ensure)
   (terraform-mode . eglot-ensure))
  :config
  (setq eglot-autoshutdown t
        eglot-events-buffer-size 0)
  (add-to-list 'eglot-server-programs
               '(terraform-mode . ("terraform-ls" "serve"))))

;; ──────────────────────────────────────────────────────────────
;; Format on Save
;; ──────────────────────────────────────────────────────────────

;; Apheleia: async formatting, doesn't block the UI
(use-package apheleia
  :config
  (apheleia-global-mode +1)
  ;; Go: goimports instead of gofmt
  (setf (alist-get 'goimports apheleia-formatters)
        '("goimports"))
  (setf (alist-get 'go-ts-mode apheleia-mode-alist)
        'goimports))

;; ──────────────────────────────────────────────────────────────
;; Git
;; ──────────────────────────────────────────────────────────────

(use-package magit
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-same-window-except-diff-v1))

;; Diff indicators in the fringe (replaces git-gutter)
(use-package diff-hl
  :init (global-diff-hl-mode)
  :hook
  ((magit-pre-refresh  . diff-hl-magit-pre-refresh)
   (magit-post-refresh . diff-hl-magit-post-refresh)))

;; ──────────────────────────────────────────────────────────────
;; Terminal
;; ──────────────────────────────────────────────────────────────

(defun project-vterm ()
  "Open vterm at the project root."
  (interactive)
  (let ((default-directory (project-root (project-current t))))
    (vterm (format "*vterm<%s>*" (project-name (project-current))))))

(defvar eug/vterm-side 'bottom
  "Current side for vterm window: `bottom' or `right'.")

(defun eug/vterm-toggle ()
  "Toggle project-specific vterm: open if not visible, close if visible."
  (interactive)
  (let* ((proj (project-current t))
         (proj-name (project-name proj))
         (buf-name (format "*vterm<%s>*" proj-name))
         (vterm-buf (get-buffer buf-name))
         (vterm-win (when vterm-buf (get-buffer-window vterm-buf))))
    (cond
     ;; Vterm visible: hide it
     (vterm-win
      (delete-window vterm-win))
     ;; Vterm buffer exists but not visible: show and focus it
     (vterm-buf
      (let ((display-buffer-overriding-action
             (if (eq eug/vterm-side 'bottom)
                 '(display-buffer-in-side-window (side . bottom) (slot . 0) (window-height . 0.33))
               '(display-buffer-in-side-window (side . right) (slot . 0) (window-width . 0.4)))))
        (select-window (display-buffer vterm-buf))
        (evil-insert-state)))
     ;; No vterm: create one
     (t (let ((default-directory (project-root proj)))
          (vterm buf-name)
          (evil-insert-state))))))

(defun eug/vterm-toggle-side ()
  "Toggle vterm window between bottom and right side."
  (interactive)
  (let* ((buf-name (format "*vterm<%s>*" (project-name (project-current t))))
         (vterm-buf (get-buffer buf-name))
         (vterm-win (when vterm-buf (get-buffer-window vterm-buf))))
    (when vterm-win
      (setq eug/vterm-side (if (eq eug/vterm-side 'bottom) 'right 'bottom))
      (delete-window vterm-win)
      (let ((display-buffer-overriding-action
             (if (eq eug/vterm-side 'bottom)
                 '(display-buffer-in-side-window (side . bottom) (slot . 0) (window-height . 0.33))
               '(display-buffer-in-side-window (side . right) (slot . 0) (window-width . 0.4)))))
        (display-buffer vterm-buf)))))

(use-package vterm
  :hook
  (vterm-mode . (lambda () (setq-local global-hl-line-mode nil)))
  :config
  (setq vterm-max-scrollback 10000
        vterm-timer-delay 0.01)
  (setq vterm-environment
        (list (if (eq (frame-parameter nil 'background-mode) 'light)
                  "COLORFGBG=0;15"
                "COLORFGBG=15;0"))))

;; ──────────────────────────────────────────────────────────────
;; Extra Language Modes
;; ──────────────────────────────────────────────────────────────

(use-package terraform-mode)
(use-package yaml-mode)
(use-package markdown-mode)
(use-package json-mode)
(use-package dockerfile-mode)
(use-package go-mode)  ; fallback if treesit grammars aren't available

;; Go indentation: use tabs, prevent extra indent on o/O
(add-hook 'go-ts-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode t)
            (setq-local tab-width 4)
            (setq-local go-ts-mode-indent-offset 4)))

;; ──────────────────────────────────────────────────────────────
;; Org Mode (minimal start -- expand later)
;; ──────────────────────────────────────────────────────────────

(use-package org
  :ensure nil
  :config
  (setq org-directory "~/Desktop/org"
        org-log-done 'time
        org-pretty-entities t
        org-hide-emphasis-markers t
        org-image-actual-width 500
        org-use-sub-superscripts nil
        org-startup-indented t
        org-return-follows-link t)

  ;; Agenda
  (setq org-agenda-files
        (directory-files-recursively "~/Desktop/org/" "\\.org$"))
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t)

  ;; Capture
  (setq org-capture-templates
        '(("j" "Journal" entry
           (file+datetree "~/Desktop/org")
           "* %U %?" :clock-in t :clock-keep t)))

  ;; Clock
  (setq org-clock-persist t
        org-clock-persist-query-resume nil)
  (org-clock-persistence-insinuate))

;; ──────────────────────────────────────────────────────────────
;; Snippets
;; ──────────────────────────────────────────────────────────────

(use-package yasnippet
  :config
  (setq yas-triggers-in-field t)
  (yas-global-mode 1))

(use-package yasnippet-snippets)

;; ──────────────────────────────────────────────────────────────
;; Popups (Doom-style bottom windows)
;; ──────────────────────────────────────────────────────────────

(setq display-buffer-alist
      '(("\\*Help\\*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom) (slot . 0) (window-height . 0.33))
        ("\\*Warnings\\*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom) (slot . 1) (window-height . 0.25))
        ("\\*Completions\\*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom) (slot . 0) (window-height . 0.3))
        ("\\*Flymake"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom) (slot . 0) (window-height . 0.25))
        ("\\*eldoc\\*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom) (slot . 0) (window-height . 0.25))
        ("\\*compilation\\*"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom) (slot . 0) (window-height . 0.3))
        ("\\*vterm"
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom) (slot . 0) (window-height . 0.33))))

;; ──────────────────────────────────────────────────────────────
;; Quality of Life
;; ──────────────────────────────────────────────────────────────

;; Zen mode
(use-package writeroom-mode
  :config
  (setq writeroom-width 100))

;; Flycheck-style diagnostics (flymake is built-in)
(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode))

;; Highlight TODO/FIXME/NOTE in code
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode))

;; Rainbow delimiters for lisp editing
(use-package rainbow-delimiters
  :hook (emacs-lisp-mode . rainbow-delimiters-mode))

;; Pulse current line after big jumps
(use-package pulsar
  :config
  (setq pulsar-pulse t
        pulsar-delay 0.05
        pulsar-iterations 10)
  (pulsar-global-mode 1))

;; Outline folding in code buffers (Evil za/zc/zo/zM/zR)
(add-hook 'prog-mode-hook #'outline-minor-mode)
(add-hook 'prog-mode-hook #'hs-minor-mode)

;; Don't clutter minibuffer with eldoc in prog modes
(setq eldoc-echo-area-use-multiline-p nil)

(provide 'init)

;; LLM

;;  npm install -g @zed-industries/claude-agent-acp
(use-package agent-shell
  :ensure t
  :custom
  (agent-shell-show-welcome-message nil)
  (agent-shell-highlight-blocks t)
  (agent-shell-preferred-agent-config (agent-shell-anthropic-make-claude-code-config)))


(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))
;;; init.el ends here
