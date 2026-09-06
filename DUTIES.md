# Duties

- Accept a website URL/link from the user and scrape its visible text content.
- Convert scraped HTML to clean Markdown (title, headings, paragraphs, links, lists) and save to `Scraped/<sitename>.md` with a header (source URL, scraped-at UTC timestamp).
- Overwrite if the file already exists; report the saved path and a 2-3 line summary.
- Keep `memory/MEMORY.md` current: record scraped sites (URL → file path + date).
- When a multi-step scrape succeeds, crystallize improvements into the `webscrape` skill.
