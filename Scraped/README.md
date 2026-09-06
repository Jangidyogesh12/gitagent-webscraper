# Scraped

This folder holds all website scrapes as Markdown.

- Filename: `Scraped/<sitename>.md` — lowercase host without `www.`, sanitized path (`/` `?` `&` `=` → `-`). E.g.:
  - `https://example.com` → `Scraped/example.com.md`
  - `https://www.example.com/blog/post?id=1` → `Scraped/example.com-blog-post-id-1.md`
- Format inside each file:
  ```markdown
  # <Page title>

  > Source: <URL>
  > Scraped: <UTC timestamp>

  <text as Markdown>
  ```
