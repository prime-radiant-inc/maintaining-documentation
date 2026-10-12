# Writing a doc for its reader

Law lives in the hub. This flow governs the *content* of a doc: use it
whenever you write a new doc or substantially rewrite one. The accuracy rules
still apply; this file is about making an accurate doc useful.

The failure this prevents: the agent's source material is the code, so the
doc inherits the code's structure (one section per module), its vocabulary
(function names), and its idea of completeness (every flag, every step of the
algorithm). A doc like that is true and nobody can use it. Readers arrive
with a situation and a question. The doc is organized around those; the code
is how you check your answers.

## 1. Write the reader brief first

Before drafting, write this brief (in your working notes or the review
message; it does not go in the doc). Every slot is required.

```
Reader:    who, what they already know, what they already have set up
Arrives:   what just happened that made them open this doc; what they'd search for
Job:       what they must be able to do or decide when they finish
Questions: 3–7 questions they bring, in their words, in the order they'd ask
Not for:   who this doc is not for, and what they don't need from it
```

Fill it from evidence about readers: the user's request, issue and support
threads, the README's promises, CLI `--help`, error messages, UI labels.
Not from the package list. If the request names a reader ("my teammate",
"people keep pinging me about X"), that reader and their situation anchor the
brief. If you can't fill **Arrives** and **Job**, ask the human; you don't
know enough to write the doc yet.

## 2. Pick the doc type from the Job

One doc serves one reader doing one kind of job. The type sets the shape.

| Reader's job | Doc type | Shape |
| --- | --- | --- |
| Decide whether this is for them, then get started | README / overview | The problem it solves and for whom, what using it looks like, quickstart to a first success, where to go next |
| Learn by doing, new to it | Tutorial | One path that always works, concrete values, visible result at each step, no options or branches |
| Get a specific goal done, already oriented | How-to guide | Titled by the goal ("Add a second machine"), prerequisites, numbered steps, how to confirm it worked |
| Fix something that's broken | Troubleshooting | Organized by **symptom as the reader sees it** (error text, observed behavior); for each: likely causes in order, a check that tells them apart, the fix |
| Look up a fact | Reference | Organized like the **interface** they touch (commands, options, config keys, endpoints); complete, uniform entries; type, default, constraints, one example each |
| Understand how it works, to change it or reason about it | Explanation / architecture | Concepts and the mental model; the invariants a change must not break (ordering, locking, ownership, retry and failure behavior), stated next to the code they constrain; design tradeoffs and why; where to start reading and how to test a change. Internals belong here, for this reader |
| Upgrade across a change | Migration guide / release notes | What changes for *them*, ordered by impact; what they must do; how to tell it worked |
| An agent working in the repo | `CLAUDE.md` / `AGENTS.md` | Commands to build/test/run, conventions to follow, traps that waste time. Not a code tour |

When a request spans jobs (a "README" for a teammate who must also set it
up and fix it), write the README for the first job and link out to the
others, or add sections that each keep their type's shape. Don't blend
types inside one section.

Mirroring structure is correct in exactly one place: reference docs mirror
the **interface** the reader uses. No user-facing doc mirrors the
**implementation**.

## 3. Draft in the reader's terms

- **Open with what the reader gets**, in one or two sentences a newcomer
  understands, before any mechanism. "Your remote machines' files show up
  in Finder while you're SSH'd in" comes before "piggybacks on
  `ControlMaster` sockets".
- **Use the vocabulary the reader sees**: command names, flags, UI labels,
  file paths they touch, exact error text. Internal identifiers (function,
  type, package names) appear only in docs whose reader is a contributor.
- **Source citations stay out of reader-facing prose.** The hub's
  verification rules want a `file:symbol` behind every mechanical claim. Put
  those in your verification notes or the review message. The doc says what
  happens; it doesn't point at `internal/foo/bar.go`. Exception: docs for
  contributors, where a pointer to the code is the help they need.
- **Turn code paths into reader situations.** This is where reading the
  code serves the reader. Error branches become symptoms with fixes, limits
  and edge cases become "if you see X" notes, defaults become the thing that
  happens when they do nothing. Find the failures the reader will actually
  hit and put them where the reader will be when they hit them.
- **Examples come from the reader's world**, are runnable as written, and
  show the expected output so the reader can tell it worked.
- **Every section answers a question from the brief.** If a section answers
  no reader's question, cut it or move it to the doc whose reader asked.
  Implementation walkthroughs, code layout, and design history usually move
  to an architecture doc or the existing specs.

## 4. Test it on a reader before you call it done

Accuracy verification (the hub's verifier and stamping rules) checks that
the doc is *true*. It can't tell you whether the doc is *usable*. Do both.

**Reader test.** Dispatch a fresh subagent that gets **only the doc**, no
repo or code access. Give it the brief's Reader and Arrives as its persona,
and the Job as its task. Ask it to work through the job using only the doc
and report:

1. each place it got stuck, had to guess, or would have gone to the source
   code or a colleague;
2. each passage it skipped as irrelevant to its job;
3. the questions from its situation the doc never answered.

Fix what it finds and run one more reader test with a fresh subagent. If a
gap needs facts you don't have, it goes to the human as a question, not into
the doc as a guess.

If you try the doc's steps for real, do it in a temporary directory outside
the repo, so the walk-through leaves nothing behind for the human to clean
up.

## 5. Copyedit the prose, then check it for drift

After the reader test's fixes are in, copyedit the doc with the
`copyediting-docs` skill, which ships next to this one
(`<skill-dir>/../copyediting-docs/SKILL.md`). It runs a Strunk copyedit in a
subagent, then a drift check on the diff, because a copyedit that makes a
doc easier to act on also changes some of its claims. Every sentence the
drift check flags goes back through the hub's verification, or reverts.

## Quick checks before handing back

- The first paragraph tells a newcomer what they get. No mechanism yet.
- No section exists because a module exists.
- No source-file citations in reader-facing prose (unless the reader is a
  contributor).
- The failures the reader is most likely to hit are covered, keyed by what
  they observe.
- A reader test ran and its findings are fixed or listed for the human.
- A copyedit ran, and every claim its drift check flagged was verified or
  reverted.
