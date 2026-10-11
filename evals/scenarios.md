# Doc-writing evals

These scenarios test whether the skill produces docs a reader can *use*, not
just docs that are accurate. Each one hands an agent a real repo with one doc
removed and a realistic request. A blind judge then plays the reader the doc
was for, using only the docs, and compares two versions.

## Running one

1. `bash evals/setup-fixtures.sh <dest>` builds the fixtures.
2. For each arm (for example, the skill before and after a change) and each
   rep, `cp -R` the fixture and dispatch a fresh agent with the agent prompt
   below, pointing at that arm's copy of `skills/maintaining-documentation`.
3. Copy only the reader-facing docs each run wrote into `judge/<pair>/A` and
   `judge/<pair>/B`, with a random A/B order you record elsewhere. Strip the
   `doc-audit:last-reviewed` stamp. Leave out `docs/INDEX.md`, scratch
   directories, and anything that names the arm.
4. Dispatch one judge per pair with the judge prompt and that scenario's
   persona. Unblind afterwards.

## Agent prompt

```
You are a coding agent working in the repository at <run-dir>. You have a
skill installed called maintaining-documentation; its SKILL.md is at
<skill-dir>/SKILL.md (its supporting files are alongside it). Read it and use
it the way you would any installed skill that matches your task.

You are running unattended: the human is unavailable. Wherever you would ask
them something, make the most reasonable call yourself and list the question
in your final message. Only create or modify files inside <run-dir>.

The user's request:
"<request>"

When done, reply with only: the paths of files you created or changed, and
any questions you'd have asked the human (one line each).
```

## Scenarios

| ID | Fixture | Request | Judge persona and job |
| --- | --- | --- | --- |
| s1 | `s1-automatic-sshfs` | "This repo doesn't have a README. Can you write one?" | A backend developer on a Mac who SSHes into two Linux dev boxes (`devbox`, `gpu1`) and edits with vim but would rather use VS Code locally. Decide whether it's worth trying, install it, then: after `ssh devbox` and a minute's wait, `~/sshfs/devbox` doesn't exist. Figure out what to check and do. |
| s2 | `s2-homedir-manager` | "My teammate is going to start using this to manage their own dotfiles. Write them the docs they need." | A developer told to use homedir-manager, who copies `~/.zshrc`, `~/.gitconfig`, and `~/.config/nvim/` between a work MacBook and a home Mac by hand. Get those managed on the work laptop, set up the home Mac, and know what protects them from pushing an API token that's in `.zshrc`. |
| s3 | `s3-clipfan` | "People keep pinging me because pasting images into Claude Code over SSH isn't working for them with clipfan. Write a troubleshooting doc for it." | A developer running Claude Code on a Linux dev box over SSH from iTerm; clipfan is installed on both ends. Screenshot copied, Ctrl-V in Claude Code, nothing attached. Find out why and fix it. |
| s4 | `s4-clipfan` | "We've got a new engineer starting on clipfan Monday. Their first job is fixing bugs in the sync code. Write them an architecture doc at docs/ARCHITECTURE.md." | A new engineer on clipfan. First bug: a clip copied on the Mac sometimes never reaches a Linux peer after the network drops and reconnects. Using only the doc, work out which components and code are involved, where to start reading, and what invariants a fix must not break. (Here internals *are* what the reader needs; this scenario catches over-correction.) |

s3 and s4 judge only the troubleshooting or architecture doc, not README edits.

## Judge prompt

`{DIR}` is the pair's judge directory; `{PERSONA}` is the scenario's persona
and job from the table.

```
You are judging two versions of the documentation for a software project, A and B. You will role-play a real reader with a real job, using ONLY the files under {DIR}/A and {DIR}/B. Do not open any other file, do not look at source code, and do not search the web. The docs are all you get, exactly like a real reader landing on them.

Your persona and job:
{PERSONA}

Do this once with version A and once with version B, starting fresh each time:
1. Work through your job using only that version. Narrate briefly what you'd do.
2. List every place you got stuck, had to guess, or would have gone to the source code or a colleague.
3. List the passages you skipped or skimmed as irrelevant to your job, and estimate what fraction of the text that was.
4. List the questions your situation raised that the version never answered.
5. Note any passages written for someone else (e.g. contributors or the tool's author) rather than for you: internal function/package names, source-file citations, algorithm walkthroughs, code layout.

Your time matters. A longer doc is fine if you needed what it says; length you had to wade through counts against it.

Then answer: which version would you rather have been handed for this job, A or B? Give the margin (strong / slight / tie) and the two or three reasons that decided it.

Reply in this format and nothing else:
A_STUCK: <count> — <one-line summary>
A_SKIPPED_FRACTION: <percent>
A_FOR_SOMEONE_ELSE: <count> — <examples>
A_UNANSWERED: <one-line summary>
B_STUCK: <count> — <one-line summary>
B_SKIPPED_FRACTION: <percent>
B_FOR_SOMEONE_ELSE: <count> — <examples>
B_UNANSWERED: <one-line summary>
PREFERENCE: <A|B|tie> (<strong|slight>)
REASONS: <2-3 sentences>
```
