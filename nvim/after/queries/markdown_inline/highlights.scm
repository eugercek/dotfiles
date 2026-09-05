; extends

; clangd & friends escape every literal * and _ in doc comments, so hover
; windows end up full of \*\*comm\*\*. Hide the backslash, keep the char.
((backslash_escape) @conceal
  (#offset! @conceal 0 0 0 -1)
  (#set! conceal ""))
