# 957dev portfolio
Vanilla HTML, CSS and JavaScript on free GitHub Pages. Requires installed Git, GitHub CLI and Python 3.12+; Node is optional. No npm packages or build dependencies.

From this repository in PowerShell:
```powershell
python scripts/test.py
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/build.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/preview.ps1
```
Open http://127.0.0.1:8000. Ctrl+C stops preview. Re-run preview after edits to rebuild dist. Use -Port 8001 if needed. Build copies only public assets into dist and validates preserved text/links and JSON. Source index.html also works without JavaScript.

Authentication:
```powershell
gh auth login --hostname github.com --git-protocol https --web
gh auth setup-git
gh auth status
gh api repos/957dev/957dev.github.io --jq .permissions
gh api repos/957dev/957dev.github.io/pages
```
Restart terminal after installing gh if PATH is stale. Never paste a token into chat.

Development:
```powershell
git switch development
git diff
# Stage only intended files, then:
git commit -m "Describe actual changes"
git push -u origin development
```
Before submitting, configure ChristoDex Project settings > Source control as Git for this directory. The setup does not push or deploy.

Publishing, only after explicit authorization and a reviewed clean commit on development:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/publish.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/publish.ps1 -Publish
gh run list --branch main --limit 5
```
The first command validates only. -Publish checks remote and Pages configuration, fetches origin, requires origin/main to be an ancestor, then pushes development and fast-forwards remote main without force. GitHub Pages handles deployment. If branch protection requires a PR, use gh pr create --base main --head development and follow required checks; do not bypass protection. If remote main advanced, merge origin/main into development, resolve and test before retrying. Pages must already publish from main /; the script refuses other settings instead of changing them.

Original index preserved byte-for-byte in docs/original/index.html and upstream commit 511d6cb. Tests intentionally guard its text and links. The existing LinkedIn placeholder is preserved for a future authorized edit. Future project data and password architecture: docs/portfolio-architecture.md.

Setup verification: GitHub Pages currently deploys from main at /. GitHub CLI authenticated as 1-Christo, but that account currently has pull access only (push: false). Grant collaborator write access from the owner account or authenticate as the owner before publishing.
