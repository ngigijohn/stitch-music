# Parallel Agent Workflow

## Goal
Enable up to 5 concurrent agents without merge conflicts.

---

## 🌿 Branch Layout

```mermaid
gitGraph
    commit id: "initial setup"
    branch sprint/current
    checkout sprint/current
    commit id: "sprint baseline"
    branch agent/a-playback
    branch agent/b-persistence
    branch agent/c-library-diagnostics
    branch agent/d-playlists
    branch agent/e-qa
    checkout agent/a-playback
    commit id: "playback polish"
    checkout agent/b-persistence
    commit id: "persistence layer"
    checkout agent/c-library-diagnostics
    commit id: "library diagnostics"
    checkout agent/d-playlists
    commit id: "playlist MVP"
    checkout agent/e-qa
    commit id: "tests & CI gates"
    checkout sprint/current
    merge agent/a-playback id: "merge A"
    merge agent/b-persistence id: "merge B"
    merge agent/c-library-diagnostics id: "merge C"
    merge agent/d-playlists id: "merge D"
    merge agent/e-qa id: "merge E"
    checkout main
    merge sprint/current id: "sprint release"
```

---

## 👥 Assignment Matrix

| Agent | Branch | Workstream |
|-------|--------|------------|
| 🎵 Agent A | `agent/a-playback` | Playback polish and runtime stability |
| 💾 Agent B | `agent/b-persistence` | Persistence and resume state |
| 🔍 Agent C | `agent/c-library-diagnostics` | Library diagnostics and permission UX |
| 🎶 Agent D | `agent/d-playlists` | Playlist MVP |
| 🧪 Agent E | `agent/e-qa` | Tests, CI checks, and release gates |

---

## 🔗 Merge Dependency Chain

```mermaid
flowchart LR
    A[Agent A\nPlayback Engine] --> B[Agent B\nPersistence]
    B --> C[Agent C\nLibrary Diagnostics]
    B --> D[Agent D\nPlaylist MVP]
    C --> E[Agent E\nTests & CI]
    D --> E
    E --> R[sprint/current\nRelease]
    R --> M[main]

    style A fill:#7C4DFF,color:#fff
    style B fill:#7C4DFF,color:#fff
    style C fill:#5C35CC,color:#fff
    style D fill:#5C35CC,color:#fff
    style E fill:#3D1FA3,color:#fff
    style R fill:#DACDFF,color:#120B1A
    style M fill:#120B1A,color:#DACDFF
```

---

## 📋 Rules

1. One workstream per branch.
2. Rebase daily on `sprint/current`.
3. PR target is `sprint/current`, not `main`.
4. Keep PRs small, under 400 lines when possible.
5. Must pass `flutter analyze` and `flutter test` before review.

---

## 🕐 Daily Sync

1. 10-minute standup
2. Update blockers and ownership
3. Merge order based on dependency chain:
   1. Core services (Agent A)
   2. Persistence (Agent B)
   3. UI integration (Agents C & D)
   4. Tests (Agent E)

---

## ⚡ Fast Conflict Protocol

1. Owner of the conflicting file resolves the merge.
2. If unresolved within 15 minutes, escalate to the lead branch owner.
3. Prefer additive changes and extension methods over deep rewrites.

---

## ✅ Definition of Done

| Criterion | Check |
|-----------|-------|
| CI green on PR | `flutter analyze` + `flutter test` pass |
| Manual Android smoke test complete | Device or emulator verified |
| Acceptance criteria in issue checked | All issue checkboxes ticked |
| No analyzer warnings | Zero `flutter analyze` warnings |
