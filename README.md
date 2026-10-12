# maintaining-documentation

A coding-agent skill for writing documentation people can use, and keeping
it true over time. It writes READMEs, tutorials, how-to guides,
troubleshooting guides, reference, and architecture docs for the reader who
will open them, instead of narrating the code. It audits docs against the
code, updates the docs that ride along with a code change, maintains a
project terminology dictionary, and decides where new docs belong. It refuses
to rewrite historical records like design specs and plans just because the
code moved on.

## Installation

Native integration files and installation guides are generated with
[everyharness](https://github.com/prime-radiant-inc/everyharness) from
`everyharness.yaml`.

<!-- everyharness:install:start -->

| Harness | Install |
|---|---|
| Claude Code | see docs/install/claude-code.md |
| Cursor | see docs/install/cursor.md |
| Codex | see docs/install/codex.md |
| Devin CLI | see docs/install/devin.md |
| Kimi Code | see docs/install/kimi.md |
| Gemini CLI | see docs/install/gemini.md |
| OpenCode | see docs/install/opencode.md |
| Pi | see docs/install/pi.md |
| Hermes Agent | see docs/install/hermes.md |
| muse | see docs/install/muse.md |
| Agent Plugins 1.0 clients | see docs/install/agent-plugins-1.0.md |
| Factory Droid / Grok / Copilot (marketplace descriptor) | see docs/install/agents-marketplace.md |

<!-- everyharness:install:end -->

See the [support matrix](docs/support-matrix.md) for what each harness supports.

## Using it

The skill triggers on its own when a task involves docs. You can also ask
for it directly:

> People keep asking why image paste fails over SSH. Write a troubleshooting doc.

> Audit the docs in this repo against the code.

> I just finished this branch. Update the docs that cover what I changed.

> Where should a doc about the new retry policy live?

> Set up a terminology dictionary for this project.

When it writes a doc, the agent first pins down who the reader is, what
brought them to the doc, and what they need to get done. It picks the doc
type that fits that job, writes in the reader's vocabulary rather than the
code's, and then hands the draft to a fresh agent playing that reader, with
no access to the code, to find where they get stuck. Last, it copyedits the
prose with Strunk's *The Elements of Style* and checks that the copyedit
didn't change what any sentence claims.

The plugin ships a second skill, `writing-clearly-and-concisely`, which
carries the full text of *The Elements of Style* (1918). It triggers on its
own for any prose you ask the agent to write.

On first use in a project, the agent proposes which docs are **evergreen**
(must match current reality: README, guides, reference) and which are
**point-in-time** (true as of their date: specs, plans, design notes). It
asks you to confirm before editing anything. That classification is saved in
a doc index so later runs don't ask again.

## What it adds to your project

At most two files, plus a one-line stamp at the end of each verified doc:

- `docs/DICTIONARY.md`: the project's canonical terms and their deprecated
  synonyms.
- A doc index table, in `docs/README.md` (or `docs/INDEX.md` if there is no
  docs README), recording each doc's class and the code paths it covers.

The agent leaves its edits uncommitted for you to review.

## The `docmaint` helper

The skill bundles `skills/maintaining-documentation/scripts/docmaint`, a
stdlib-only Python 3 tool the agent uses for the mechanical parts:

```bash
python3 skills/maintaining-documentation/scripts/docmaint --help
python3 skills/maintaining-documentation/scripts/docmaint scan  --root /path/to/repo
python3 skills/maintaining-documentation/scripts/docmaint stale --root /path/to/repo
```

`scan` finds deprecated terms, `stamp` reads or writes last-reviewed stamps,
and `stale` lists docs whose code changed since they were last verified. It
never edits doc prose.

Requirements: Python 3.10+ and Git.

## Development

```bash
python3 skills/maintaining-documentation/scripts/docmaint_test.py  # helper tests
npx everyharness generate   # after editing everyharness.yaml or skills
npx everyharness validate
```

`evals/` holds the doc-writing scenarios used to test changes to the
skill: real repos with one doc removed, and a blind judge that plays the
doc's reader. See `evals/scenarios.md`.

Generated harness files are committed. Edit `everyharness.yaml` and the
skill, then regenerate; don't hand-edit generated files.

## License

MIT, except `skills/writing-clearly-and-concisely/elements-of-style.md`:
William Strunk Jr.'s *The Elements of Style* (1918), public domain, from
[Project Gutenberg #37134](https://www.gutenberg.org/ebooks/37134).
