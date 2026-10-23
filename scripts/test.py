from pathlib import Path
from html.parser import HTMLParser
import json
from urllib.parse import urlsplit, unquote
ROOT = Path(__file__).resolve().parent.parent
class Page(HTMLParser):
    def __init__(self):
        super().__init__(); self.links=[]; self.local=[]; self.words=[]; self.hidden=0
    def handle_starttag(self, tag, attrs):
        a=dict(attrs)
        if tag in ('style','script'): self.hidden+=1
        if tag=='a': self.links.append(a.get('href'))
        for key in ('src','href'):
            value=a.get(key,''); u=urlsplit(value)
            if value and not u.scheme and not u.netloc and u.path: self.local.append(unquote(u.path))
    def handle_endtag(self, tag):
        if tag in ('style','script'): self.hidden-=1
    def handle_data(self, data):
        if not self.hidden: self.words.extend(data.split())
def parse(path):
    page=Page(); page.feed(path.read_text(encoding='utf-8')); return page
current=parse(ROOT/'index.html')
for link in current.local:
    assert (ROOT/link).is_file(), f'Missing local asset: {link}'
original=parse(ROOT/'docs/original/index.html')
assert original.links == current.links, 'Existing links changed; review preservation before updating this check'
# Authorized preview test: add a full stop to the existing name heading.
expected = Page()
expected.feed((ROOT/'docs/original/index.html').read_text(encoding='utf-8').replace('<h1>Christo</h1>', '<h1>Christo.</h1>'))
assert expected.words == current.words, 'Existing content changed; review preservation before updating this check'
data=json.loads((ROOT/'data/projects.json').read_text(encoding='utf-8'))
assert data['version']==1 and isinstance(data['projects'],list)
ids=set()
for project in data['projects']:
    assert all(isinstance(project.get(k),str) and project[k] for k in ('id','title','description'))
    assert project['id'] not in ids
    ids.add(project['id'])
    for image in project.get('images',[]):
        assert isinstance(image['alt'],str)
        assert image['src'].startswith('assets/images/') and (ROOT/image['src']).is_file()
    for video in project.get('youtubeIds',[]):
        import re
        assert re.fullmatch(r'[A-Za-z0-9_-]{11}',video)
print('PASS: original text and links preserved; local assets and project data valid.')
