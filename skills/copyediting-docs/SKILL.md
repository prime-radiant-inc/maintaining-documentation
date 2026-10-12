---
name: copyediting-docs
description: Use when copyediting or tightening the prose of documentation (README, guide, tutorial, troubleshooting, reference, architecture doc) whose content is already settled, or when a doc reads as wordy, passive, or vague.
---

# Copyediting docs

## Overview

`elements-of-style.md` is William Strunk Jr.'s *The Elements of Style*
(1918), with the rules of composition in full and the punctuation rules and
usage list cut to what applies to technical docs. A copyedit by its rules
makes a doc quicker to act on. It also changes claims, so every copyedit
ends with a drift check.

Copyedit after the content is settled. Copyediting a draft that still needs
restructuring polishes text you're about to throw away.

## 1. Copyedit

Save a copy of the doc outside the repo; you'll diff against it. Dispatch a
fresh subagent, which keeps the ~11,000-token style guide out of your
context:

```
Copyedit <doc>. Edit it in place.

First read <skill-dir>/elements-of-style.md in full. It is Strunk's The
Elements of Style. Apply its rules to the prose: active voice, positive
form, definite and concrete language, omit needless words, one topic per
paragraph opening with a topic sentence, parallel form for co-ordinate
ideas, related words kept together, emphatic words at the end of sentences,
and the usage rules.

Keep exactly as they are:
- every fact, number, default, command, flag, path, error message, and
  code block;
- the headings and their order, and every link;
- anything the reader needs to do their job. Cut words, never information.

Do not read any other file, and do not add content.

When you finish, reply with nothing but: the word count before and after,
and the five changes you think help the reader most, each as
"before" → "after".
```

Name the rules in the prompt as written. In testing, a bare "copyedit by its
rules" prompt produced edits that readers preferred less, and more drift.

Check afterwards that code blocks and headings are unchanged.

## 2. Check the edit for drift

Drift is a copyedit that changes what a sentence claims. The common cases:

| Edit | Example | What changed |
| --- | --- | --- |
| Active voice names an actor the original left unnamed | "the stream is torn down" → "the gateway tears down the stream" | New claim about which component acts |
| A qualifier drops | "not published locally" → "not published" | Scope widened |
| A negative hardens | "doesn't attach an image" → "cannot attach an image" | Stronger claim |
| An option becomes an instruction | "you can run X" → "run X" | The reader now thinks it's required |

Dispatch a second fresh subagent with the word diff
(`git diff --no-index --word-diff <original> <edited>`) and this job:

```
For each changed sentence, decide whether the edit means exactly what the
original meant. List every one that drops or adds a fact, qualifier, or
condition; changes scope; turns an option into an instruction or the
reverse; or changes who or what does something. Don't flag pure rewording.
```

Check each listed sentence against the code. Keep the edit if the code bears
it out; otherwise restore the original wording.

Don't give the copyeditor these drift patterns as rules up front. In
testing, that made it 5–20× more timid, and most of the benefit went with
it. Edit freely, then check.
