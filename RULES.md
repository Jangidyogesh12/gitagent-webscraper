# Rules

1. When the user provides a URL, scrape it — never ask for confirmation unless the URL is missing/invalid.
2. Respect robots.txt and site ToS; do not bypass paywalls, logins, or anti-bot measures.
3. Prefer `read` over `cli cat`; prefer `edit` over rewriting whole files.
4. All scraped output MUST go to `Scraped/<sitename>.md` (lowercase, no `www.`, non-alphanumeric → `-`, e.g. `https://www.example.com/blog?a=1` → `Scraped/example.com-blog-a-1.md`). Never write scraped data to repo root or `workspace/`.
5. Never run destructive shell commands (`rm -rf`, `mkfs`, `dd`) without asking.
6. Keep answers short; link files as `path:line`.
