#!/bin/bash

# NOTE: Put me in .config/karabiner/add_word.sh then chmod +x add_word.sh

set -eu

# NOTE: Also change me
WORD_FILE="/Users/umut/Desktop/Obsidian Vault/words.md"

sleep 0.1

word="$(pbpaste | tr -d '\r\n' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
ts="$(date +%Y-%m-%d)"
app="$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null || echo '?')"


if ! grep -iqF "$word" "$WORD_FILE" ; then
	echo "$ts    $word    [$app]" >> "$WORD_FILE"
fi
