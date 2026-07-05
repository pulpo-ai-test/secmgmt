# SecMgmt — Travel Risk Intelligence Map

## Project Overview

A mobile app (iOS/Android) that aggregates government travel advisories, conflict events (ACLED), and natural disaster alerts (GDACS) onto a single OpenStreetMap map. Offline-first, zero accounts, AGPL-3.0+ open source.

**Architect profile:** cq-mgmt-assistant (this repo's documentation and issues define the spec)  
**Coder profile:** sw-coder (implements from issues, using OpenCode CLI or similar)

---

## Build System

- **Framework:** Flutter (cross-platform iOS + Android)
- **Minimum SDK:** Android 8.0 / iOS 14
- **Map library:** flutter_map (OpenStreetMap)
- **State management:** Riverpod or BLoC
- **Local storage:** SQLite (drift/sqflite)
- **Tile caching:** flutter_map_tile_caching
- **HTTP client:** dio + caching interceptor

## Architecture (v1)

```
                    ┌─────────────────────┐
                    │  User (solo traveler)│
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │  SecMgmt Mobile App │
                    │  (Flutter)          │
                    │                     │
                    │  ┌───────────────┐  │
                    │  │  Map Screen   │  │
                    │  │  (flutter_map)│  │
                    │  └──────┬────────┘  │
                    │         │           │
                    │  ┌──────▼────────┐  │
                    │  │  SQLite DB    │  │
                    │  │  (offline)    │  │
                    │  └───────────────┘  │
                    └──────────┬──────────┘
                               │
           ┌───────────────────┼───────────────────┐
           │                   │                   │
   ┌───────▼───────┐   ┌──────▼──────┐   ┌───────▼───────┐
   │ Government     │   │ ACLED       │   │ GDACS         │
   │ Travel APIs    │   │ Conflict    │   │ Natural       │
   │ (6 sources)    │   │ Events API  │   │ Disasters RSS │
   └────────────────┘   └─────────────┘   └───────────────┘
```

**Key principle:** The app calls APIs directly. No backend server in v1.

## Data Sources (v1)

### Government Travel Advisories
1. US State Department — `https://cadataapi.state.gov/api/CountryTravelInformation/{tag}` + RSS feed
2. UK FCDO — `https://www.gov.uk/api/content/foreign-travel-advice/{country}`
3. Canada GAC — Travel advisories API at travel.gc.ca
4. France Diplomatie — RSS/scrape at diplomatie.gouv.fr
5. Australia DFAT — Smartraveller data
6. Germany AA — Reise- und Sicherheitshinweise

### Conflict & Political Violence
7. ACLED API (free tier, key embedded in app)
8. GDELT (Google BigQuery, no key needed) — optional supplement

### Natural Disasters
9. GDACS RSS — `https://www.gdacs.org/xml/rss.xml` with geo:lat/geo:long coordinates

## Map Display

- **Base layer:** OpenStreetMap (free, no API key)
- **Layer 1:** Country fill colors by advisory level (L1=green, L2=yellow, L3=orange, L4=red)
- **Layer 2:** Conflict event pins (color-coded by type) — clustered at zoom, individual at high zoom
- **Layer 3:** Natural disaster icons + impact radius
- **Layer 4 (future):** Humanitarian incidents (INSO)

## Screens (v1)

1. **Map Screen** — OSM base + toggleable layers + tap-on-country popup
2. **Layer Selector** — bottom sheet with checkboxes + legend
3. **Country Detail** — consolidated advisories from all sources + recent events
4. **Event Detail** — single event metadata
5. **Settings** — offline cache management, language, about

See `docs/wireframes.html` for visual mockups.

## Data Model (SQLite)

### country_advisories
- country_code (ISO 3166-1 alpha-2, PK)
- source (PK: e.g. "state_dept", "fco", "canada", etc.)
- advisory_level (integer 1-4)
- risk_factors (JSON array of strings)
- full_text (advisory body text)
- last_updated (ISO 8601)
- source_url

### conflict_events
- event_id (PK, from ACLED or internal)
- event_type (battle, explosion, violence_civilians, riot, protest, strategic_dev)
- date
- country_code
- location_name
- latitude
- longitude
- fatalities (integer)
- actors (JSON)
- description
- source

### disaster_events
- event_id (PK, from GDACS)
- disaster_type (earthquake, cyclone, flood, wildfire, volcano, drought)
- alert_level (green, orange, red)
- date
- country_code
- latitude
- longitude
- radius_km (float)
- description
- source_url

### country_metadata (bundled)
- country_code (PK)
- name
- region
- border_geojson (approximate polygon)

## Implementation Order

Build in this sequence (each maps to a GitHub Issue):

1. **Project scaffold** — Flutter project with flutter_map, OSM base layer, folder structure
2. **Country data** — bundled country metadata, world map loaded
3. **Advisory engine** — fetch + parse + cache from all 6 government sources
4. **Map layer: advisories** — country fill coloring by advisory level
5. **Conflict layer** — ACLED/GDELT fetch + pin display with clustering
6. **Disaster layer** — GDACS fetch + icon display
7. **Country detail screen** — consolidated view with all sources + events
8. **Event detail screen** — single event metadata view
9. **Layer selector** — bottom sheet with toggles and legend
10. **Offline preload** — cache management, staleness indicators, region download
11. **Settings & polish** — language picker, about page, data refresh controls

## Budget Notes

- Uses OpenAI/Codex credits via the sw-coder profile
- Budget is limited — each issue should be implemented efficiently
- Target: one issue per session, review before next issue
- Weekly limit resets Sundays 22:43 UTC

## Commit Convention

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation
- `refactor:` for code restructuring
- `chore:` for build/config changes

## Testing

- Unit tests for data parsing and model logic
- Widget tests for screens (minimal)
- The app should always compile with zero warnings
