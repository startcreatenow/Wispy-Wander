# Wispy Wander

A soft, slow little browser game across **500 pastel dreams**.

Drift **Wispy** — a round cloud-puff with rosy cheeks — through dreamy levels,
collect glowing dewdrops, dodge the grumpy **Grumpfs**, and float through the
portal home.

## Play

Open `index.html` in any modern browser — no install, no build, no internet
needed. Your progress saves automatically in the browser.

Or host it: any static host (GitHub Pages, Netlify, Vercel) will serve it
as-is.

## Install as an App (PWA)

Once hosted over HTTPS, Wispy works as a Progressive Web App:

- **Chrome / Edge (desktop & Android)** — a "📲 Install App" button appears
  on the title screen. Tap it and Wispy lives in your app drawer / dock.
- **iOS Safari** — open the page, tap **Share → Add to Home Screen**.
- **Offline** — after first load, a service worker caches the game so it
  runs without internet.

## Controls

- **Hold mouse / finger** — gently pulls Wispy toward it
- **Arrow keys / WASD** — direct movement
- **Esc** or **☰ Menu** — pause / exit a level

## Features

- 500 procedurally generated dreams (each one unique)
- Color-mixing twist: Wispy tints to the last dewdrop touched; from dream 8
  the portal demands a matching color
- 3-heart life system, with Grumpfs (cute hazards) from dream 5 onward
- Persistent score across sessions
- Pure pentatonic Web Audio chimes — no music files
- Single self-contained HTML file (no dependencies)
- Installable PWA with offline support
- Mobile-friendly — adapts to portrait phones, with thumb-safe touch controls

## Tech

Vanilla HTML / CSS / Canvas / Web Audio. One file. ~1100 lines.
