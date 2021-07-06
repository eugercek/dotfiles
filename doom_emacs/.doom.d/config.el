(use-package! go-translate
  :config
  (setq go-translate-token-current (cons 430675 2721866130)
        go-translate-local-language "tr"
        go-translate-target-language "en")
  (map!
      :leader "d a" 'go-translate
      :leader "d j" 'go-translate-popup-current))
