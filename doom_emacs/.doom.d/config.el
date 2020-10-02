(map! :leader
      :desc "My previous buffer"
      "d h" 'switch-to-next-buffer
      :desc "My next buffer"
      "d l" 'switch-to-prev-buffer
      )
(setq-default
 delete-by-moving-to-trash t
  tab-width 4
   uniquify-buffer-name-style 'forward
    window-combination-resize t
	 x-stretch-cursor t)

(setq undo-limit 80000000
      evil-want-fine-undo t
	        auto-save-default t
			      inhibit-compacting-font-caches t
				        truncate-string-ellipsis "…"
						      display-line-numbers-type 'relative)
(global-subword-mode 1)
(if (eq initial-window-system 'x)
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))
(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))
(setq projectile-project-search-path '("~/src/"))
(setq user-full-name "Umut Gercek"
      user-mail-address "umutgercek1999@gmail.com")
(setq doom-theme 'doom-solarized-light)
;(setq doom-solarized-dark-brighter-text t)
(setq doom-scratch-buffer-major-mode t)
(setq doom-font (font-spec :family "Fira Code" :size 16 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 15))
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(remove-hook '+doom-dashboard-functions 'doom-dashboard-widget-footer)
(remove-hook '+doom-dashboard-functions 'doom-dashboard-widget-loaded)
(setq fancy-splash-image "~/.doom.d/GnuLove.png")
(setq org-directory "~/Dropbox/org")
(after! org-mode
  (unmap! '(motion) "C-h")
  )
;; (use-package evil
;;   :custom
;;   evil-disable-insert-state-bindings t
;;   )
(setq +evil-want-o/O-to-continue-comments nil)
(after! evil-snipe
  (setq dene "foo")
  (setq evil-snipe-scope 'visible)
  (setq evil-snipe-repeat-scope 'buffer)
  (setq evil-snipe-spillover-scope 'whole-buffer))
(after! company
  (setq company-idle-delay 0.35)
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around t)
  (setq company-show-numbers t)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  )
;(after! company-box
;     (setq company-box-backends-colors
;           '((company-yasnippet . (:all "lime green" :selected (:background "lime green" :foreground "black"))))
;           ))
(use-package zeal-at-point)
(map! :leader
      :desc "Zeal Look Up"
      "d z" #'zeal-at-point
      )
(map!
  (:after dired
    (:map dired-mode-map
      :n "RET" 'dired-find-alternate-file ;;Open in same bufer
          "-"   'find-alternate-file)
          "C-x i" #'peep-dired
     ))
(evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file
                                             (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)
(setq writeroom-fullscreen-effect t)
;(add-hook! yas-minor-mode
;  (define-key yas-minor-mode-map (kbd "SPC") yas-maybe-expand))
(use-package turkish)
(use-package rainbow-mode)
(setq doom-font (font-spec :family "SauceCodePro Nerd Font" :size 17)
      doom-variable-pitch-font (font-spec :family "SauceCodePro Nerd Font" :size 15)
      doom-big-font (font-spec :family "SauceCodePro Nerd Font" :size 24)
)

(setq confirm-kill-emacs nil)
