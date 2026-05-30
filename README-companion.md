# Theme companion app — customization guide

> **Canonical documentation:** [https://github.com/uithemer/harbour-themepack-companion](https://github.com/uithemer/harbour-themepack-companion)  
> This file is a local draft in theme repos; the companion template and docs live in that repository.

This repository is a **UI Themer theme companion app**: a small Sailfish app that ships with a theme pack, lets users request missing icons, and links to docs and translations. When forking to create your own theme, change configuration in a few known places instead of hunting through QML strings.

For **creating the theme pack itself** (folder layout, icons, overlays), see the general pack documentation at [https://uithemer.github.io/harbour-muoto/](https://uithemer.github.io/harbour-muoto/).

---

## Quick start checklist

When forking this template, work through this list in order:

1. [ ] Edit [`qml/Settings.qml`](qml/Settings.qml) — names, URLs, email, translators, install path
2. [ ] Rename `TARGET` in [`harbour-themepack-evolve-plus.pro`](harbour-themepack-evolve-plus.pro) and align `packInstallPath` in Settings.qml
3. [ ] Update [`rpm/harbour-themepack-evolve-plus.spec`](rpm/harbour-themepack-evolve-plus.spec) — Summary, Packager, URL, package name
4. [ ] Update [`harbour-themepack-evolve-plus.desktop`](harbour-themepack-evolve-plus.desktop) — `Name=`, `[X-Sailjail]` org/app names
5. [ ] Set display name in [`theme/package`](theme/package) (read by UI Themer)
6. [ ] Replace [`other/appinfo.png`](other/appinfo.png) and [`other/coverbg.png`](other/coverbg.png)
7. [ ] Replace theme assets under [`theme/`](theme/) and run [`theme/themepack-helper.sh`](theme/themepack-helper.sh) to generate PNGs from SVGs
8. [ ] Update [`README.md`](README.md) and [`_config.yml`](_config.yml) for your GitHub Pages project site
9. [ ] Refresh translations (`lupdate` / Transifex) if you change translatable strings in QML

---

## `qml/Settings.qml`

Single maintainer config file. All fork-specific runtime values live here.

| Property | Purpose | Example (Evolve Plus) |
|---|---|---|
| `appName` | Page title, install message, email subject context | `"Evolve Plus"` |
| `appIcon` | Header image path (relative to `qml/pages/`) | `"../../appinfo.png"` |
| `iconAttributionHtml` | Rich-text license / icon credits (not translated) | WanMonstar / Nfanliver links |
| `sourcesUrl` | Sources button | GitHub Pages project URL |
| `docsUrl` | Documentation button (companion customization guide) | `https://github.com/uithemer/harbour-themepack-companion` |
| `donateUrl` | Donate button | Liberapay / PayPal URL |
| `transifexUrl` | Transifex button | `https://explore.transifex.com/…/` |
| `translators` | List of `{ language, name }` for credits section | See current file |
| `packInstallPath` | Installed theme directory on device | `/usr/share/harbour-themepack-evolve-plus` |
| `iconRequestEmail` | Mailto recipient for icon requests | `me@fravaccaro.com` |
| `iconRequestSubject` | Email subject for icon requests | `"Icon request for Evolve Plus"` |

**Important:** `packInstallPath` must match the RPM install path: `/usr/share/<TARGET>` where `TARGET` is the value in the `.pro` file.

Strings in Settings.qml are **not** passed through `qsTr()` — edit them directly in your fork language.

---

## Packaging metadata (outside Settings.qml)

| File | What to change |
|---|---|
| `harbour-themepack-evolve-plus.pro` | `TARGET` — drives binary name, QML path, install paths |
| `rpm/*.spec` | `%global` name, Summary, Packager, URL, Requires |
| `*.desktop` | `Name=`, `Icon=`, `Exec=`, `[X-Sailjail]` OrganizationName / ApplicationName |
| `theme/package` | Theme display name (one line) |
| `other/appinfo.png` | App icon (shown in UI and package) |
| `other/coverbg.png` | Cover background |
| `appicons/*` | Hicolor launcher icons |

After renaming the project, search the repo for the old package name and replace consistently.

---

## Theme assets

Theme files live under [`theme/`](theme/). Typical layout:

- `native/scalable/apps/` — SVG sources for native app icons
- `native/86x86/apps/` (etc.) — exported PNG sizes
- `apk/scalable/` — Android launcher icons
- `jolla/scalable/icons/` — Jolla stock icons
- `overlay/` — overlay PNGs/SVGs

### `theme/themepack-helper.sh`

Run from the **`theme/`** directory to export SVGs to PNG at the sizes UI Themer expects:

```bash
cd theme
./themepack-helper.sh
```

Requires **Inkscape**. The script detects the version once at startup:

- **Inkscape 1.x:** batches all sizes for each SVG in one process (`--actions`), typically **~3–5 minutes** for a full pack
- **Inkscape 0.92:** legacy `-f`/`-e` path, one process per size (slower)

Progress is printed to stderr (`Exporting input → output`). Section banners mark each block (Jolla, native, apk, etc.). Output directories are created automatically if missing.

Ensure output directories exist before running (e.g. `native/86x86/apps/`).

Pack structure and conventions: [harbour-muoto documentation](https://uithemer.github.io/harbour-muoto/).

---

## Translations

User-visible strings in [`qml/pages/FirstPage.qml`](qml/pages/FirstPage.qml) use `qsTr()` and live in [`translations/*.ts`](translations/).

- Update `.ts` files with `lupdate harbour-themepack-evolve-plus.pro`
- Compile with `lrelease` or via SFOS build
- Host/community translations on Transifex — set `transifexUrl` in Settings.qml

Do not put translatable UI text in Settings.qml if you want community translations.

---

## Icon request flow

1. User must tap **Donate** or enable **I don't care donating** before **Request icons** is enabled (`FirstPage.qml`).
2. QML calls `ThemePack.fetchIcons(packInstallPath, iconRequestEmail, iconRequestSubject)`.
3. C++ compares installed vs themed icon filenames and opens a `mailto:` with the list.

Email, subject, and pack path all come from Settings.qml.

---

## Sailjail

The desktop file includes:

```ini
[X-Sailjail]
Sandboxing=Disabled
```

APK launcher icons live under `/home/defaultuser/.local/share/apkd-bridge/launcherIcon`, which is not whitelisted in the default Sailjail profile. Sandboxing is disabled so icon request can read that directory. Harbour apps cannot ship with custom Sailjail permissions; this app is distributed outside Harbour.

If you fork, update `OrganizationName` and `ApplicationName` to match your package.

---

## App structure (reference)

```
qml/
  Settings.qml              ← maintainer config
  harbour-themepack-evolve-plus.qml
  pages/FirstPage.qml       ← main UI
  components/               ← LabelText, etc.
src/
  themepack.cpp             ← icon request logic
theme/                      ← theme pack files
```

The companion app does not apply themes — **UI Themer** (or harbour-muoto) does that. This app only documents and ships the pack.
