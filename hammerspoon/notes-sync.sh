#!/bin/bash
set -e
cd '/Users/umut/Desktop/Obsidian Vault'

# a half-done rebase/merge needs a human, committing now would bake in conflict markers
if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ] || [ -f .git/MERGE_HEAD ]; then
	echo "rebase/merge in progress, resolve it by hand" >&2
	exit 1
fi

git add -A
if ! git diff --cached --quiet; then
	# subject: "machine: note-a, note-b +3", notes first, most added lines first; body: every file
	git() { command git -c core.quotepath=false "$@"; } # keep non-ascii names readable
	files=$(git diff --cached --numstat --no-renames | sort -rn | cut -f3) # numstat: added, deleted, path
	names=$( (grep '\.md$' <<<"$files"; grep -v '\.md$' <<<"$files") | sed 's|.*/||; s|\.md$||')
	count=$(($(wc -l <<<"$names")))
	subject="$(git config notes.machine || hostname -s): $(head -2 <<<"$names" | paste -sd, - | sed 's/,/, /')"
	if [ "$count" -gt 2 ]; then subject+=" +$((count - 2))"; fi
	git commit -q -m "$subject" -m "$(git diff --cached --name-only)"
fi
git fetch -q origin || exit 75 # offline: caller retries, the commit stays local
git rebase -q origin/main
git push -q origin main
