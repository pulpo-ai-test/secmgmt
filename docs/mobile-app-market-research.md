# Mobile Security Management App — Market Research

**Date:** 2026-07-04
**Focus:** ISO 31000:2018 Risk Management aligned mobile apps
**Scope:** All pricing tiers (free, freemium, open-source, paid)
**Confidential — Local Only**

---

## 1. Executive Summary

The mobile app market for ISO 31000-aligned risk management is **fragmented and underserved**. The available tools split into six distinct categories, none of which fully address the need for a **mobile-first, offline-capable, ISO 31000:2018 risk management app** suitable for individual/small-team use at reasonable pricing.

A clear **gap exists** for a purpose-built mobile app that implements the full ISO 31000 risk management process (establish context → identify → analyze → evaluate → treat → monitor & review → communicate & consult) in an offline-first, privacy-respecting package.

---

## 2. Market Categories

### Category A: Enterprise GRC Platforms (Web-first, expensive)

| Product | Pricing | Mobile App | ISO 31000 | Offline | Notes |
|---------|---------|-----------|-----------|---------|-------|
| **MetricStream** | $$$$ Enterprise | Limited companion | Partial | No | Full ERM/GRC, web-first |
| **ServiceNow GRC** | $$$$ Enterprise | Approvals/notifications only | Partial | No | Heavy ITSM integration |
| **Workiva** | $$$$ Enterprise | Limited companion | Partial | No | Audit/compliance focus |
| **Riskonnect** | $$$ Enterprise | Mobile app exists | Partial | No | Listed as "mobile risk mgmt" but enterprise-priced |
| **LogicGate** | $$$ Enterprise | No dedicated app | Partial | No | Risk process automation |
| **OneTrust** | $$$ Enterprise | Limited companion | Partial | No | Multi-product privacy/GRC |
| **ZenGRC (RiskOptics)** | $$$ Enterprise | No dedicated app | Partial | No | Compliance automation |
| **Sprinto** | $$$ Enterprise | No dedicated app | No (ISO 27001) | No | Tech company GRC |
| **Resolver** | $$$ Enterprise | No dedicated app | Partial | No | Enterprise risk |
| **LogicManager** | $$$ Enterprise | No dedicated app | Partial | No | ERM with support focus |

**Verdict:** These are powerful but **overkill for individuals/small teams** — $10k+/yr pricing, cloud-only, web-first with mobile as an afterthought. No offline capability.

### Category B: Open-Source GRC/ISMS (Self-hosted web, zero mobile)

| Product | Stack | Mobile App | ISO 31000 | Offline | Notes |
|---------|-------|-----------|-----------|---------|-------|
| **Eramba** | PHP/MySQL | No | Partial (ISO 27001) | No | Free self-hosted. Incident module. No mobile. |
| **CISO Assistant** | Python/Django | No | Partial (Cyber) | No | Security-focused. No mobile. |
| **SimpleRisk** | PHP/MySQL | No (responsive web) | Partial | No | Free core. "Offline mode" = local web. |
| **verinice** | Java/Web | No | Partial (ISMS) | No | German origin. Desktop-heavy. |
| **OpenGRC** | Web | No | Partial | No | Self-hosted. Minimalist. |
| **Open Risk Register** | Web | No | Partial | No | Simple web tool. |
| **XORCISM** | Self-hosted | No | Partial | No | Free GRC platform. |

**Verdict:** These exist but are **web-only, no mobile apps**. They require a server to run and a browser to use. Not suitable for on-the-go field use or privacy-sensitive offline work.

### Category C: Mobile-First Inspection / EHS Apps (Narrow focus)

| Product | Pricing | Mobile App | ISO 31000 | Offline | Notes |
|---------|---------|-----------|-----------|---------|-------|
| **SafetyCulture (iAuditor)** | $24+/user/mo | iOS + Android | No (EHS) | Yes | Checklists/audits, not risk mgmt |
| **GoAudits** | Freemium | iOS + Android | No (EHS) | Yes | Inspections/corrective actions |
| **BasinCheck** | Flat team pricing | iOS + Android | No (EHS) | Yes | Safety audits, fast completion |
| **FindRisk** | Freemium | Android | No (OHS) | Yes | AI safety inspections, Fine-Kinney |
| **Evotix** | $$$ | iOS + Android | No (EHS) | Yes | EHS for high-risk environments |

**Verdict:** Excellent mobile apps, robust offline, but **not ISO 31000 risk management tools**. They're built for workplace safety inspections (checklists, hazard identification), not for managing a risk register, assessing likelihood/consequence, or tracking treatment plans per ISO 31000.

### Category D: Dedicated Risk Management Mobile Apps (The closest — but very limited)

| Product | Platform | Pricing | ISO 31000 | Offline | Key Features | Limitations |
|---------|----------|---------|-----------|---------|-------------|-------------|
| **Rimini Risk Management** | iOS + Android | Free | Yes (ISO 31000:2018) | Partial | Risk identification, analysis, Accident Triangle model | Very basic (~500 downloads). No risk register. No incident management. Swedish-only? Last updated 2024. |
| **RiskNote** | iOS only | Freemium (7-day trial) | Partial (project risk) | No | AI-powered risk registers, likelihood/consequence scoring | iOS only. Cloud-dependent. New/recent. AI + human review needed. |
| **Risk Register+** | iOS only | Paid (old) | No (project mgmt) | No | Risk register, probability/impact matrix, quadrant view | Last major update 2015. Abandoned? Project-focused. |
| **ISO 31000.net** | Android | Free | No (exam prep) | No | Practice exams for ISO 31000 certification | Not a management tool — test prep only. |

**Verdict:** These are the closest competitors but each has critical gaps. **Rimini** is the only genuine ISO 31000 mobile app but is too basic. **RiskNote** is promising but iOS-only, cloud-dependent, and very new.

### Category E: Project Management with Risk Module

| Product | Platform | Pricing | ISO 31000 | Notes |
|---------|----------|---------|-----------|-------|
| **nTask** | iOS + Android + Web | Freemium | No (project risk) | Has risk register + risk matrix module. But project-risk only. |
| **Jira** | Mobile companion | $$$ | No | Issue tracker with risk add-ons. |
| **Asana/ClickUp** | Mobile apps | Freemium | No | Generic PM, no risk framework. |

### Category F: Physical Security / Guard Management

| Product | Mobile | ISO 31000 | Notes |
|---------|--------|-----------|-------|
| TrackTik | Yes | No | Guard patrol, scheduling, incident reporting |
| GuardsPro | Yes | No | Tour scanning, incident logs |
| QR-Patrol | Yes | No | QR-based patrol tours, incident reports |
| THERMS | Yes | No | Guard tour, GPS tracking, dispatch |

**Verdict:** Entirely different domain (physical guard management, not risk management frameworks).

### Category G: Compliance Automation (SaaS)

| Product | Mobile | ISO 31000 | Pricing |
|---------|--------|-----------|---------|
| Vanta | Limited | No (SOC2/ISO 27001) | $$$$ |
| Drata | Limited | No (SOC2) | $$$$ |
| Sprinto | Limited | No (ISO 27001) | $$$$ |

---

## 3. Feature Landscape Matrix

### What exists vs. what's missing

| Feature | Enterprise GRC | Open-Source | EHS Apps | Rimini | RiskNote | Gap? |
|---------|---------------|-------------|----------|--------|----------|------|
| **Risk Register** | Yes | Yes | No | **No** | Yes | **Rimini lacks this** |
| **ISO 31000:2018 Process** | Partial | Partial | No | Yes | No | Full alignment needed |
| **Qualitative Risk Assessment** | Yes | Yes | No | Yes | Yes | Rimini basic |
| **5x5 / configurable matrix** | Yes | Yes | No | **No** | Yes | Rimini lacks |
| **Heat Maps / Visualizations** | Yes | Some | No | **No** | Some | Missing in mobile |
| **Incident Management** | Yes | Yes | Yes | **No** | No | Missing from mobile risk apps |
| **Action/Treatment Tracking** | Yes | Yes | Yes | **No** | Yes | Rimini lacks |
| **Offline-First** | No | No | Yes | Partial | No | **Major gap** |
| **Photo/Video Evidence** | No | No | Yes | **No** | No | Missing from risk apps |
| **Audit Trail** | Yes | Some | Yes | **No** | Yes | Rimini lacks |
| **Export/Reporting** | Yes | Yes | Yes | **No** | Yes | Rimini lacks |
| **Multi-Framework** | Yes | Yes | No | No | No | **Gap** |
| **Personal/Individual Pricing** | No | Yes (self-host) | Freemium | Free | Freemium | Only Rimini free |
| **Local/Private Storage** | No | Yes | Cloud | Cloud | Cloud | **Major gap** |
| **Cross-Platform (iOS+Android)** | Usually | N/A (web) | Yes | Yes | iOS only | RiskNote iOS-only |

---

## 4. Key Gap Analysis

After reviewing ~40 products across 7 categories, **three major gaps** are evident:

### Gap #1: No mobile app implements the full ISO 31000:2018 process

The standard defines a 7-step process:
1. **Establish context** (internal/external, risk criteria)
2. **Risk identification** (what could happen, where, when, how)
3. **Risk analysis** (understand nature, determine level: likelihood × consequence)
4. **Risk evaluation** (compare against criteria, prioritize)
5. **Risk treatment** (select options, plan implementation)
6. **Monitoring & review**
7. **Communication & consultation**

No single mobile app covers all 7 steps in a structured way.

### Gap #2: No mobile-first, offline-capable, privacy-focused risk management app exists

- Enterprise tools are cloud-only and expensive
- Open-source tools are web-only, requiring a server
- Rimini is mobile but cloud-dependent and extremely basic
- RiskNote is iOS-only and cloud-dependent

**A truly offline-first app** (data on device, optional encrypted sync) with confidentiality as a design principle has **zero competition**.

### Gap #3: No bridge between risk management and physical security

Apps doing guard patrol/incident reporting (Category F) don't talk to formal risk registers. Apps doing risk management (Categories A-B) don't connect to field incident data. A unified mobile app that connects **field incidents → risk register updates → treatment plan tracking** doesn't exist.

---

## 5. Recommended "Perfect Spec" Target

Based on the gaps above, the ideal app would combine:

### Core (ISO 31000:2018) Module
- Full risk register (ID, description, category, source, owner)
- Configurable likelihood & consequence scales (3x3, 5x5, custom)
- Risk matrix with automatic scoring and heat map visualization
- Inherent → residual risk tracking
- Treatment planning with options (avoid, reduce, transfer, accept)
- Review scheduling and escalation alerts

### Incident Management Module
- Log incidents with photo/video/audio evidence
- Link incidents to risk register entries
- Root cause analysis fields
- Corrective action tracking

### Framework Support Module
- ISO 31000:2018 (built-in)
- Optional mappings: ISO 27005, NIST RMF, COSO ERM, ISO 22301
- Custom framework builder

### Privacy & Offline Architecture
- **Offline-first**: SQLite/local database on device
- **Optional encrypted sync** (local network or user's own cloud)
- **No mandatory cloud account**
- **End-to-end encryption** for sync payloads
- **Local AI** (on-device) for risk description suggestions, not cloud-dependent

### Platform & Pricing
- iOS + Android (Flutter or React Native)
- **Freemium**: Free tier (1 risk register, 50 risks, basic reporting)
- **Pro tier**: Unlimited, multi-framework, advanced reporting, export
- **No enterprise per-seat pricing** — fixed app purchase or subscription

### User Types
- **Individual**: Security consultant, risk manager, student
- **Small team**: Shared risk register via sync
- **Enterprise**: Self-hosted sync server option

---

## 6. Competitive Positioning Map

```
                    Mobile-first
                        |
              Rimini ·  |  · (Your App — the target space)
              RiskNote  |
                        |
     Basic <------------|------------> Full-featured
       risk             |              risk mgmt
                        |
    SafetyCulture ·     |     · MetricStream
    GoAudits ·          |     · ServiceNow
    FindRisk ·          |     · Riskonnect
                        |
                    Web-first / Enterprise
```

The sweet spot is **Mobile-first + full ISO 31000 risk management** — a quadrant with essentially zero competition today.

---

## 7. Key Competitors to Watch

| Competitor | Threat Level | Why |
|------------|-------------|-----|
| **Rimini Risk Management** | Low | Very basic, stagnant development, minimal downloads |
| **RiskNote** | Medium | iOS-only, cloud, AI-dependent — but well-designed UX |
| **SafetyCulture (iAuditor)** | Medium | Massive user base, offline-first — could add risk module |
| **nTask** | Low-Medium | Has risk module, mobile app — but project-focused |
| **SimpleRisk** | Low | Web-only, no mobile plans evident |
| **Eramba** | Low | Web-only, PHP stack, no mobile interest |

---

*Research compiled 2026-07-04. This document is confidential and stored locally only.*
