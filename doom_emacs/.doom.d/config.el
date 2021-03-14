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
                                        ;(global-subword-mode 1)

(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))(when (file-exists-p custom-file)
                                                                             (load custom-file))

(setq writeroom-fullscreen-effect t)

(toggle-frame-fullscreen)

;; (setq doom-font (font-spec :family "SauceCodePro Nerd Font" :size 17))
(setq doom-font (font-spec :family "SauceCodePro NF" :size 17))
;; (setq doom-font (font-spec :family "JetBrains Mono" :size 15))
;; (setq doom-font (font-spec :family "Hack Nerd Font Mono" :size 15))

(setq user-full-name "Umut Gercek"
      user-mail-address "umutgercek1999@gmail.com")

(setq confirm-kill-emacs nil)
(unless (display-graphic-p)
  (require 'evil-terminal-cursor-changer)
  (evil-terminal-cursor-changer-activate) ; or (etcc-on)
  )

(setq doom-solarized-dark-brighter-text t)
(setq doom-solarized-dark-brighter-comments t)
(setq doom-themes-enable-bold t)

(setq my/current-time (string-to-number (format-time-string "%H")))

(if
    (and
     (< 7 my/current-time)
     (< my/current-time 17 ))
    (setq my/current-theme 'doom-one-light)
  (setq my/current-theme 'doom-solarized-dark))

(setq doom-theme my/current-theme)
(custom-set-faces!
  `(region     :background ,"#094A5A"))

(setq doom-scratch-buffer-major-mode t)

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(remove-hook '+doom-dashboard-functions 'doom-dashboard-widget-footer)
(remove-hook '+doom-dashboard-functions 'doom-dashboard-widget-loaded)

(setq fancy-splash-image "~/.doom.d/GnuLove.png")

(define-key evil-normal-state-map (kbd "C-c =") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt)

(setq +evil-want-o/O-to-continue-comments nil)

(after! evil-snipe
  (setq evil-snipe-scope 'visible)
  (setq evil-snipe-repeat-scope 'buffer)
  (setq evil-snipe-spillover-scope 'whole-buffer))

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

(setq rainbow-delimiters-max-face-count 9)

(setq org-clock-persist t)
(org-clock-persistence-insinuate)
(setq org-clock-persist-query-resume nil)
;; (setq org-hide-emphasis-markers t)

(setq org-directory "~/Dropbox/Org")
(after! org
  (setq org-directory "~/Dropbox/Org"))

;;(setq +org:reading-list-file (+org/expand-org-file-name "gtd/read-list.org"))
;;(setq +org:bookmarks-file (+org/expand-org-file-name "gtd/bookmarks.org"))

(after! org
  (setq org-src-window-setup 'current-window))

(after! org-mode
  (unmap! '(motion) "C-h")
  )

(setq org-directory "~/Dropbox/org")

;; (use-package evil
;;   :custom
;;   evil-disable-insert-state-bindings t
;;   )
(setq org-emphasis-alist
      '(("/" italic)
        ("_" underline)
        ("=" org-verbatim verbatim)
        ("~" org-code verbatim)
        ("+"
         (:strike-through t))))

;;Agenda
(setq org-agenda-files (directory-files-recursively "~/Dropbox/org/gtd/" "\\.org$"))

(use-package! org-super-agenda
  :commands (org-super-agenda-mode))
(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil org-agenda-tags-column 100)
(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :todo "TODAY"
                          :scheduled today
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                           :todo "NEXT"
                           :order 1)
                          (:name "Important"
                           :tag "Important"
                           :priority "A"
                           :order 6)
                          (:name "Due Today"
                           :deadline today
                           :order 2)
                          (:name "Due Soon"
                           :deadline future
                           :order 8)
                          (:name "Overdue"
                           :deadline past
                           :face error
                           :order 7)
                          (:name "Assignments"
                           :tag "Assignment"
                           :order 10)
                          (:name "Issues"
                           :tag "Issue"
                           :order 12)
                          (:name "Emacs"
                           :tag "Emacs"
                           :order 13)
                          (:name "Projects"
                           :tag "Project"
                           :order 14)
                          (:name "Research"
                           :tag "Research"
                           :order 15)
                          (:name "To read"
                           :tag "Read"
                           :order 30)
                          (:name "Waiting"
                           :todo "WAITING"
                           :order 20)
                          (:name "University"
                           :tag "uni"
                           :order 32)
                          (:name "Trivial"
                           :priority<= "E"
                           :tag ("Trivial" "Unimportant")
                           :todo ("SOMEDAY" )
                           :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

(setq org-capture-templates '(
                              ("t" "Todo")
                              ("tn" "No time" entry
                               (file+headline "~/Dropbox/org/gtd/inbox.org" "Tasks")
                               "* TODO %^{Description} %^g\n  %?")
                              ("tt" "With time" entry
                               (file+headline "~/Dropbox/org/gtd/agenda.org" "Tasks")
                               "* TODO %^{Description} %^g\n \%^t\n  %?")


                              ("T" "Tickler" entry
                               (file+headline "~/Dropbox/org/gtd/tickler.org" "Tickler")
                               "* %i%? \n %U")

                              ("n" "Simple Notes" entry
                               (file+headline "~/Dropbox/org/gtd/inbox.org" "Notes")
                               "* %^{Description} %^g\n  %?")

                              ("j" "Journal" entry
                               (file+datetree "~/Dropbox/org/gtd/journal.org")
                               "* %U %?" :clock-in t :clock-keep t)


                              ("l" "Log")

                              ("ls" "Log SICP/LISP daily" entry
                               (file+olp+datetree "~/Dropbox/org/gtd/log.org" "SICP")
                               "* %<%H:%M>\n%^{minute}p%^{page}p%?" :jump-to-captured t :immediate-finish t)

                              ("lu" "Log UNIX daily" entry
                               (file+olp+datetree "~/Dropbox/org/gtd/log.org" "UNIX")
                               "* %<%H:%M>%?\n%^{minute|60}p")

                              ("r" "Resource")

                              ("ri" "Internet" entry
                               (file+olp "~/Dropbox/org/gtd/inbox.org" "Resources" "Internet")
                               "* [[%c][%^{Name of link}]] %^g\n%U\n" :immediate-finish t)))

(defun zz/org-download-paste-clipboard (&optional use-default-filename)
  (interactive "P")
  (require 'org-download)
  (let ((file
         (if (not use-default-filename)
             (read-string (format "Filename [%s]: " org-download-screenshot-basename)
                          nil nil org-download-screenshot-basename)
           nil)))
    (org-download-clipboard file)))

(after! org
  (setq org-download-method 'directory)
  (setq org-download-image-dir "~/Documents/Assets/Download")
  (setq org-download-heading-lvl nil)
  (setq org-download-timestamp "%Y%m%d-%H%M%S_")
  (setq org-image-actual-width 750)
  (map! :map org-mode-map
        "C-c l a y" #'zz/org-download-paste-clipboard
        "C-M-y" #'zz/org-download-paste-clipboard))

;; (setq
;;  ;; org-superstar-headline-bullets-list '("⁖" "*" "†" "✸" "✿")
;;  org-superstar-headline-bullets-list '("*")
;;  )

(map! :leader
      :desc "org-ctrl-c-star copy"
      "8" 'org-ctrl-c-star)

(org-autolist-mode 1)

(setq org-log-done 'time)

(map! :leader
      :desc "Go to notes directory"
      "a n" 'my/notes-counsel-find-file
      )

(defun my/notes-counsel-find-file ()
  "Foobar"
  (interactive)
  (counsel-find-file "/home/umut/Dropbox/org/Notes"))

(defun my/gtd-counsel-find-file ()
  "Foobar"
  (interactive)
  (counsel-find-file "/home/umut/Dropbox/org/gtd"))

(map! :leader
      :desc "Go to notes directory"
      "a g" 'my/gtd-counsel-find-file
      )

(defun my/src-counsel-find-file ()
  "Foobar"
  (interactive)
  (counsel-find-file "/home/umut/src/"))

(map! :leader
      :desc "Go to notes directory"
      "a s" 'my/src-counsel-find-file
      )

(defun my/documents-counsel-find-file ()
  "Foobar"
  (interactive)
  (counsel-find-file "/home/umut/Document/"))

(map! :leader
      :desc "Go to documents directory"
      "a d" 'my/documents-counsel-find-file
      )

(defun my/curly-quoation-to-normal-quoation()
  "Change any curly quotation mark to normal quoation mark"
  (interactive)
  (goto-char (point-min))
  (while (search-forward "‘" nil t)
    (replace-match "'"))
  (goto-char (point-min))
  (while (search-forward "’" nil t)
    (replace-match "'"))

  (goto-char (point-min))
  (while (search-forward "“" nil t)
    (replace-match "\""))

  (goto-char (point-min))
  (while (search-forward "”" nil t)
    (replace-match "\""))
  )

(defun my/error-line ()
  "Create an error message in C++"
  (interactive)
  (move-beginning-of-line nil)
  (insert "std::cout << \"Error:\" << __LINE__ << std::endl;")
  )

(map! :leader
      :desc "Create an error message in C++"
      "d e" 'my/error-line
      )

(defun my/open-folder ()
  "Opens a folder with xdg-open"
  (interactive)
  (shell-command "xdg-open ."))

(defun my/org-table-color-y-n (start end)
  "Make =y= s green and n s red with =y= and ~n~"
  (interactive "r")
  (replace-regexp " y " " =y= " nil start end)
  (replace-regexp " n " " ~n~ " nil start end))

(defun my/just-one-space-in-region (beg end)
  "replace all whitespace in the region with single spaces"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (while (re-search-forward "\\s-+" nil t)
        (replace-match " ")))))

(map! :leader
      :desc "Go to documents directory"
      "j s" 'my/my/just-one-space-in-region)

(defun xah-open-file-at-cursor ()
  "Open the file path under cursor.
If there is text selection, uses the text selection for path.
If the path starts with “http://”, open the URL in browser.
Input path can be {relative, full path, URL}.
Path may have a trailing “:‹n›” that indicates line number. If so, jump to that line number.
If path does not have a file extension, automatically try with “.el” for elisp files.
This command is similar to `find-file-at-point' but without prompting for confirmation.

URL `http://ergoemacs.org/emacs/emacs_open_file_path_fast.html'
Version 2019-01-16"
  (interactive)
  (let* (($inputStr (if (use-region-p)
                        (buffer-substring-no-properties (region-beginning) (region-end))
                      (let ($p0 $p1 $p2
                                ;; chars that are likely to be delimiters of file path or url, e.g. whitespace, comma. The colon is a problem. cuz it's in url, but not in file name. Don't want to use just space as delimiter because path or url are often in brackets or quotes as in markdown or html
                                ($pathStops "^  \t\n\"`'‘’“”|[]{}「」<>〔〕〈〉《》【】〖〗«»‹›❮❯❬❭〘〙·。\\"))
                        (setq $p0 (point))
                        (skip-chars-backward $pathStops)
                        (setq $p1 (point))
                        (goto-char $p0)
                        (skip-chars-forward $pathStops)
                        (setq $p2 (point))
                        (goto-char $p0)
                        (buffer-substring-no-properties $p1 $p2))))
         ($path
          (replace-regexp-in-string
           "^file:///" "/"
           (replace-regexp-in-string
            ":\\'" "" $inputStr))))
    (if (string-match-p "\\`https?://" $path)
        (if (fboundp 'xahsite-url-to-filepath)
            (let (($x (xahsite-url-to-filepath $path)))
              (if (string-match "^http" $x )
                  (browse-url $x)
                (find-file $x)))
          (progn (browse-url $path)))
      (if ; not starting “http://”
          (string-match "^\\`\\(.+?\\):\\([0-9]+\\)\\'" $path)
          (let (
                ($fpath (match-string 1 $path))
                ($line-num (string-to-number (match-string 2 $path))))
            (if (file-exists-p $fpath)
                (progn
                  (find-file $fpath)
                  (goto-char 1)
                  (forward-line (1- $line-num)))
              (when (y-or-n-p (format "file no exist: 「%s」. Create?" $fpath))
                (find-file $fpath))))
        (if (file-exists-p $path)
            (progn ; open f.ts instead of f.js
              (let (($ext (file-name-extension $path))
                    ($fnamecore (file-name-sans-extension $path)))
                (if (and (string-equal $ext "js")
                         (file-exists-p (concat $fnamecore ".ts")))
                    (find-file (concat $fnamecore ".ts"))
                  (find-file $path))))
          (if (file-exists-p (concat $path ".el"))
              (find-file (concat $path ".el"))
            (when (y-or-n-p (format "file no exist: 「%s」. Create?" $path))
              (find-file $path ))))))))

(map! :leader
      :desc "Translate word"
      "d f" 'xah-open-file-at-cursor
      )

(defun xah-title-case-region-or-line (@begin @end)
  "Title case text between nearest brackets, or current line, or text selection.
Capitalize first letter of each word, except words like {to, of, the, a, in, or, and, …}. If a word already contains cap letters such as HTTP, URL, they are left as is.

When called in a elisp program, *begin *end are region boundaries.
URL `http://ergoemacs.org/emacs/elisp_title_case_text.html'
Version 2017-01-11"
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (let (
           $p1
           $p2
           ($skipChars "^\"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕"))
       (progn
         (skip-chars-backward $skipChars (line-beginning-position))
         (setq $p1 (point))
         (skip-chars-forward $skipChars (line-end-position))
         (setq $p2 (point)))
       (list $p1 $p2))))
  (let* (
         ($strPairs [
                     [" A " " a "]
                     [" And " " and "]
                     [" At " " at "]
                     [" As " " as "]
                     [" By " " by "]
                     [" Be " " be "]
                     [" Into " " into "]
                     [" In " " in "]
                     [" Is " " is "]
                     [" It " " it "]
                     [" For " " for "]
                     [" Of " " of "]
                     [" Or " " or "]
                     [" On " " on "]
                     [" Via " " via "]
                     [" The " " the "]
                     [" That " " that "]
                     [" To " " to "]
                     [" Vs " " vs "]
                     [" With " " with "]
                     [" From " " from "]
                     ["'S " "'s "]
                     ["'T " "'t "]
                     ]))
    (save-excursion
      (save-restriction
        (narrow-to-region @begin @end)
        (upcase-initials-region (point-min) (point-max))
        (let ((case-fold-search nil))
          (mapc
           (lambda ($x)
             (goto-char (point-min))
             (while
                 (search-forward (aref $x 0) nil t)
               (replace-match (aref $x 1) "FIXEDCASE" "LITERAL")))
           $strPairs))))))

(map! :leader
      "j t"  'xah-title-case-region-or-line
      )

(setq org-babel-default-header-args:C++ '((:includes . "<bits/stdc++.h>")
                                          (:flags . "-std=c++20")
                                          (:namespaces . "std")))

(setq org-babel-default-header-args:C '((:includes . "'(<stdio.h> <stdlib.h> <unistd.h> <time.h> <string.h>)")
                                        (:flags . "-std=c99")))

(map! :leader
      "j r" 'python-shell-send-region
      "j b" 'python-shell-send-buffer
      "j d" 'python-shell-send-defun)

(after! company
  (setq company-idle-delay 0.35)
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around t);;Circular list
  (setq company-show-numbers t));; M-7 for 7nd match

(after! company
  (define-key company-active-map (kbd "<tab>")
    #'company-complete-selection)
  (define-key company-active-map (kbd "TAB")
    #'company-complete-selection))

(after! company
  (setq company-tooltip-limit 10
        company-tooltip-minimum-width 80))

(setq doom-themes-treemacs-theme "doom-colors")
(doom-themes-treemacs-config)

(use-package command-log-mode)

(eval-after-load "artist"
  '(define-key artist-mode-map [(down-mouse-3)] 'artist-mouse-choose-operation)
  )

(add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode) ;Dark mode

(setq +latex-viewers '(pdf-tools))

(push '("\\.pdf\\'" . emacs) org-file-apps)

(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-save-place-file (concat doom-cache-dir "nov-places")))

(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)
(add-hook 'Info-mode-hook #'mixed-pitch-mode)

(setq lsp-enable-symbol-highlighting nil)

(setq  writeroom-width 80)

(setq delimit-columns-str-before "{ ")
(setq delimit-columns-str-after " }")
(setq delimit-columns-str-separator ", ")
(setq delimit-columns-before "")
(setq delimit-columns-after "")
(setq delimit-columns-separator " ")
(setq delimit-columns-format 'separator)
(setq delimit-columns-extra t)

(map! :leader
      "j [" 'delimit-columns-region)

(use-package zeal-at-point)
(map! :leader
      :desc "Zeal Look Up"
      "d z" #'zeal-at-point
      )

(use-package! framemove
  :config
  (setq framemove-hook-into-windmove t))

(use-package turkish)
(map! :leader
      :desc "Turkish last word"
      "d t" 'turkish-correct-last-word
      )

(add-hook! 'rainbow-mode-hook
  (hl-line-mode (if rainbow-mode -1 +1)))
