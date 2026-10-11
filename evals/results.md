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
