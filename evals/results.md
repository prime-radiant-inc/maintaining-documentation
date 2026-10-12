# Results

## 2026-10-11: reader-centered writing flow (`references/writing.md`)

Arms: the skill as first published (v0) against the skill with the writing
flow. Two reps per arm per scenario, each judged blind as an A/B pair by an
agent playing the scenario's reader. All agents were Claude Opus 5.5.

| Scenario | Doc | Judge preference | Source citations in doc (v0 → new) |
| --- | --- | --- | --- |
| s1 README | automatic-sshfs README | new, new (both strong) | 0 → 0 |
| s2 new user | homedir-manager docs | new, new (both strong) | 0 → 0 |
| s3 troubleshooting | clipfan image paste | new (strong), new (slight) | 6, 5 → 0, 0 |
| s4 architecture, first try | clipfan sync | v0 (slight), new (slight) | kept: 26, 30 → 26, 17 |
| s4 architecture, after fix | clipfan sync | new, new (both strong) | not counted |

What changed in the docs, per the judges:

- READMEs open with what the reader gets and an example session instead of
  the internal reconcile algorithm and package layout, and include
  troubleshooting for the failure a new user hits first.
- The new-user docs walk through the reader's own files and second machine,
  and answer "what protects me from pushing a secret" directly.
- Troubleshooting docs dropped the `file.go` / function citations the old
  birth checklist pushed into reader prose, and key sections to what the
  reader observes.
- Architecture docs keep the code references a contributor needs, so there
  was no over-correction. The first try lost the concurrency and session
  invariants a reconnect fix must keep. Adding invariants to the
  architecture row of the doc-type table fixed that on rerun.

Judges skipped about 35% of v0 user docs as irrelevant to their job, and
15–30% of the new ones. The new user docs run longer (README 260–350 lines
vs 150–225); judges counted the extra length as material they needed.

Caveats:

- Two reps per arm, one model family as writer and judge. The judge only
  reads docs, so it measures usefulness, not accuracy; accuracy still comes
  from the skill's verifier passes.
- s1 ran on an unpushed branch of automatic-sshfs with an extra
  FileProviderSpike directory; `setup-fixtures.sh` pins public `main`.
- The first s4 runs used a fixture whose git history still held the removed
  doc, and one v0 run rebuilt from it. The rerun and `setup-fixtures.sh` use
  history-free fixtures.

## 2026-10-11: Strunk copyedit pass (`references/writing.md` step 5)

Inputs: the eight docs that won the comparisons above (s1, s2 and s3 from
the writing-flow arm, and s4 from the rerun after the fix), copyedited with
the `writing-clearly-and-concisely` skill. All agents were Claude Opus 5.5.

- **Reader judges:** the copyedited version won 8 of 8 blind pairs, all
  slight. Judges said the content was identical and the edits made it
  quicker to act on: active voice that says which component acts, buried
  warnings moved into their own paragraphs, parallel lists.
- **Length:** 0–3% fewer words. Code blocks and headings were unchanged in
  every case.
- **Meaning drift:** the drift check flagged 7 of about 210 changed
  sentences, in 4 of the 8 docs.
  - Two named an actor the original left unnamed ("the stream is torn down"
    became "the gateway tears down the stream").
  - The rest dropped a qualifier ("locally"), hardened "doesn't" into
    "cannot", turned an option into an instruction, or changed "does" into
    "prints".
  - One judge preferred a version partly *because of* a drifted sentence,
    which reads more decisively. Reader judges can't catch drift, so step 5
    keeps a separate drift check.
- **Constraining the copyeditor instead:** a copyedit prompt that listed
  these drift patterns as rules made 5–20× fewer edits on the four drifted
  docs, which throws away most of the benefit. Step 5 lets the copyeditor
  edit freely and catches drift afterwards.

Caveat: the drift counts come from an agent's judgment, not from checking
each claim against the code.
