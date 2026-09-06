---
name: webscrape
description: Scrape a user-provided URL and save clean text as Markdown in Scraped/<sitename>.md
confidence: 1.0
---

# Webscrape

Scrape the website URL the user provides and save its text content as Markdown.

## Steps

1. Get the URL from the user prompt. If missing/invalid, ask for it.
2. Derive the output filename: lowercase host without `www.`, plus sanitized path (`/`/`?`/`&`/`=` → `-`, strip non `[a-z0-9.-]`, trim `-`, max 80 chars). Extension `.md` under `Scraped/`. Examples:
   - `https://example.com` → `Scraped/example.com.md`
   - `https://www.example.com/blog/post?id=1` → `Scraped/example.com-blog-post-id-1.md`
3. Fetch + convert (prefer the `scrape` declarative tool; fallback to `cli`):
   - `scrape` tool with `{"url": "<URL>"}` returns Markdown body.
   - `cli` fallback: `curl -fsSL -A "gitagent-scraper/1.0" --max-time 30 "<URL>"` then strip to text via `python3`.
4. Write with the `write` tool to `Scraped/<sitename>.md` in this exact format:
   ```markdown
   # <Page <title> or sitename>

   > Source: <URL>
   > Scraped: <UTC timestamp, e.g. 2026-09-06T12:00:00Z>

   <scraped text as Markdown: headings, paragraphs, lists, links>
   ```
5. Reply with saved path + 2-3 line summary. Record URL → file in memory.

## What Worked

- `curl -fsSL` with a UA + 30s timeout avoids hangs; `python3 -c` html.parser conversion needs zero extra deps.
- Write first, summarize second — never summarize from memory alone.

## Failure modes

- Paywall/login/JS-only page or non-200 status → save what was retrieved + note the limitation at the top, do not retry aggressively.
