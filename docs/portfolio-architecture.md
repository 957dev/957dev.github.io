# Future project portfolio
Keep the existing page as the public landing page. Add an optional portfolio page and renderer using loadProjects(); no framework required. The empty versioned JSON does not change current content.

Public project shape:
```json
{"id":"sample","title":"Project title","description":"Plain text","images":[{"src":"assets/images/sample.webp","alt":"Descriptive text"}],"youtubeIds":["abcdefghijk"]}
```
Render text with textContent, validate URLs, and create images with alt text and lazy loading. Embed validated 11-character IDs using https://www.youtube-nocookie.com/embed/ID with a title, lazy loading and fullscreen support. Do not store arbitrary iframe HTML.

Password gating is a future feature, not implemented. GitHub Pages has no application server for password validation. A UI-only password gate leaves JSON/images downloadable. For a free static solution, encrypt confidential project JSON and images locally with authenticated encryption (Web Crypto AES-GCM, random salt/IV, password-derived key) and publish ciphertext only; decrypt in browser memory after entry. Keep source plaintext outside the public Git checkout and never commit passwords or keys. Design the renderer behind a data-provider interface so a decrypted provider can later replace the public JSON loader.
Public or unlisted YouTube videos are not made confidential by this gate. For sensitive videos, decide a separately protected hosting strategy before adding them. Password rotation cannot revoke already downloaded/decrypted data. No encryption is claimed by this scaffold.
