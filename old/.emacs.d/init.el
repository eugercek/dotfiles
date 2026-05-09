;;; init.el -*- lexical-binding: t; -*-

;; NOTE There are some manual steps should be done regularly, search MANUAL for these

;; ──────────────────────────────────────────────────────────────
;; Package Management
;; ──────────────────────────────────────────────────────────────

(require 'package)
(setq package-archives
      '(("melpa"  . "https://melpa.org/packages/")
        ("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

( unless package-archive-contents
  (package-refresh-contents))
(require 'use-package)
(setq use-package-always-ensure t)

;; Inherit shell PATH so tools (gopls, goimports, etc.) are found
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; ──────────────────────────────────────────────────────────────
;; Daemon / Frame
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

;; ──────────────────────────────────────────────────────────────
;; Sane Defaults
;; ──────────────────────────────────────────────────────────────

;; (setq debug-on-error t)

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
 scroll-margin 0
 scroll-conservatively 3
 scroll-preserve-screen-position t
 auto-window-vscroll nil
 fast-but-imprecise-scrolling nil

 ring-bell-function 'ignore
 create-lockfiles nil
 make-backup-files nil
 custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

(setq auto-save-visited-interval 1)
(auto-save-visited-mode 1)

;; Backups in one place
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory))))

;; Short answers, no dialogs
(setq use-short-answers t)
(setq vc-follow-symlinks t)

;; UTF-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; Built-in quality of life
(recentf-mode 1)
(setq recentf-max-saved-items 100)
(save-place-mode 1)
(savehist-mode 1)
(global-auto-revert-mode 1)
(electric-pair-mode 1)
(show-paren-mode 1)
(winner-mode 1)

(defun eug/toggle-maximize-buffer ()
  "Maximize current buffer; restore previous window layout on second call.
Works for side windows (treemacs, vterm) too."
  (interactive)
  (if (and (= 1 (length (window-list)))
           (assoc ?_ register-alist))
      (jump-to-register ?_)
    (window-configuration-to-register ?_)
    (let ((ignore-window-parameters t))
      (delete-other-windows))))

;; Smooth scrolling (VS Code-like)
(use-package ultra-scroll
  :config
  (setq ultra-scroll-hide-functions
        (list #'global-hl-line-mode))
  (ultra-scroll-mode 1))

;; Enable after ultra-scroll so it knows to hide the global variant
(global-hl-line-mode 1)

;; Don't clutter minibuffer with eldoc in prog modes
(setq eldoc-echo-area-use-multiline-p nil)

;; Relative line numbers in code
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
;; (setq display-line-numbers-type 't)

;; macOS
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'super
        mac-command-modifier 'meta
        ns-pop-up-frames nil) ;; in finder file opening use existing frame)

  ;; Remove title bar etc
  (add-to-list 'default-frame-alist '(undecorated-round . t)))


;; ──────────────────────────────────────────────────────────────
;; Clean UI
;; ──────────────────────────────────────────────────────────────

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

;; Breathing room between lines
(setq-default line-spacing 0.15)

;; Clean window dividers instead of vertical bar characters
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(window-divider-mode 1)

;; ──────────────────────────────────────────────────────────────
;; Fonts
;; ──────────────────────────────────────────────────────────────

(set-face-attribute 'default nil
                    :family "JetBrainsMono Nerd Font Mono"
                    :height 150)
(set-face-attribute 'variable-pitch nil
                    :family "SF Pro Text"
                    :height 150)

;; ──────────────────────────────────────────────────────────────
;; Theme (auto sunrise/sunset switching)
;; ──────────────────────────────────────────────────────────────

(use-package ef-themes)

(setq calendar-latitude 39.9
      calendar-longitude 32.9)

(use-package circadian
  :config
  (setq circadian-themes '((:sunrise . doom-nord) ;; ef-light
                           (:sunset  . doom-nord)))
  (circadian-setup))

;; Window padding + floating modeline for a modern, spacious look
;; TOOD
;; (use-package spacious-padding
;;   :config
;;   (setq spacious-padding-widths
;;         '(:internal-border-width 16
;;                                  :header-line-width 4
;;                                  :mode-line-width 4
;;                                  :tab-width 4
;;                                  :right-divider-width 24
;;                                  :scroll-bar-width 8
;;                                  :fringe-width 12))
;;   (setq spacious-padding-subtle-mode-line
;;         '(:mode-line-active default :mode-line-inactive vertical-border))
;;   (spacious-padding-mode 1))

;; (use-package spacious-padding
;;   :config
;;   (setq spacious-padding-widths
;;         '(:internal-border-width 16
;;                                  :header-line-width 4
;;                                  :mode-line-width 4
;;                                  :tab-width 4
;;                                  :right-divider-width 24
;;                                  :scroll-bar-width 8
;;                                  :fringe-width 12))
;;   (setq spacious-padding-subtle-mode-line
;;         '(:mode-line-active default :mode-line-inactive vertical-border))
;;   (spacious-padding-mode 1))

;; Dim popups/sidebars (treemacs, vterm, help) so real buffers stand out
(use-package solaire-mode
  :config
  (solaire-global-mode 1))

;; ──────────────────────────────────────────────────────────────
;; Modeline & Icons
;; ──────────────────────────────────────────────────────────────

(use-package nerd-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 32
        doom-modeline-bar-width 0
        doom-modeline-project-name t
        doom-modeline-buffer-encoding nil
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-state-icon t
        doom-modeline-buffer-modification-icon t
        doom-modeline-modal-icon nil
        doom-modeline-vcs-max-length 20))

;; ──────────────────────────────────────────────────────────────
;; Dashboard
;; ──────────────────────────────────────────────────────────────

(setq dashboard-footer-messages '(""))

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
;; Jump / Motion
;; ──────────────────────────────────────────────────────────────

(use-package avy
  :config
  (setq avy-timeout-seconds 0.2
        avy-style 'at-full
        avy-all-windows t))

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

(use-package general
  :config
  (general-evil-setup)

  (defun eug/copy-file-path-from-project-root ()
    "Copy the current file's path relative to the project root."
    (interactive)
    (let ((path (file-relative-name buffer-file-name (project-root (project-current)))))
      (kill-new path)
      (message "Copied: %s" path)))

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
    "fp" '(eug/copy-file-path-from-project-root :wk "Copy path")

    ;; Git
    "g"  '(:ignore t :wk "Git")
    "gg" '(magit-status :wk "Status")
    "gb" '(magit-blame :wk "Blame")
    "gl" '(magit-log-current :wk "Log")
    "gd" '(diff-hl-show-hunk :wk "Diff hunk")
    "ge" '(magit-ediff-dwim :wk "Ediff (editable diff)")
    "gn" '(diff-hl-next-hunk :wk "Next hunk")
    "gp" '(diff-hl-previous-hunk :wk "Prev hunk")

    ;; Help
    "h"  '(:ignore t :wk "Help")
    "hf" '(describe-function :wk "Function")
    "hv" '(describe-variable :wk "Variable")
    "hk" '(describe-key :wk "Key")
    "hm" '(describe-mode :wk "Mode")
    "hi" '(info :wk "Info")

    ;; Jump
    "j"  '(:ignore t :wk "Jump")
    "jj" '(avy-goto-char-timer :wk "Char")
    "jw" '(avy-goto-word-1 :wk "Word")
    "jl" '(avy-goto-line :wk "Line")

    ;; Open
    "o"  '(:ignore t :wk "Open")
    "of" '(eug/treemacs-open :wk "File explorer")
    "od" '(dired-jump :wk "Dired")

    ;; Project
    "p"  '(:ignore t :wk "Project")
    "pp" '(tabspaces-open-or-create-project-and-workspace :wk "Switch / open")
    "pf" '(project-find-file :wk "Find file")
    "pb" '(tabspaces-switch-to-buffer :wk "Buffer (this tab)")
    "pd" '(project-dired :wk "Dired")
    "pk" '(project-kill-buffers :wk "Kill buffers")
    "pc" '(project-compile :wk "Compile")
    "ps" '(project-shell-command :wk "Shell cmd")
    "pF" '(eug/find-file-in-repo :wk "Find file (repo root)")

    ;; Workspace / Tab
    "TAB"  '(:ignore t :wk "Workspace")
    "TAB TAB" '(tabspaces-switch-or-create-workspace :wk "Switch / create")
    "TAB n" '(tab-next :wk "Next")
    "TAB p" '(tab-previous :wk "Prev")
    "TAB r" '(tab-rename :wk "Rename")
    "TAB d" '(tabspaces-close-workspace :wk "Close workspace")
    "TAB k" '(tabspaces-kill-buffers-close-workspace :wk "Kill bufs + close")
    "TAB b" '(tabspaces-switch-buffer-and-tab :wk "Buffer (any tab)")
    "TAB x" '(tabspaces-remove-current-buffer :wk "Remove buf from ws")

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
    "cD" '(flymake-show-project-diagnostics :wk "Project diagnostics")
    "cn" '(flymake-goto-next-error :wk "Next diagnostic")
    "cp" '(flymake-goto-prev-error :wk "Prev diagnostic")

    ;; Toggle
    "t"  '(:ignore t :wk "Toggle")
    "tT" '(consult-theme :wk "Theme")
    "tt" '(eug/vterm-toggle-side :wk "Terminal side")
    "tl" '(display-line-numbers-mode :wk "Line numbers")
    "tz" '(writeroom-mode :wk "Zen")

    ;; Window
    "w"  '(:ignore t :wk "Window")
    "wm" '(eug/toggle-maximize-buffer :wk "Maximize buffer")
    "wM" '(toggle-frame-maximized :wk "Maximize frame")
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
    "qQ" '(save-buffers-kill-emacs :wk "Kill Emacs")
    "qr" '(restart-emacs :wk "Restart Emacs")))

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
        consult-preview-throttle 0))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)))

(use-package embark-consult
  :after (embark consult))

(use-package wgrep)

;; In-buffer completion
(use-package corfu
  :init (global-corfu-mode)
  :bind (:map corfu-map
              ("TAB" . corfu-insert)
              ([tab] . corfu-insert)
              ("RET" . corfu-insert)
              ([return] . corfu-insert))
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-preselect 'first)
  ;; Hide corfu popup when frame loses focus (fixes stale empty child-frame)
  ;; TODO Test if this hack is working
  (add-function :after after-focus-change-function
                (lambda ()
                  (unless (frame-focus-state)
                    (dolist (frame (frame-list))
                      (when (frame-parent frame)
                        (make-frame-invisible frame)))
                    (when (fboundp 'corfu-quit) (corfu-quit))))))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

;; ──────────────────────────────────────────────────────────────
;; Workspaces: Tabspaces (tab-bar + per-tab buffer lists)
;; ──────────────────────────────────────────────────────────────

(use-package tabspaces
  :hook (after-init . tabspaces-mode)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab "Default")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*" "*Messages*"))
  (tabspaces-session t)
  (tabspaces-session-auto-restore t)
  (tabspaces-project-switch-commands 'project-find-file)
  :config
  (setq tab-bar-show 1
        tab-bar-new-tab-choice "*scratch*"
        tab-bar-close-button-show nil))

;; ──────────────────────────────────────────────────────────────
;; File Explorer: Treemacs
;; ──────────────────────────────────────────────────────────────

(defun eug/current-project ()
  "Best guess at the current tab's project.
Tries the current buffer first, then any file-backed buffer in this
tabspace. Returns nil if nothing is found."
  (or (project-current nil)
      (seq-some (lambda (b)
                  (when (buffer-file-name b)
                    (with-current-buffer b (project-current nil))))
                (if (fboundp 'tabspaces--buffer-list)
                    (tabspaces--buffer-list)
                  (buffer-list)))))

(defun eug/treemacs-open ()
  "Toggle treemacs. When opening fresh, root at the current tab's project.
If no project is known, prompt to add one via `project-remember-project'."
  (interactive)
  (if (treemacs-get-local-window)
      (treemacs)
    (let ((proj (eug/current-project)))
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
  (treemacs-resize-icons 16)
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

(use-package all-the-icons)

(use-package treemacs-all-the-icons
  :after (treemacs all-the-icons)
  :config
  (treemacs-load-theme "all-the-icons")
  (treemacs-create-icon :icon "○ " :extensions (root-open)
                        :fallback 'same-as-icon)
  (treemacs-create-icon :icon "● " :extensions (root-closed)
                        :fallback 'same-as-icon))

;; ──────────────────────────────────────────────────────────────
;; Tree-sitter
;; ──────────────────────────────────────────────────────────────

;; Grammar sources
;; Previously I've used treesitter, but it caused performance issues
;; Decided to manually manage these
;; MANUAL look at this URL https://github.com/renzmann/treesit-auto/blob/main/treesit-auto.el
(setq treesit-language-source-alist
      '((go         "https://github.com/tree-sitter/tree-sitter-go")
        (gomod      "https://github.com/camdencheek/tree-sitter-go-mod")
        (python     "https://github.com/tree-sitter/tree-sitter-python")
        (c          "https://github.com/tree-sitter/tree-sitter-c")
        (bash       "https://github.com/tree-sitter/tree-sitter-bash")
        (json       "https://github.com/tree-sitter/tree-sitter-json")
        (yaml       "https://github.com/tree-sitter-grammars/tree-sitter-yaml")
        (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
        (toml       "https://github.com/tree-sitter/tree-sitter-toml")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript"
                    nil "typescript/src")
        (tsx        "https://github.com/tree-sitter/tree-sitter-typescript"
                    nil "tsx/src")))

;; Install all grammars that are missing
(dolist (grammar treesit-language-source-alist)
  (unless (treesit-language-available-p (car grammar))
    (treesit-install-language-grammar (car grammar))))

;; Remap old modes to tree-sitter modes
(setq major-mode-remap-alist
      '((go-mode         . go-ts-mode)
        (python-mode     . python-ts-mode)
        (c-mode          . c-ts-mode)
        (bash-mode       . bash-ts-mode)
        (sh-mode         . bash-ts-mode)
        (javascript-mode . js-ts-mode)
        (js-mode         . js-ts-mode)
        (json-mode       . json-ts-mode)
        (yaml-mode       . yaml-ts-mode)
        (dockerfile-mode . dockerfile-ts-mode)
        (conf-toml-mode  . toml-ts-mode)))

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

;; Ediff: side-by-side, no floating control window
(setq ediff-split-window-function #'split-window-horizontally
      ediff-window-setup-function #'ediff-setup-windows-plain)

(use-package magit
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-same-window-except-diff-v1
        magit-diff-refine-hunk 'all))

;; Diff indicators in the fringe (replaces git-gutter)
(use-package diff-hl
  :init (global-diff-hl-mode)
  :hook
  ((magit-pre-refresh  . diff-hl-magit-pre-refresh)
   (magit-post-refresh . diff-hl-magit-post-refresh)
   (org-mode      . (lambda () (diff-hl-mode -1)))
   (markdown-mode . (lambda () (diff-hl-mode -1)))))

;; ──────────────────────────────────────────────────────────────
;; Terminal
;; ──────────────────────────────────────────────────────────────



(defvar-local eug/vterm-label nil
  "Optional label for a vterm buffer; shown in tab-line if set.")



(use-package vterm
  :hook
  ((vterm-mode . (lambda () (setq-local global-hl-line-mode nil)))
   (vterm-mode . eug/vterm-setup-tab-line))
  :config
  ;; Let Emacs handle these instead of sending them to the terminal
  ;; (customize-set-variable triggers vterm's keymap rebuild)
  (customize-set-variable 'vterm-keymap-exceptions
                          (append vterm-keymap-exceptions '("M-[" "M-]")))
  (setq vterm-max-scrollback 10000
        vterm-timer-delay 0.05)
  (setq vterm-environment
        (list (if (eq (frame-parameter nil 'background-mode) 'light)
                  "COLORFGBG=0;15"
                "COLORFGBG=15;0")))
  ;; Cycle project vterms from both normal and insert state
  (evil-define-key '(normal insert) vterm-mode-map
    (kbd "M-[") #'eug/vterm-prev
    (kbd "M-]") #'eug/vterm-next)
  ;; Local leader (,) inside vterm buffers
  (eug/local-leader
    :keymaps 'vterm-mode-map
    "t" '(eug/vterm-new :wk "New terminal")
    "r" '(eug/vterm-rename :wk "Rename terminal")
    "d" '(eug/vterm-kill :wk "Kill terminal")))

;; ──────────────────────────────────────────────────────────────
;; Extra Language Modes
;; ──────────────────────────────────────────────────────────────

(use-package terraform-mode)
(use-package markdown-mode)

;; Go indentation: use tabs, prevent extra indent on o/O
(add-hook 'go-ts-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode t)
            (setq-local tab-width 4)
            (setq-local go-ts-mode-indent-offset 4)))

;; ──────────────────────────────────────────────────────────────
;; Org Mode (minimal start -- expand later)
;; ──────────────────────────────────────────────────────────────

;; (use-package org
;;   :ensure nil
;;   :config
;;   (setq org-directory "~/Desktop/org"
;;         org-log-done 'time
;;         org-pretty-entities t
;;         org-hide-emphasis-markers t
;;         org-image-actual-width 500
;;         org-use-sub-superscripts nil
;;         org-startup-indented t
;;         org-return-follows-link t)

;;   ;; Agenda
;;   (setq org-agenda-files
;;         (directory-files-recursively "~/Desktop/org/" "\\.org$"))
;;   (setq org-agenda-skip-scheduled-if-done t
;;         org-agenda-skip-deadline-if-done t
;;         org-agenda-include-deadlines t)

;;   ;; Capture
;;   (setq org-capture-templates
;;         '(("j" "Journal" entry
;;            (file+datetree "~/Desktop/org")
;;            "* %U %?" :clock-in t :clock-keep t)))

;;   ;; Clock
;;   (setq org-clock-persist t
;;         org-clock-persist-query-resume nil)
;;   (org-clock-persistence-insinuate))

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
  :hook (prog-mode . flymake-mode)
  :config
  (setq flymake-show-diagnostics-at-end-of-line 'nil))

;; Highlight TODO/FIXME/NOTE/MANUAL in code
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (add-to-list 'hl-todo-keyword-faces '("MANUAL" . "#cc9393")))

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

;; ──────────────────────────────────────────────────────────────
;; LLM
;; ──────────────────────────────────────────────────────────────

;;  npm install -g @zed-industries/claude-agent-acp
(use-package agent-shell
  :ensure t
  :custom
  (agent-shell-show-welcome-message nil)
  (agent-shell-highlight-blocks t)
  (agent-shell-preferred-agent-config (agent-shell-anthropic-make-claude-code-config)))

(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; for treemacs users
  ;; (doom-themes-treemacs-theme "doom-colors") ; use "doom-colors" for less minimal icon theme
  :config
  ;; Theme loading handled by circadian

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; treemacs theming handled by treemacs-nerd-icons
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; MAYBE 
;; (use-package ghostel
;;   :vc (:url "https://github.com/dakra/ghostel" :rev :newest))

(provide 'init)
;;; init.el ends here
