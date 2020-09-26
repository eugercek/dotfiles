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

(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))                       ; On laptops it's nice to know how much power you have
  (display-time-mode 1)

(setq user-full-name "Umut Gercek"
      user-mail-address "umutgercek1999@dgmail.com")

(setq doom-theme 'doom-one)

(setq org-directory "~/Dropbox/org")



