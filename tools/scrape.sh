#!/bin/sh
# scrape tool: args JSON {"url": "...", "max_chars": N} on stdin, Markdown on stdout.
# Deps only: curl + python3 (stdlib). 30s timeout, fail-soft.
input=$(cat)
URL=$(printf '%s' "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('url',''))")
MAX=$(printf '%s' "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('max_chars',20000))")

if [ -z "$URL" ]; then
  echo "Error: 'url' is required" >&2
  exit 1
fi

case "$URL" in
  http://*|https://*) ;;
  *) echo "Error: URL must start with http:// or https://" >&2; exit 1 ;;
esac

HTML=$(curl -fsSL -A "gitagent-scraper/1.0" --max-time 30 "$URL" 2>&1)
STATUS=$?
if [ $STATUS -ne 0 ]; then
  echo "Error: failed to fetch $URL: $HTML" >&2
  exit 1
fi

printf '%s' "$HTML" | URL="$URL" MAX="$MAX" python3 -c "
import sys, os, re, html
from html.parser import HTMLParser

url = os.environ.get('URL','')
max_chars = int(os.environ.get('MAX','20000') or 20000)
raw = sys.stdin.read()

class MD(HTMLParser):
    def __init__(self):
        super().__init__()
        self.out=[]; self.title=''; self._title=False
        self._skip=False; self._li=False; self._link=None
    def handle_starttag(self,tag,attrs):
        tag=tag.lower()
        if tag in ('script','style','nav','footer','noscript'): self._skip=True; return
        if tag=='title': self._title=True; return
        if tag in ('h1','h2','h3','h4'): self.out.append('\n'+('#'*(int(tag[1])))+' ')
        elif tag=='p': self.out.append('\n\n')
        elif tag=='br': self.out.append('\n')
        elif tag=='li': self.out.append('\n- '); self._li=True
        elif tag=='a':
            href=dict(attrs).get('href','')
            self._link=href
    def handle_endtag(self,tag):
        tag=tag.lower()
        if tag in ('script','style','nav','footer','noscript'): self._skip=False; return
        if tag=='title': self._title=False; return
        if tag=='a' and self._link: self.out.append(f' ({self._link})'); self._link=None
        if tag=='li': self._li=False
        if tag in ('h1','h2','h3','h4','p','ul','ol','div'): self.out.append('\n')
    def handle_data(self,data):
        if self._skip: return
        t=html.unescape(data)
        if self._title: self.title+=t.strip(); return
        t=re.sub(r'\s+',' ',t)
        if t.strip(): self.out.append(t)

p=MD(); p.feed(raw)
text=''.join(p.out)
text=re.sub(r'\n{3,}','\n\n',text).strip()
if len(text)>max_chars: text=text[:max_chars]+'\n\n...[truncated]'
print(f'# {p.title.strip() or url}\n')
print(text if text else '(no readable text found)')
"
