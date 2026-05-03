# Roku documentation index (project)

Use this file for **repeatable, accurate** Roku guidance. In Cursor, attach it with **`@docs/roku-references.md`** (or `@docs`) when you need API truth, packaging, or certification details so answers align with official sources.

## Developer program and getting started

- [developer-program/getting-started/roku-dev-prog.md](https://developer.roku.com/en-gb/docs/developer-program/getting-started/roku-dev-prog.md) — entry to the Roku developer program / onboarding (locale `en-gb`; the same doc exists under other locale paths if you prefer).

## First hops from the developer portal

These are the usual top-level doc areas linked from the main site; use them when you need specs beyond Scene Graph habits:

- [Features overview](https://developer.roku.com/dev/docs/features-overview)
- [Specifications overview](https://developer.roku.com/dev/docs/specs-overview)
- [First steps (developer docs root)](https://developer.roku.com/dev/docs/first-steps)
- [References overview](https://developer.roku.com/dev/docs/references-overview)
- [Developer blog](https://blog.roku.com/developer)

## Scene Graph and BrightScript (deep reference)

When implementing components, fields, tasks, or nodes, prefer the **official reference** sections under [developer.roku.com](https://developer.roku.com/develop) → **Docs** (search for “SceneGraph”, “BrightScript”, “Task”, `roUrlTransfer`, etc.) rather than generic web answers.

## Sample channels (working code)

- [rokudev/samples](https://github.com/rokudev/samples) — side-loadable sample channels (advertising, analytics, media, UX components, templates, utilities). Use for **patterns** that match Roku’s own examples; align with this repo’s structure under `source/` when porting.

## This repo vs samples

- Local conventions and **tooling** (makefile, `dist/`, `out/`) live in this project; **platform behavior** should still match Roku docs and samples above.
