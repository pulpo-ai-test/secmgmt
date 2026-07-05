# SecMgmt App — Product Vision & Brainstorm

**Status:** Draft | **Date:** 2026-07-04 | **Confidential — Local Only**

---

## 1. Core Vision (One-sentence)

A multi-tier security awareness and risk management platform — from solo traveler to global NGO — that combines **ISO 31000 risk management**, **real-time collaborative field intelligence**, **multi-source threat mapping**, and **offline-first privacy**, all in one unified system.

---

## 2. User Personas

### P1 — Adventure Traveler
- *Who:* Backpacker, digital nomad, tourist going somewhere non-trivial
- *Problem:* Embassy advisories are scattered across sites, travel forums are noise, no single source of truth
- *Wants:* One app that aggregates every embassy warning into a coherent risk picture. Color-coded country/region map. Know *why* an area is risky before they book
- *ISO knowledge:* Zero. Needs the simplified version
- *Tech:* Mobile-only, probably never opens web
- *Budget:* Free / very cheap

### P2 — Freelancer / Contractor
- *Who:* Journalist, engineer, consultant deployed by an org that has no security infrastructure. They carry the risk themselves
- *Problem:* No institutional support. No shared context. Often have less intel than the NGOs working nearby
- *Wants:* Risk map. Incident feed from open sources. Ability to report their own location/status. A personal risk register to track the hazards around their assignment
- *ISO knowledge:* Some — may have had a briefing
- *Tech:* Mobile-primary, may use web for planning
- *Budget:* Freemium / basic subscription

### P3 — Fixer (Local Partner)
- *Who:* National staff who works with internationals. Driver, interpreter, logistics
- *Problem:* Often the most exposed, yet has least access to security tools. May have older phones, limited data
- *Wants:* Lightweight mobile app. Receive alerts. Report what they see. Share their GPS location periodically for safety checks
- *ISO knowledge:* Little — needs the simplest possible UI
- *Tech:* Mobile only, low-end device, intermittent connectivity
- *Budget:* Free (covered by institutional user)

### P4 — NGO Field Staff
- *Who:* Works for a large humanitarian org. Follows the security rules. Reports incidents. Expects the institution to protect them
- *Problem:* Current tools are fragmented — incident reporting in one system, risk register in another, maps in a third. Or worse, paper + WhatsApp
- *Wants:* Unified mobile app. Check in/out. Report incidents with photo/GPS. See the risk map. Receive institutional alerts. Offline mode critical
- *ISO knowledge:* May have been trained. Follows SOPs
- *Tech:* Mobile primarily; uses web occasionally
- *Budget:* Covered by institution

### P5 — NGO Security Manager / Focal Point
- *Who:* The person responsible for everyone's safety in a country or region
- *Problem:* Needs a command view. Where are my people? What incidents happened today? Are the risk assessments up to date? Are the teams following the rules?
- *Wants:* Web dashboard with map showing all staff locations. Incident heatmap. Risk register dashboard. Ability to broadcast alerts. Review field reports. Generate statistics for HQ
- *ISO knowledge:* Deep. May be involved in risk assessment methodology
- *Tech:* Web-primary, mobile for urgent responses
- *Budget:* Institutional (part of program budget)

### P6 — HQ Security Director
- *Who:* Oversees global security across multiple countries/regions
- *Wants:* Cross-country dashboard. Trends and analytics. Compliance with security frameworks. Incident statistics. Assurance that all field teams use the system
- *ISO knowledge:* Deep. May drive ISO 31000 compliance
- *Tech:* Web
- *Budget:* Institutional

### P7 — Travel Agency / Small Security Company
- *Who:* Sells travel or provides security services to corporate clients
- *Wants:* White-label or branded version? Or at least the ability to manage clients' travelers. Dashboard with their clients' status. Push alerts to their group. Sell "security monitoring" as a service
- *ISO knowledge:* Variable
- *Tech:* Web + mobile
- *Budget:* B2B subscription

---

## 3. Architecture (Three-Tier)

```
┌─────────────────────────────────────────────────────────────────┐
│                     WEB DASHBOARD                                │
│  Command view  •  Risk map full  •  Analytics  •  Team mgmt     │
│  User admin  •  Alert broadcast  •  Report exports              │
└──────────────────────────┬──────────────────────────────────────┘
                           │ HTTPS / WebSocket
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                    SYNC SERVER (self-hostable)                   │
│  Auth  •  Data sync (CRDT/offline-first)  •  Push relay         │
│  Open-source data aggregation  •  File/photo storage            │
│  Docker container — PostgreSQL — optional cloud relay           │
└─────────────────────┬──────────────────────┬────────────────────┘
                      │ HTTPS+WebSocket      │ HTTPS+WebSocket
                      ▼                      ▼
┌──────────────────────────────┐  ┌──────────────────────────────┐
│    MOBILE APP (iOS/Android)  │  │    MOBILE APP (iOS/Android)  │
│  — Field interface           │  │  — Field interface           │
│  — Offline-first             │  │  — Offline-first             │
│  — Risk map + layers         │  │  — Risk map + layers         │
│  — Incident reporting        │  │  — Incident reporting        │
│  — Check-in/check-out        │  │  — Check-in/check-out        │
│  — Alerts                    │  │  — Alerts                    │
└──────────────────────────────┘  └──────────────────────────────┘
   Team A (Syria field)              Team B (Syria field)
```

**Key architectural principles:**
- **Offline-first**: Every action works without a network. Sync is background and non-blocking
- **Self-hostable sync**: Org runs its own Docker server. No third party required
- **End-to-end encryption** for sensitive incident data (optional for open-source layers)
- **Progressive**: Solo tier needs zero server. Team tier adds optional server

---

## 4. Data Sources (Map Layers)

This is the secret sauce — no existing app aggregates all of these:

### Government Travel Advisories
| Source | Data | Access |
|--------|------|--------|
| **US State Dept** | Country/region advisory level (1-4) + risk factors (crime, terrorism, kidnapping, civil unrest, health) | Free REST API (cadataapi.state.gov) + RSS |
| **UK FCDO** | Country travel advice with risk text | Free web (gov.uk) — parsable |
| **Canada (GAC)** | Country travel advisories | Public API |
| **France (France Diplomatie)** | Conseils aux voyageurs | Web — parsable |
| **Australia (DFAT)** | Smartraveller | Web — parsable |
| **Germany (AA)** | Reise- und Sicherheitshinweise | Web — parsable |

*Vision: One app, all embassies, unified view. User sees ALL warnings for their destination.*

### Conflict & Political Violence
| Source | Data | Access |
|--------|------|--------|
| **ACLED** | Political violence events (battles, explosions, violence against civilians, riots, protests) with GPS, date, fatalities | Free API (with registration) |
| **GDELT** | Global event database — news-derived events with geo-coordinates | Free Google BigQuery + API |

### Natural Disasters
| Source | Data | Access |
|--------|------|--------|
| **GDACS** | Earthquakes, cyclones, floods, volcanoes, droughts — with green/orange/red impact level + affected areas | Free API + RSS + GeoJSON |

### Humanitarian / NGO Incidents (Open)
| Source | Data | Access |
|--------|------|--------|
| **INSO / CHDC** | Security incidents affecting humanitarian sector — aggregated trends | Humanitarian Dashboard (public) + HDX |

### User-Reported (Crowdsourced / Institutional)
| Source | Data | Privacy |
|--------|------|---------|
| **Institutional** | Internal security incidents from the organization's own reporting | Private — only visible within org |
| **Crowdsourced** | "Did you experience X here?" — anonymized if user chooses | Opt-in, aggregated |

**Map display concept:**
- OpenStreetMap as base
- Toggleable layers (checkbox list):
  - Risk zones (color polygons based on institutional rules OR aggregated from travel advisories)
  - Conflict events (clustered pin map — red=violence, orange=protest, etc.)
  - Natural disasters (GDACS icons/overlays)
  - Travel advisories (per-country color wash)
  - Institutional incidents (private pins)
  - Crowdsourced (anonymized aggregated heatmap)

---

## 5. Feature Matrix by Tier

| Feature | Solo (Free) | Team (Paid) | Enterprise (Self-host) |
|---------|:-:|:-:|:-:|
| **Risk Register** (ISO 31000) | Basic (1 register, 30 risks) | Full | Full + multi-framework |
| **Risk Matrix (5x5 configurable)** | ✓ | ✓ | ✓ |
| **Incident Reporting** | Personal only | Team sharing + workflow | Same + API |
| **Photo/Video/Audio Evidence** | ✓ | ✓ | ✓ |
| **Risk Map** | Open layers only | Open + institutional | All layers |
| **Travel Advisory Aggregator** | ✓ | ✓ | ✓ |
| **Offline-First** | ✓ | ✓ | ✓ |
| **Team Sync** | — | ✓ | ✓ |
| **Team Chat / Status** | — | ✓ | ✓ |
| **Push Alerts (institutional)** | — | ✓ | ✓ |
| **Push Alerts (global/Public)** | ✓ opt-in | ✓ | ✓ |
| **Web Dashboard** | — | ✓ | ✓ |
| **Map: Staff Tracking (opt-in)** | — | ✓ | ✓ |
| **Map: Incident Heatmap** | — | ✓ | ✓ |
| **Security Rules Library** | Basic (read) | Full (create + share) | Full |
| **QR Patrol / Checkpoints** | — | ✓ | ✓ |
| **Check-in / Check-out** | Basic (manual) | Automated + alerts | Automated |
| **Analytics / Reporting** | — | ✓ | ✓ |
| **Multi-Framework** | ISO 31000 only | ISO 31000 + NIST RMF + custom | All |
| **Self-Hosted Sync Server** | — | — | ✓ |
| **API Access** | — | — | ✓ |
| **Export (PDF, CSV, GeoJSON)** | CSV only | Full | Full + automation |
| **White-Label** | — | — | ✓ |
| **User Management (RBAC)** | — | Basic (admin/member) | Full (field/supervisor/admin/auditor) |

---

## 6. Mobile App Features (Detailed)

### Core Module (All users)
- **Dashboard**: Current location risk level, last sync time, pending actions, recent alerts
- **Risk Register**: Create/edit/delete risks. Fields: Title, description, category, likelihood (1-5), consequence (1-5), risk score (auto-calc), owner, treatment plan, status, review date
- **Risk Matrix**: Visual 5x5 grid with your risks plotted. Filter by category/owner/status
- **Incident Log**: Quick + full reporting. Quick = category + photo + GPS. Full = all fields + witnesses + follow-up action
- **Map**: OpenStreetMap with toggleable layers. Zoom, tap on pins for detail, filter by date/type/severity
- **Travel Advisories**: Combined feed from all government sources. Filter by country
- **Alerts**: Inbox for push notifications
- **Settings**: Profile, offline mode, sync preferences, notification preferences

### Solo Tier Extras
- Personal risk journal (private)
- Simple travel checklist (pre-departure, on-arrival, daily)

### Team Tier Extras
- **Team Workspace**: Shared risk register, shared incident log
- **Check-in/out**: "I'm starting my field day" / "I'm back" — with automatic escalation if overdue
- **Staff Map**: See team members' last known locations (opt-in)
- **Status Broadcast**: "All clear" / "Need support" buttons
- **Alert Broadcast**: Security manager can push to all team
- **Incident Workflow**: New → Acknowledged → Investigating → Closed

---

## 7. Web Dashboard Features (Team+ Tiers)

- **Full Map**: All layers + team locations + incident heatmap + zone management
- **Risk Register Management**: Full CRUD, bulk operations, review scheduling
- **Incident Console**: Real-time feed, filtering, assignment, workflow
- **Team Management**: Invite/remove users, roles, permissions
- **Zone Management**: Draw polygons on map, assign risk level + explanation
- **Alert Center**: Compose + broadcast alerts. History of sent alerts
- **Analytics**: Incident trends over time. Risk register health. Team compliance (check-in rate)
- **Reports**: Generate PDF/CSV/GeoJSON exports. Scheduled reports
- **Settings**: Organization profile, framework config, sync server config

---

## 8. Data Flow Example

**Scenario: Robbery in Homs, Syria**

1. **Field staff (NGO)** experiences robbery. Opens mobile app → taps "Report Incident" → selects "Armed Robbery" → adds brief description → snaps photo of broken door → GPS auto-attaches → saves (written to local SQLite immediately)
2. **Sync** happens 3 minutes later when signal returns. Incident pushed to sync server.
3. **Security Manager** opens Web Dashboard → sees new pin on map in Homs → clicks to see full details → assigns "High" severity → adds note: "Inform all Syria teams"
4. **Push alert** sent to all Team B users: "Security Alert: Armed robbery reported near Old City, Homs. Avoid area until further notice."
5. **Team B members** see the alert + map pin on their mobile apps (including those who were offline — they get it next sync)
6. **Risk register** updated automatically: related risk "Theft in field" gets an updated frequency count and may trigger a review

---

## 9. Open Questions for Discussion

These are the decision points I'd like to get your input on:

### A. Scope & First Iteration
What's the **minimum viable** version that's still useful? I see three options:
1. **Map + open data only** — risk map with government advisories + ACLED/GDACS. No risk register, no incident reporting. Useful for travelers. Quick to build
2. **Map + incident reporting + team sync** — the core NGO use case. Risk map + incident log + team sharing. No formal ISO 31000 register yet
3. **Full package** — everything including risk register, matrix, workflows. Most complete but longest build

Which feels right for v1?

### B. Risk Zone Methodology
How are risk zones defined? Two approaches:
- **Top-down**: Security manager draws polygons and assigns a level (like State Dept advisories)
- **Bottom-up**: Risk zones emerge from incident clustering + analysis (heatmap-driven)
Both are compatible, but which is primary?

### C. Privacy Model for Team Location Sharing
- Real-time GPS tracking (like Glympse — ephemeral, check-in duration)
- Periodic ping ("I checked in at 10:00, last known at [lat/lng]")
- Manual only ("I'm at this location now, click to share")
I'd recommend **manual check-in with automatic overdue escalation** — respects privacy while protecting the person

### D. Crowdsourcing Model
For non-institutional users, should we allow anonymous incident reporting? If someone reports "I was robbed at this location," should:
- It be immediately visible to all users?
- Visible only after moderator review?
- Visible only as aggregated heatmap (no exact location)?
Each has pros/cons regarding data quality, liability, and usefulness

### E. Language & Accessibility
Given the fixer persona (P3) and global context:
- How many languages at launch?
- Should the UI adapt to low-bandwidth / low-end devices?
- Audio notes as alternative to typing (for literacy considerations)?

### F. Revenue Model
If this ever becomes a product (vs internal tool):
- Paid by institutions (B2B), free for individuals? 
- Freemium with Solo tier free, Team tier subscription?
- Open-source core with paid hosted version?

---

## 10. Competitive Positioning (Updated)

With the collaborative + map layers angle, the differentiation becomes even clearer:

| Competitor | Our Unique Angle |
|-----------|-----------------|
| **SafetyCulture (iAuditor)** | Checklists, not risk management. No map layers. No team sync |
| **Rimini Risk Management** | Extremely basic. No maps. No team |
| **RiskNote** | iOS only. No maps. No open data layers |
| **Eramba / SimpleRisk** | Web-only. No mobile. No maps. No open data |
| **MetricStream / Riskonnect** | Enterprise web. $10k+. No offline. No traveler use case |
| **State Dept / FCDO websites** | Single-source. No aggregation. No incident reporting |
| **ACLED / GDACS** | Raw data, not an app. No risk register. No team |

**Nobody** combines: risk register + team sync + offline-first + multi-source map layers + travel advisory aggregation + field incident reporting + self-hostable.

That's the product.

---

*Draft product vision — 2026-07-04.*
*Next step: Discuss open questions, then produce detailed PRD.*
