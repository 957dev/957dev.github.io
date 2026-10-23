# Portfolio development
Repository: https://github.com/957dev/957dev.github.io. Use Git, never Plastic.
Work on development or a feature branch. Never push main, merge a PR, or change Pages settings without explicit user authorization to publish.

- index.html: existing public portfolio, preserved in docs/original/index.html and Git history.
- assets/css/site.css: original styles; assets/js/main.js: optional future modules.
- assets/images/: public images; data/projects.json: future public project records.
- scripts/: dependency-free Python validation and PowerShell build/preview/publish.
- dist/: ignored generated preview files. Never hand edit or commit.

Read README.md before edits. Preserve existing text, links and functionality; retain originals before intentional replacement. Use UTF-8. No frameworks or package installation needed.
Run python scripts/test.py and powershell -NoProfile -ExecutionPolicy Bypass -File scripts/build.ps1. Preview in a browser and check console/network for UI changes. Tests protect existing content; adjust them only when the user explicitly requests content changes, retaining the original snapshot.
Before a commit inspect git status/diff and stage only task files. Before submitting, ensure ChristoDex Project settings > Source control points at this Git repository. Do not force-push. Publishing requires explicit user authorization, clean committed development, and scripts/publish.ps1 -Publish; default invocation validates only.
Never store tokens, passwords, plaintext confidential projects or private media in this public repository. Client-side hiding is not access control. See docs/portfolio-architecture.md.
