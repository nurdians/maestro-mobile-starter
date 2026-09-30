---
name: maestro-debugging
description: Diagnose and fix failing or flaky Maestro flows (element not found, timing, keyboard, permissions, state). Use when a flow run fails or behaves inconsistently.
---

# Maestro debugging

## Loop
1. Read the failure message (which step, which selector).
2. Inspect the current screen: view hierarchy + screenshot (MCP) or `maestro studio`.
3. Match the failure to a cause below, apply the smallest fix, rerun that single flow.
4. Stop after 3 attempts and report findings instead of guessing further.

## Common causes and fixes
| Symptom | Likely cause | Fix |
|---|---|---|
| Element not found | Wrong id/text, or screen not loaded | Re-read hierarchy; use exact id; add `extendedWaitUntil` |
| Works alone, fails in suite | Leftover app state | `launchApp` with `clearState: true` |
| Tap hits wrong thing | Text matches multiple elements | Use `id`, or add `index` / relative selector |
| Input typed but button covered | Keyboard open | Add `hideKeyboard` before tapping |
| Random timeouts | Slow network/animation | Longer `timeout`, wait for a stable element |
| Permission dialog blocks flow | System prompt | `launchApp: permissions: { all: allow }` or conditional `runFlow` |
| Off-screen element | Needs scrolling | `scrollUntilVisible` |
| iOS/Android differ | Platform-specific labels | `runFlow` with `when: platform: iOS/Android` |

## Evidence
- Add `takeScreenshot` before the failing step while investigating; remove it afterwards.
- CLI: `maestro test <flow> --debug-output reports/debug` for logs and screenshots.
- When reporting, include the failing step, the observed screen, and the fix tried.
