(map! :leader
      "a n" '(lambda () (interactive) (counsel-find-file "/home/umut/Dropbox/org/Notes"))
      "a g" '(lambda () (interactive) (counsel-find-file "/home/umut/Dropbox/org/gtd"))
      "a s" '(lambda () (interactive) (counsel-find-file "/home/umut/src")))
