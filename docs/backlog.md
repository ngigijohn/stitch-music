# Product Backlog

## 📊 Project Status Overview

| Phase | Status | Items |
|-------|--------|-------|
| ✅ Foundation | Complete | 7 |
| 🔄 Core Engine | In Progress | 2 of 4 done |
| 🔜 Next Up | Queued | 4 |
| 🔍 Discovery | Under Evaluation | 1 |
| 🌐 Future | Planned | 3 |

---

## 🗺️ Visual Roadmap

```mermaid
gantt
    title Stitch Music — Implementation Roadmap
    dateFormat  YYYY-MM-DD
    excludes    weekends

    section 🏗️ Foundation
    App scaffold & navigation        :done,    f1, 2026-01-05, 10d
    Design system & theme            :done,    f2, 2026-01-05, 10d
    Home screen (discovery feed)     :done,    f3, 2026-01-12, 8d
    Now playing screen               :done,    f4, 2026-01-18, 8d
    Queue management                 :done,    f5, 2026-01-24, 6d
    Library / search screen          :done,    f6, 2026-01-28, 7d
    Profile screen stub              :done,    f7, 2026-02-03, 3d

    section ⚙️ Core Engine
    Playback engine (just_audio)     :done,    c1, 2026-01-20, 10d
    Android MediaStore integration   :done,    c2, 2026-01-28, 10d
    Playback auto-advance            :active,  c3, 2026-03-10, 10d
    Session resume on restart        :active,  c4, 2026-03-14, 10d

    section 💾 Persistence
    Queue persistence & restore      :         p1, 2026-03-24, 8d
    Favorites & recents              :         p2, 2026-03-28, 8d

    section 🎵 Features
    Library diagnostics panel        :active,  feat1, 2026-03-10, 14d
    Playlist MVP                     :         feat2, 2026-04-01, 14d
    YouTube streaming (discovery)    :crit,    feat3, 2026-03-21, 21d

    section 🧪 Quality
    Test backlog implementation      :         q1, 2026-04-07, 10d

    section 🌐 Future
    Artist & album detail pages      :         fut1, 2026-05-01, 14d
    Smart recommendations            :         fut2, 2026-05-12, 14d
    Offline cache manager            :         fut3, 2026-05-22, 14d
```

---

## ✅ Completed

| Feature | Description |
|---------|-------------|
| App scaffold & navigation | Bottom nav shell, tab routing, page transitions |
| Design system & theme | Material 3, glassmorphism, color tokens, typography |
| Home screen | Discovery feed: hero, recent plays, daily mixes, new releases |
| Now playing screen | Full player with animated album art, controls, progress bar |
| Queue management | Reorderable queue with drag handles and equalizer animation |
| Library / search screen | Filter chips, search bar, context menu, empty state |
| Playback engine | `just_audio` integration, Android MediaStore, permissions |

---

## 🔄 In Progress

| Feature | Agent | Notes |
|---------|-------|-------|
| Playback auto-advance & resume state | Agent A | Auto-advance wired; resume state in progress |
| Library diagnostics panel | Agent C | Permission UX flow in design |

---

## 🔜 Next Up

| Feature | Priority | Dependencies |
|---------|----------|--------------|
| Playlist MVP (create, rename, reorder, play) | 🔴 High | Persistence layer |
| Favorites & recents persistence | 🔴 High | `shared_preferences` |
| Queue persistence with restore | 🔴 High | Playback engine |
| Test backlog implementation | 🟡 Medium | All above features |

---

## 🔍 Discovery

### Stream Audio from YouTube

| Field | Value |
|-------|-------|
| **Status** | 🔍 Under Evaluation |
| **Priority** | 🔴 High |

**Scope:**

1. Evaluate legal and policy-compliant integration paths.
2. Confirm allowed use cases (user-authenticated streaming, licensed APIs).
3. Define architecture for remote stream source adapters.
4. Add UI entry points and playback queue integration.

> ⚠️ **Note:** Implementation must follow platform terms and copyright compliance. Avoid unlicensed extraction workflows.

---

## 🌐 Future

| Feature | Description | Depends On |
|---------|-------------|------------|
| 🎨 Artist & album detail pages | Deep-link pages with full discography | Playlist MVP |
| 🤖 Smart recommendations | Behavior-based local listening suggestions | Favorites & recents |
| 📥 Offline cache manager | Download & cache for permitted stream sources | YouTube discovery |
