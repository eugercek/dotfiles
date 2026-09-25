# Learn Sep 25

## markdown

- `]]` / `[[` jump between headings, `gO` opens the outline (builtin ftplugin)
- `,=` / `,>` / `,<` insert a heading at the same level / one deeper / one up (min `##`)

## writing (markdown, text, gitcommit)

- `,b` / `,i` bold / italic, `` ,` `` backticks: word, or selection in visual
- `,u` uppercase word
- `foo-bar` counts as one word, `.` repeats with the dash

## mini-surround

Grammar is like `diw`: `s` + action + what + with what. In visual, skip "what".

- `saiw)` add: `foo` -> `(foo)`, `saiw(` -> `( foo )` (opening bracket adds spaces)
- `sd"` delete: `"foo"` -> `foo`
- `sr"'` replace: `"foo"` -> `'foo'`
- `sf"` / `sF"` jump to next / previous surrounding, `sh"` highlight it
- cursor not inside? add `n` / `l` for next / last: `sdn"`
- special chars: `f` function call (`saiwf` -> `print(foo)`), `t` tag, `q` any quote, `b` any bracket (`(` `[` `{`)
- `8` is `**`, `sd8` unbolds, `sr*8` italic -> bold
- `.` repeats: `saiw"` once, then `.` on other words
- faster than `saiw`: `sae"` from word start, or `viw` + `sa"` (see before wrapping)
- builtin `s` is gone, use `cl` (and `S` is still `cc`)

## git

- `<leader>gc` commit in this nvim (mini.git, `git commit --verbose`): `:wq` commits, `:q!` aborts. Nothing staged -> git refuses

## diffview

- `<Tab>` / `<S-Tab>` next / previous file, `[F` / `]F` first / last file (works from diff too, not just the panel)

Review progress in the file panel (big PRs):

- `w` mark file as reviewed (also on a visual selection), `C` clear all marks
- `H` hide / show reviewed files
- marks survive nvim restarts (`persist_selections`), so a big PR can be reviewed over days
- `<leader>gm` branch vs `origin/master`: right side is the real file (`--imply-local`), so LSP / `gd` work and `:w` saves fixes
- `<leader>gD` like `<leader>gd` but hides untracked files
- `<leader>r` rotate layout, `<leader>b` toggle file panel, `<leader>p` move file panel left / bottom

## tabs

A tab is a window layout, not a file. Diffview opens in its own tab (`q` closes it, cleans its buffers too).

- `gt` / `gT` next / previous tab, `{N}gt` go to tab N (`1gt`, `2gt`)
- `g<Tab>` toggle to last used tab
- `:tabs` list tabs and their windows
- `:tabnew` / `:tabnew file` open new tab
- `<C-w>T` move current window to a new tab
- `:tabclose` (`:tabc`) close current tab, `:tabonly` (`:tabo`) close all others
