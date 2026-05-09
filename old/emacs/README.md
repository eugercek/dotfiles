Packages

```bash
# vterm needs these at compile time
brew install cmake libvterm

# tree-sitter for built-in treesit
brew install tree-sitter

# ripgrep for consult-ripgrep
brew install ripgrep

# for native-comp
brew install libgccjit
```

Install emacs

```bash
sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install
# click ok on popup

brew update
brew tap d12frosted/emacs-plus
brew install emacs-plus@30 --with-xwidgets --with-imagemagick
```

Manual:
brew install emacs-plus@30 --with-xwidgets --with-imagemagick