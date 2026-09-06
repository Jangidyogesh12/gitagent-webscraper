# Memory

## Scraped Sites
- https://www.gitagent.sh → Scraped/gitagent.sh.md (2026-09-06) — JS-only Vite SPA; metadata-only capture saved with limitation note. Site: GitAgentProtocol (GAP), open AI-agent standard by Shreyas Kapale / Lyzr Research Labs.
- https://pi.dev/docs/latest → Scraped/pi.dev-docs-latest.md (2026-09-06) — full docs index scraped cleanly. Pi is a minimal terminal coding harness by Earendil Inc. (@earendil-works/pi-coding-agent on npm), extensible via TypeScript extensions, skills, prompt templates, themes, packages.

## Lessons
- gitagent.sh is a Vite SPA with no noscript fallback; `scrape` tool + curl both yield only head metadata. Don't retry aggressively — save metadata + note.
- Docs sites served as server-rendered/static content (e.g. pi.dev) scrape fully with the `scrape` tool; nav/link clutter is easily cleaned by keeping only heading-anchor sections and converting bare parenthesized links to inline Markdown links.