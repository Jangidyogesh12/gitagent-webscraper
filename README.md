# gitagent-webscraper

A git-native AI agent that scrapes any website URL you give it and saves the
page's readable text as Markdown. Built with
[GitAgent](https://github.com/open-gitagent/gitagent) (Rust port) — the agent
IS this repo: identity, rules, tools and skills are all version-controlled
files.

## How it works

1. You give the agent a URL, e.g. `gitagent --dir . "Scrape https://pytorch.org"`.
2. The `webscrape` skill takes over:
   - fetches the page with the `scrape` tool (`curl` + `python3`, stdlib only),
   - converts HTML to clean Markdown (title, headings, paragraphs, lists, links),
   - writes it to `Scraped/<sitename>.md` with a source + timestamp header,
   - replies with the saved path and a short summary, and records the scrape in memory.
3. Paywalled / login / JS-only pages and failed fetches are saved with a note
   about the limitation instead of failing silently.

## Running it

```bash
# needs OPENCODE_API_KEY (model is opencode-go/glm-5.1)
export OPENCODE_API_KEY="..."

# local: from inside this repo
gitagent --dir . "Scrape the website https://pi.dev/docs/latest"

# or directly from GitHub (needs GITHUB_TOKEN; --dir defaults to ./gitagent-webscraper)
export GITHUB_TOKEN=ghp_xxx
gitagent --repo https://github.com/Jangidyogesh12/gitagent-webscraper "Scrape https://example.com"
```

## Structure

```
.
├── agent.yaml                  # model (opencode-go/glm-5.1), tools, runtime
├── SOUL.md                     # identity: Scraper, the web-scraping agent
├── RULES.md                    # scrape-on-URL, output must go to Scraped/
├── DUTIES.md                   # scrape → Markdown → save → summarize → remember
├── skills/webscrape/SKILL.md   # step-by-step scrape workflow the agent follows
├── tools/
│   ├── scrape.yaml             # declarative `scrape` tool definition
│   └── scrape.sh               # fetch + HTML→Markdown (curl + python3 only)
├── Scraped/                    # <-- all scraped output lands here
├── memory/MEMORY.md            # remembers scraped sites (URL → file + date)
└── workspace/                  # scratch space (scrapes never go here)
```

## Where the scraped text is saved

Every scrape is stored in **`Scraped/`** as **`<sitename>.md`**:

- Filename = lowercase host without `www.`, plus sanitized path
  (`/` `?` `&` `=` → `-`):
  - `https://example.com` → `Scraped/example.com.md`
  - `https://www.example.com/blog/post?id=1` → `Scraped/example.com-blog-post-id-1.md`
- Each file starts with a header, then the page text as Markdown:

```markdown
# <Page title>

> Source: <URL>
> Scraped: <UTC timestamp, e.g. 2026-09-06T10:43:14Z>

<page text as Markdown: headings, paragraphs, lists, links>
```

Existing examples: `Scraped/pytorch.org.md`, `Scraped/gitagent.sh.md`.
