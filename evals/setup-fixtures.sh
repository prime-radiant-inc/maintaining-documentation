#!/usr/bin/env bash
# Build the doc-writing eval fixtures: real public repos pinned to a commit,
# with the doc each scenario asks for removed, so the agent must write it.
set -euo pipefail

usage() {
  cat <<'HELP'
Usage: bash evals/setup-fixtures.sh <dest-dir>

Creates one git repo per scenario under <dest-dir> (plus .src-* upstream
clones, which you can ignore):
  s1-automatic-sshfs   README.md removed         (scenario: write a README)
  s2-homedir-manager   README.md removed         (scenario: docs for a new user)
  s3-clipfan           docs/TROUBLESHOOTING.md removed (scenario: troubleshooting)
  s4-clipfan           docs/ARCHITECTURE.md removed    (scenario: architecture doc)

Copy a fixture once per run (cp -R) so runs never share a working tree.
See evals/scenarios.md for the prompts, reader personas, and judge prompt.
Requires git and network access to github.com. <dest-dir> must not exist.
HELP
}

[[ $# -eq 1 && $1 != -h && $1 != --help ]] || { usage; [[ $# -eq 1 ]] && exit 0 || exit 2; }
dest=$1
[[ ! -e $dest ]] || { echo "setup-fixtures: $dest already exists; pick a new directory" >&2; exit 1; }
mkdir -p "$dest"

# Fixtures get a fresh one-commit history: with upstream history, an agent
# can recover the removed doc from git and skip writing it.
fixture() { # name repo sha doc-to-remove
  local dir="$dest/$1" src="$dest/.src-$1"
  git clone -q "https://github.com/$2.git" "$src"
  mkdir "$dir"
  git -C "$src" archive "$3" | tar -x -C "$dir"
  rm "$dir/$4"
  git -C "$dir" init -q
  git -C "$dir" add -A
  git -C "$dir" -c user.email=eval@example.com -c user.name=eval commit -qm "eval fixture: $2@$3 without $4"
  echo "ok $1 ($2@$3, removed $4)"
}

fixture s1-automatic-sshfs prime-radiant-inc/automatic-sshfs c86d706 README.md
fixture s2-homedir-manager obra/homedir-manager 7af1dae README.md
fixture s3-clipfan prime-radiant-inc/clipfan 093f37e docs/TROUBLESHOOTING.md
fixture s4-clipfan prime-radiant-inc/clipfan 093f37e docs/ARCHITECTURE.md
