;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! turkish)
(package! zeal-at-point)
(package! peep-dired)
(package! go-translate
  :recipe (:host github
           :repo "lorniu/go-translate")
  :pin "ea63d0ad9816aa1c478c66bd1ff9978e8330d3cb")

(package! org-super-agenda)
;; (package! evil-terminal-cursor-changer)
(package! doct)
(package! command-log-mode)
(package! org-download)
(package! framemove
        :recipe (:host github :repo "emacsmirror/framemove"))
(package! nov)
(package! sicp)
(package! define-word)
(package! info-colors)

;https://github.com/tecosaur/emacs-config/blob/master/config.org#visuals
(package! lsp-treemacs)

(package! org-autolist)
(package! evil-visual-mark-mode)

(package! pair-tree)

(package! org-appear :recipe (:host github :repo "awth13/org-appear")
  :pin "0b3b029d5851c77ee792727b280f062eaf2c22c7")

(package! nmap
   :recipe (:host github
           :repo "eugercek/nmap.el"))

(package! rotate)

(package! org-pandoc-import
  :recipe (:host github
           :repo "tecosaur/org-pandoc-import"
           :files ("*.el" "filters" "preprocessors")))

(package! tldr)
(package! org-fragtog)
(package! language-detection)
(package! keyfreq)
(package! bnf-mode)
(package! elfeed-goodies)
(package! dired-hide-dotfiles)
(package! string-inflection)
(package! info-noter
  :recipe (:host github
           :repo "eugercek/info-noter.el"))

(package! try)
(package! org-pomodoro
  :recipe (:host github
           :repo "eugercek/org-pomodoro"))


(package! circadian
  :recipe (:host github
           :repo "guidoschmidt/circadian.el"))
