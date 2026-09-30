# Project: Maestro Mobile Automation

Mobile E2E test framework using Maestro (YAML flows) for Android and iOS.

## Structure
- `flows/android/<feature>/<scenario>.yaml` and `flows/ios/<feature>/<scenario>.yaml`: runnable flows, one scenario per file, one folder per platform (app ids and selectors often differ)
- `flows/<platform>/config.yaml`: workspace config (recursive run, excluded tags)
- `subflows/<platform>/*.yaml`: reusable steps (login, navigation), never run on their own
- `scripts/run.sh`: local runner (loads `.env`, selects device, writes JUnit report to `reports/`)
- `.env`: `PLATFORM`, `DEVICE_ID`, credentials, test data (gitignored); document new variables in `.env.example`

## Conventions
- File names: `snake_case.yaml`; flow `name:` format `Feature - Scenario`
- Every flow declares `appId`, `name`, and `tags` (`smoke`, `regression`, `negative`, `wip`)
- Keep the same scenario file name and `name:` across platforms so results are comparable
- Never hardcode credentials or personal data; use `${ENV_VAR}`
- Reuse steps via `runFlow` with relative paths to `subflows/<platform>/`; never cross platforms
- Every flow ends with at least one `assertVisible` / `assertNotVisible` on the expected outcome
- Prefer `id` selectors, then visible text; avoid coordinates (`point`) unless nothing else works
- Use `extendedWaitUntil` / `assertVisible` instead of fixed sleeps

## Device selection
- Device is chosen by the CLI, not by flow files: `maestro --device <id> test ...` or `maestro --platform android|ios test ...`
- `scripts/run.sh` reads `PLATFORM` and `DEVICE_ID` from `.env` or the environment
- When several devices are running, always pass `DEVICE_ID`

## Commands
- Run platform flows: `scripts/run.sh` (uses `PLATFORM`)
- Run by tag: `scripts/run.sh flows/android smoke`
- Override platform: `PLATFORM=ios scripts/run.sh`
- Run one flow: `maestro --device <id> test flows/android/auth/login_success.yaml -e APP_USER=... -e APP_PASSWORD=...`
- Inspect UI: `maestro studio`
