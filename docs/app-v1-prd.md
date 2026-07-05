# SecMgmt App — v1 Product Requirements Document

**Project:** SecMgmt — Travel Risk Intelligence Map  
**Version:** 1.0 (MVP)  
**Status:** Draft — design decisions locked  
**License:** AGPLv3+ (copyleft open-source)  
**Date:** 2026-07-04  
**Design decisions finalized:** 2026-07-04  

---

## 1. Product Vision (v1)

A **mobile app** that aggregates travel security advisories from multiple government sources, conflict/event data, and natural disaster alerts onto a single interactive map with **OpenStreetMap** as the base layer. Designed for solo travelers, freelancers, and anyone who needs a quick, consolidated picture of risks in their destination — without creating an account, without sending data to a server.

**One-sentence:** *"All the embassy warnings, conflict alerts, and disaster data you need — one map, one app, zero accounts."*

---

## 2. Target User (v1)

- **Primary:** Adventure traveler preparing a trip to a non-trivial destination. Wants to know: what do the embassies say? Is there active conflict? Any recent natural disasters?
- **Secondary:** Freelancer/contractor being deployed. Quick check before departure.
- **Tertiary:** Anyone curious about safety conditions in a given country/region.

**Not targeting in v1:** NGOs, teams, institutions, security managers. Those come in v2+.

---

## 3. Core Features (v1)

### 3.1 Map Display
- **Base layer:** OpenStreetMap (free tile server, e.g. OpenStreetMap's standard tiles or Thunderforest)
- **Zoom/pan/full-screen:** Standard mobile map interaction
- **Offline tile caching:** Map tiles cached locally for visited areas. User can pre-download regions
- **"Last updated" indicator:** Semi-transparent footer showing when each data layer was last refreshed
- **Country outlines:** Country borders visible at appropriate zoom levels

### 3.2 Data Layers (Toggleable)

The user can enable/disable each layer independently via the layer selector.

#### Layer A — Government Travel Advisories
Consolidates warnings from **at least** these sources at launch:

| Source | Data Format | Update Frequency | Notes |
|--------|------------|-----------------|-------|
| **US State Dept** | REST API + RSS | Real-time (API) | Advisory level 1-4 per country + risk factors (crime, terrorism, kidnapping, civil unrest, health) |
| **UK FCDO** | gov.uk Content API | Near real-time | Full travel advice text + alerts per country |
| **Canada GAC** | Public API | Near real-time | Country travel advisories |
| **France Diplomatie** | Web scrape / RSS | Daily | Conseils aux voyageurs |
| **Australia DFAT** | Smartraveller data | Daily | Country advisories |
| **Germany AA** | Web scrape / RSS | Daily | Reise- und Sicherheitshinweise |

**Display:**
- Country fill color based on worst advisory level (1=green, 2=yellow, 3=orange, 4=red)
- Tapping a country opens advisory summary card from all sources
- User can expand any source to read full text

#### Layer B — Conflict & Political Violence Events
- **Source:** ACLED (Armed Conflict Location & Event Data) — free with registration
- **Display:** Pin map with clustered markers at medium zoom, individual pins at high zoom
- **Pin colors by event type:**
  - Red = battles / armed clashes
  - Orange = explosions / remote violence
  - Purple = violence against civilians
  - Blue = riots / protests
  - Gray = strategic developments
- **Pin info on tap:** Event type, date, location, fatalities, source

#### Layer C — Natural Disasters
- **Source:** GDACS (Global Disaster Alert and Coordination System) — RSS + GeoJSON
- **Display:** Icon-based markers + impact radius overlay where available
- **Types:** Earthquakes, cyclones/hurricanes, floods, volcanic activity, wildfires, droughts
- **Severity:** Green/orange/red icon border indicating GDACS alert level
- **Pin info on tap:** Disaster type, date, affected area, alert level, description

#### Layer D — (Future) INSO / Humanitarian Incidents
- Placeholder for v2. Open data from humanitarian incident databases.

### 3.3 Advisory Summary (Country View)

When the user taps on a country:
- **Header:** Country name + consolidated advisory level (the highest across all sources) + color indicator
- **Source cards:** One card per government source, each showing:
  - Source name + flag icon
  - Advisory level (Level 1-4 or equivalent)
  - Risk factor tags (crime, terrorism, kidnapping, etc.) — machine-readable from API
  - Tap to expand full advisory text
- **Recent events:** List of recent ACLED/GDACS events in that country
- **Last updated:** Timestamp per source
- **Action button:** "Preload for offline" — download all data for this country

### 3.4 Event Detail (Pin View)

When the user taps a conflict or disaster pin:
- **Header:** Event type icon + title
- **Details:** Date, location (city/region), source
- **Conflict events:** Event type, fatalities (if reported), actors involved (if available), description
- **Disaster events:** Alert level, affected area description, link to GDACS report
- **Action:** "Related advisories" — shows which countries' advisories cover this area

### 3.5 Offline Capability

| Component | Offline Behavior |
|-----------|-----------------|
| Base map tiles | Cached for viewed areas. Pre-download by country or region |
| Government advisories | Last-fetched data stored locally. Shows "Last updated: X hours ago" |
| Conflict events | Cached. Shows "Last synced: X" |
| Disaster alerts | Cached. Shows "Last synced: X" |
| Country detail | Full advisory text cached offline |
| Event pins | All metadata cached, including descriptions |
| Push notifications | Not in v1 (no accounts) |

**Staleness indicators:**
- Data older than 24h: Yellow warning banner "Data may be outdated. Connect to update"
- Data older than 7 days: Red warning + prompt to connect
- Never fetched: "Connect to load data"

### 3.6 No Authentication / No Accounts

- The app works with zero sign-up
- No personal data collected
- No telemetry
- Optional: user can save favorite countries (stored locally only)
- Optional: user can set default home country for automatic advisory check

### 3.7 Multi-Language
- At launch: English + French + Spanish (covering most travelers)
- Architecture supports locale-based string files for easy community contribution
- Advisory text displayed in original language (government issue) with machine-translation option

### 3.8 Low-End Device Support
- Minimum Android 8.0 / iOS 14
- App size target: under 30 MB (map tiles not bundled — downloaded on demand)
- Optional: "Lite mode" with lower-resolution map tiles + text-only advisories (no map)

---

## 4. Non-Functional Requirements

| Requirement | Target |
|------------|--------|
| **First load time** | Under 5 seconds (cold start, no cached data) |
| **Offline startup** | Instant — app opens immediately with last cached data |
| **Map tile loading** | Smooth at zoom levels 3-12. Clustering at medium zoom |
| **Data refresh** | Advisory data: on foreground + manual. Events: on foreground + manual |
| **Battery impact** | No background polling. Only fetches when user opens app or manually refreshes |
| **Data usage** | Advisory data per full refresh: ~50 KB (all countries). Events: ~200-500 KB per region. Map tiles: standard tile usage |
| **Storage** | Base app: <30 MB. Map cache + data: user-managed, cleanable from settings |
| **Accessibility** | Support screen readers, minimum tap target 44px, sufficient color contrast |

---

## 5. Data Architecture

### 5.1 Data Flow

```
Government APIs / RSS            Sync Engine (on-device)         Local Storage
─────────────────────           ─────────────────────           ─────────────
US State Dept API ──┐
UK FCDO API ────────┤
Canada GAC ─────────┤──►  Background fetch when online ──►  SQLite database
France ═══ RSS ─────┤         (on app open + manual)            + tile cache
Australia ═══ RSS ──┤
Germany ═══ RSS ────┤
                    │
ACLED API ──────────┤
GDACS RSS ──────────┘
```

- **No backend server** in v1. The mobile app fetches directly from public APIs
- Data is parsed, normalized, and stored in local SQLite
- Map tiles cached via tile store (e.g. TileCache or similar library)
- On each app foreground, check if data is stale (>1h) and auto-refresh if online

### 5.2 Data Model (Simplified)

**CountryAdvisory:**
- country_code (ISO 3166-1 alpha-2)
- source (e.g. "state_dept", "fco", "canada")
- advisory_level (1-4 or equivalent)
- risk_factors (JSON array: crime, terrorism, kidnapping, civil unrest, health, etc.)
- full_text (HTML or markdown)
- last_updated (ISO 8601)
- source_url

**ConflictEvent:**
- event_id (from ACLED or internal)
- event_type (battle, explosion, violence_civilians, riot, protest, strategic)
- date
- country_code
- location_name
- latitude
- longitude
- fatalities
- actors (JSON)
- description
- source

**DisasterEvent:**
- event_id (from GDACS)
- disaster_type (earthquake, cyclone, flood, wildfire, volcano, drought)
- alert_level (green, orange, red)
- date
- country_code
- latitude
- longitude
- radius_km (affected area)
- description
- source_url

---

## 6. API Integration Details (per source)

| Source | Endpoint | Auth | Rate Limit | Parsing |
|--------|----------|------|-----------|---------|
| US State Dept | `GET https://cadataapi.state.gov/api/CountryTravelInformation/{tag}` | None | Unknown | JSON → advisory level + risk factors |
| US State Dept (RSS) | `GET https://travel.state.gov/_res/rss/TravelAdvisories.xml` | None | Unknown | XML → title + level + country tag |
| UK FCDO | `GET https://www.gov.uk/api/content/foreign-travel-advice/{country}` | None | Standard gov.uk | JSON → alerts + full text |
| Canada GAC | `GET https://travel.gc.ca/travelling/advisories/api/{country}` | None | Unknown | JSON → advisory level + text |
| ACLED | `GET https://api.acleddata.com/acled/read` | API key required | 1 req/s | JSON → event list |
| GDACS | `GET https://www.gdacs.org/xml/rss.xml` | None | Unknown | RSS XML with geo tags |

---

## 7. Technical Stack (Spec)

| Component | Technology | Reasoning |
|-----------|-----------|-----------|
| **Cross-platform** | Flutter | Single codebase for iOS + Android. Good map support (flutter_map + OpenStreetMap). Good offline support. |
| **Map renderer** | flutter_map (OpenStreetMap) | Lighter than Google Maps. No API key needed. Works offline. Supports tile caching. |
| **Local storage** | SQLite (drift/sqflite) | Structured data for advisories + events. Well-tested offline. |
| **Tile cache** | flutter_map_tile_caching | Cache map tiles for offline use. |
| **HTTP client** | dio + caching interceptor | Cache responses to minimize requests. |
| **State management** | Riverpod or BLoC | Predictable, testable. |
| **Background fetch** | workmanager | Periodic data refresh when app is backgrounded. |
| **RSS parsing** | xml + feed parser | Parse GDACS + FCDO RSS feeds. |
| **i18n** | Flutter's native i18n + ARB files | Standard multi-language approach. |

---

## 8. Out of Scope (v1)

- User accounts / authentication
- Incident reporting / submission
- Risk register / ISO 31000 features
- Team sync or sharing
- Push notifications
- Web dashboard
- Crowdsourced data
- Location tracking / check-in
- Photo/video evidence
- Security rules library
- QR patrol / checkpoints
- Any server infrastructure
- AI features

---

## 9. Roadmap (Post-v1)

| Phase | Features | Target User |
|-------|----------|-------------|
| **v2** | Personal incident log + basic risk journal. Save favorite locations. Audio notes. | Solo traveler → Freelancer |
| **v3** | Team sync (add sync server). Basic incident sharing. Push alerts. | NGO small team |
| **v4** | Web dashboard. Staff map. Risk register (ISO 31000). | Security manager |
| **v5** | Institutional features: check-in/out, alert broadcast, QR patrol, security rules, full RBAC | Large NGO |
| **v6** | Self-hosted sync. Multi-framework support. API. White-label. Analytics. | Enterprise |

---

## 10. Design Decisions (Final)

These questions were resolved on 2026-07-04:

### 10.1 Map Tile Provider
- **Decision:** OpenStreetMap standard tiles as default, with architecture supporting multiple styles (topographic, terrain, etc.)
- **Future:** Thunderforest and Mapbox as optional providers
- **Reasoning:** Zero cost, no API key, privacy-respecting. Topographic styles available via OSM variants.

### 10.2 ACLED API Key Strategy
- **Decision:** Embed a single API key in the open-source app for initial use
- **Also include:** GDELT as an additional conflict/event data source (no key needed, free BigQuery access)
- **Fallback:** If rate-limited, document how users can get their own ACLED key
- **Reasoning:** Minimizes friction for first-time users. GDELT provides complementary coverage.

### 10.3 Initial Map View
- **Decision:** World map (zoom level ~3) on launch
- **Controls:** Standard map interaction (pinch-zoom, pan) + country search dropdown + "zoom to my location" button (GPS, opt-in)
- **Future:** Remember last-viewed region per device (local storage only)

### 10.4 Government Advisory Sources (v1)
- **Decision:** ALL available sources at launch:
  1. US State Department (API + RSS)
  2. UK FCDO (gov.uk content API)
  3. Canada GAC (Travel advisories API)
  4. France Diplomatie (RSS/web)
  5. Australia DFAT (Smartraveller)
  6. Germany AA (RSS/web)
- **Priority:** These 6 confirmed for v1. Any additional sources added as discovered.
- **User control:** Individual layers can be toggled on/off. Consolidated view is the default.
- **Reasoning:** This aggregation is the core value proposition for solo travelers.

### 10.5 Bundled vs Fetched Data
- **Bundled in app:** Country metadata (ISO codes, names, approximate border polygons, flag emoji references)
- **Fetched on first connect:** All advisory data, conflict events, disaster alerts
- **Cached locally:** Everything fetched is stored in SQLite + tile cache for offline use
- **Staleness:** Show "Last updated: X" per layer. Warning banners at 24h (yellow) and 7 days (red)

### 10.6 License
- **Decision:** AGPL v3+ (strong copyleft)
- **Reasoning:** Ensures the project remains free and open. Anyone using it as a service must release their changes.

