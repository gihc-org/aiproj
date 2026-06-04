# TODO

Mål: Et værktøj-neutralt workflow til at initialisere og vedligeholde projekter med
ADRs og guidelines, der fungerer ens på tværs af Claude Code, Aider, codex m.fl.

Baggrund: I `~/projects/ipfs-apps` blev guidelines ikke fulgt. Løsningen blev en
Claude-hook, men det virker ikke for Aider/codex. Håndhævelsen skal flyttes ud af
agenten og ned i filsystem, git og CI.

## Nøgleindsigt fra `~/projects/yargent/referater/2026-05-27.md`

- **Passiv tekst i kontekst er ikke tilstrækkeligt.** TL;DR-tjekliste øverst i
  `testing-and-docs.md` havde ingen mærkbar effekt — DeepSeek ignorerede den alligevel.
- **Sproglige instruktioner i system-prompt virker heller ikke alene.** Instruktionen
  "walk every checklist item explicitly" blev ikke fulgt; modellen dykkede direkte ned
  i opgaven.
- **Modellen "glemmer" AGENTS.md midt i en session.** Den læses ved start, men er
  ude af fokus under selve implementeringen.
- **Strukturel håndhævelse er det mest lovende.** Yargents `diagnostic.rs` scanner
  diff'en før commit og spørger "commit anyway?" — det afbryder på det rigtige tidspunkt.
  Se `~/projects/yargent/src/diagnostic.rs` som reference-implementation.

**Konsekvens for dette projekt:**
- Lag 1 (AGENTS.md + `@`-includes) er **dokumentation**, ikke håndhævelse. Forvent ikke at
  det alene sikrer compliance.
- Al reel håndhævelse skal ligge i Lag 2 og Lag 3 — tooling der **afbryder og spørger**
  på nøglepunkter (før commit, efter implementering).
- Token-problemet ("for tungt at inkludere alt") løses af frontmatter + selector-script:
  inkludér kun relevante guidelines. Men det løser ikke "glemt midt i session" — dét
  kræver aktiv kørsel af `check.sh` ved nøglepunkter.

## 1. Designe det neutrale workflow

- [x] Beslut tre-lags-modellen konkret:
  - [x] Lag 1 — agenten ser reglerne via `AGENTS.md` + `@`-includes (eksisterer)
  - [x] Lag 2 — raw `.git/hooks/pre-commit` der kalder `scripts/check.sh`
  - [x] Lag 3 — `scripts/check.sh` kørbart af både agent og menneske
- [ ] Definér YAML-frontmatter-format til guidelines og ADRs (`applies_when:`, `tags:`, `status:`)
- [ ] Beslut hvordan "potentielt relevant senere" markeres i AGENTS.md (én sektion vs. tags vs. frontmatter)
- [ ] Skriv designet ned som ny guideline i `~/projects/guidelines/` (f.eks. `tool-neutral-enforcement.md`)

## 2. Frontmatter + selector-script

- [ ] Tilføj YAML-frontmatter til alle eksisterende guidelines i `~/projects/guidelines/`
- [ ] Tilføj YAML-frontmatter til alle eksisterende ADRs i `~/projects/adrs/`
- [ ] Skriv `scripts/select-guidelines.sh` der ved projekt-init filtrerer baseret på tags
- [ ] Udvid `~/projects/guidelines/new-project-setup.sh` til at bruge selector-scriptet
- [ ] Test på et nyt tomt projekt

## 3. Gennemgå og generalisere

Gennemgå hver fil. For hver: hvad er projekt-specifikt (skal ud eller flyttes til et
projekts `./kontekst/`), og hvad er det generelle mønster (bliver tilbage)?

- [ ] `guidelines/security.md`
- [ ] `guidelines/rust-axum.md`
- [ ] `guidelines/webrtc.md`
- [ ] `guidelines/web-frontend.md`
- [ ] `guidelines/testing-and-docs.md`
- [ ] `guidelines/process.md`
- [ ] `guidelines/knowledge-management.md`
- [ ] `guidelines/claude-code.md` — overvej at omdøbe/erstatte med `tool-neutral-enforcement.md`
- [ ] `guidelines/ansible-deploy.md`
- [ ] Gennemgå alle ADRs `0001`–`0023` for projektspecifikke detaljer
- [ ] Opdatér `~/projects/adrs/README.md` og `~/projects/guidelines/README.md` hvis filer ændres

## 4. Bygge selve håndhævelsen

- [x] Lav skabelon til `scripts/check.sh` — semantisk LLM-review af staged diff mod AGENTS.md @-includes
- [x] Lav `scripts/install-hooks.sh` der kopierer check.sh og installerer pre-commit hook i målprojekt
- [x] Besluttet: håndhævelse via LLM-review, ikke syntaktiske checks — sprog-agnostisk og semantisk forbundet til ADR-teksten
- [x] Dokumenteret: syntaktiske checks (lint, grep) kan ikke håndhæve ADR-intent; kun LLM-review kan det
- [x] Test på `ipfs-apps` — hook kørte, Claude fandt reelle concerns, false positive håndteret via guideline-opdatering

## 5. Migrering af eksisterende projekter

- [x] `scripts/install-hooks.sh` fungerer som migrations-værktøj til eksisterende projekter
- [x] Migrér `ipfs-apps` som første test ✅ 2026-06-04
- [ ] Migrér resten af projekterne efterhånden
