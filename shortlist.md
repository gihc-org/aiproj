# Short-list: ADRs og Guidelines

Genereret 2026-05-28 via workflow-analyse af alle 23 ADRs og 9 guidelines-filer.
Mål: høj kodekvalitet, tests (unit/integration/e2e/OWASP), dokumentation, open source.

## ADRs

### Behold som er (2)

- **0005** (authenticate som plain async fn) — korrekt scoped til Rust 1.88-workaround. Tilføj mock-eksempel og revisionsmark for Axum 0.8+.
- **0008** (IPFS + DNSLink hosting) — passende projekt-specifik. Tilføj CORS-smoke-test og OWASP wildcard-note.

### Generaliser (16)

| ADR | Konkret ændring |
|-----|----------------|
| **0001** Axum vs Actix-web | Fjern `ipfs-apps/chat`-reference; tilføj testafsnit om extractor-model; flyt Rust 1.88-note til ADR-0005. |
| **0002** SQLx runtime API | Tilføj krav: alle query-kald skal have mindst én `#[sqlx::test]`-test; generaliser til "runtime vs. compile-time i Docker". |
| **0003** rustls | Løft til "TLS-backend i Rust+Docker"-guideline; tilføj `rustls-native-certs`-reference i konfigurationseksempel. |
| **0004** Lib+bin-split | Tilføj sprog-agnostisk princip øverst; nævn Flask app-factory, Go http.Handler som paralleller. |
| **0006** Broadcast channel | Tilføj concurrent integrationstest for `get_or_create_sender`; dokumentér `capacity=256` som konfigurérbar konstant; nævn OWASP WS-anbefalinger. |
| **0007** JWT via query-param | Log-sanitering ændres til "skal" + regex-spec; tilføj integrationstest for afvisning med 4001; nævn CWE-598. |
| **0009** Caddy reverse proxy | Flyt Axum/Ansible-detaljer til "Implementering"-afsnit; tilføj TLS+WS smoke-test i CI. |
| **0010** Ansible Caddyfile-templates | Fjern `gihc.online`/`chat:8001`; tilføj `caddy validate --config` i CI; nævn Caddy JSON-config som fravalgt alternativ. |
| **0011** Argon2id | Flyt Rust-kode til separat afsnit; dokumentér standardparametre med konkrete tal; tilføj unit-tests for verify+re-hash. |
| **0012** Tom env-var som feature flag | Tilføj startup-guard mod tomme sikkerhedskritiske vars i produktion; nævn `FEATURE_X_ENABLED=false` som alternativ. |
| **0013** OWASP som definition of done | Udskil stack-specifik tjekliste til `checklists/owasp-rust-axum-vanillajs.md`; tilføj OWASP ZAP i CI som anbefaling. |
| **0017** Ansible playbook-opdeling | Fjern IPFS/Woodpecker til eksempelafsnit; tilføj check-task der verificerer Docker er installeret. |
| **0018** WebRTC lydopkald | Tilføj tests-afsnit (unit: tilstandsmaskine, integration: signal-forwarding, e2e: Playwright); tilføj sikkerhedsafsnit om TURN-rotation og ICE-lækage. |
| **0019** Delt Caddy via conf.d | Fjern projekt-specifikke eksempler til appendiks; erstat e-mail med `{$ACME_EMAIL}`; tilføj `caddy validate` i CI. |
| **0020** SQLite vs PostgreSQL | Løft princippet til generel regel; tilføj afsnit om `sqlite::memory:` til hurtige integrationstests. |
| **0021** Adjacency list + edges-tabel | Gør mønster sprog-neutralt; tilføj tests for `kind`-validering og CASCADE-adfærd. |
| **0022** API-nøgle til enkeltbruger-apps | Udskil stack-detaljer; tilføj OWASP ASVS L2-advarsel om localStorage; afgræns til single-tenant/intern brug. |
| **0023** RS256 vs HS256 | Flyt Rust-kode til bilag; erstat `sso.gihc.online` med pladsholder; tilføj JWKS-integrationstest og note om ES256. |

### Split i to (3)

| ADR | Split |
|-----|-------|
| **0014** GDPR + CIS Docker | → 0014a: Generelle GDPR-principper. → 0014b: CIS Docker Benchmark med genanvendelige yaml-snippets. |
| **0015** GDPR-sletning + smoke test | → 0015a: Generel GDPR-sletningsstrategi (cascade vs. eksplicit, test-krav). → 0015b: Projekt-specifik smoke-test-impl. |
| **0016** WebRTC skærmdelings-signalering | → 0016a: Generelt mønster for WebRTC-signalering over WS. → 0016b: Projekt-specifik impl (chat.rs, chat.html, Ansible). |

---

## Guidelines

### Eksisterende filer — vurdering

De nuværende filer (`security.md`, `rust-axum.md`, `webrtc.md`, `web-frontend.md`,
`testing-and-docs.md`, `process.md`, `knowledge-management.md`, `claude-code.md`,
`ansible-deploy.md`) er teknologi-specifikke. De **generelle lag mangler**.

### Mangler — skal oprettes

| Fil | Prioritet |
|-----|-----------|
| `testing-strategy.md` — unit/integration/e2e-grænser, dækningskrav, mocking-principper | **Kritisk** |
| `open-source.md` — licens, CONTRIBUTING.md, CHANGELOG, CoC, README-skabelon | **Kritisk** |
| `ci-cd.md` — obligatoriske checks: tests, lint, OWASP ZAP, `cargo audit`, `caddy validate` | Høj |
| `documentation.md` — hvad dokumenteres, hvor og hvornår | Høj |
| `code-review.md` — PR-størrelse, approval-krav, definition of done | Middel |
| `versioning.md` — SemVer vs. CalVer, tagging-praksis, release-noter | Middel |

### Manglende ADRs

- Generel logging-strategi (hvad logges, log-sanitering, struktureret vs. fritekst)
- Secrets management (vault, env-vars, rotation — nu spredt over ADR-0010/0012/0022)
- Fejlhåndtering og HTTP-statuskoder
- Database-migrations-strategi
- Observability/monitoring (metrics, health endpoints, alerting)

---

## Prioriteret handlingsliste

1. ~~**Opret `testing-strategy.md`**~~ ✅ oprettet 2026-05-28
2. ~~**Split ADR-0014 og 0015**~~ ✅ oprettet 2026-05-28 → 0014, 0015, 0024, 0025
3. ~~**Opret `open-source.md`**~~ ✅ oprettet 2026-05-28
4. ~~**Testkrav ind i ADR-0002, 0006, 0007, 0011**~~ ✅ oprettet 2026-05-28
5. ~~**Opret `ci-cd.md`**~~ ✅ oprettet 2026-05-28
6. ~~**Generaliser ADR-0001, 0004, 0017**~~ ✅ oprettet 2026-05-28
7. ~~**Ny logging + secrets ADR**~~ ✅ ADR-0026 oprettet 2026-05-28
