# Memory

## Scraped Sites
- https://www.gitagent.sh → Scraped/gitagent.sh.md (2026-09-06) — JS-only Vite SPA; metadata-only capture saved with limitation note. Site: GitAgentProtocol (GAP), open AI-agent standard by Shreyas Kapale / Lyzr Research Labs.
- https://pytorch.org → Scraped/pytorch.org.md (2026-09-06) — full clean capture via `scrape` tool. Homepage of PyTorch (Linux Foundation). Highlights: PyTorch 2.14 released (2026-09-02 blog); stable install selector shows 2.7.0 (site UI inconsistent vs blog); PyTorch Conference NA Oct 20-21 2026, San Jose.

## Lessons
- gitagent.sh is a Vite SPA with no noscript fallback; `scrape` tool + curl both yield only head metadata. Don't retry aggressively — save metadata + note.
- pytorch.org homepage renders fully server-side; `scrape` tool returns near-complete Markdown. Nav menus duplicate (top + mobile "Close Menu") — dedupe into a single Site Navigation section.
- Multi-step scrape workflow works well: read SKILL.md + load memory in parallel → scrape + task_tracker begin in parallel → timestamp via `date -u` → write → memory save → task_tracker end → skill_learner crystallize.
