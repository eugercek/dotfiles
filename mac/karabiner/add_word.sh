#!/bin/bash

set -eu

WORD_FILE="/Users/umut/Desktop/Obsidian Vault/words.md"

sleep 0.1

word="$(pbpaste | tr -d '\r\n' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | sed 's/ /%20/g')"
ts="$(date +%Y-%m-%d)"


if ! grep -i "$word" "$WORD_FILE" ; then
	echo "$ts    $word" >> "$WORD_FILE"
fi

open "dict://$word"
