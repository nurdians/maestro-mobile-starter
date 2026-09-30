---
name: maestro-flow-authoring
description: Rules, patterns, and command reference for writing clean, stable Maestro YAML flows (selectors, waits, subflows, env vars, tags). Use when creating or editing files under flows/ or subflows/.
---

# Maestro flow authoring

## Flow file anatomy
```yaml
appId: com.example.flutter_starter
name: Feature - Scenario
tags:
  - smoke
---
- launchApp:
    clearState: true
- tapOn:
    id: "login_button"
- assertVisible: "Home"
```
Header (above `---`): `appId`, `name`, `tags`. Steps (below): a list of commands.

## Selector priority
1. `id` (accessibility id / resource-id): most stable
2. Visible text (`tapOn: "Login"`), regex allowed
3. Relative: `below`, `above`, `leftOf`, `rightOf`, `childOf`, `index`
4. `point` coordinates: last resort, document why

## Frequently used commands
| Purpose | Command |
|---|---|
| Start app | `launchApp` (`clearState`, `clearKeychain`, `permissions`) |
| Tap | `tapOn`, `longPressOn`, `doubleTapOn` |
| Type | `inputText`, `eraseText`, `hideKeyboard` |
| Navigate | `back`, `scroll`, `scrollUntilVisible`, `swipe` |
| Assert | `assertVisible`, `assertNotVisible`, `assertTrue` |
| Wait | `extendedWaitUntil` (visible/notVisible + timeout) |
| Reuse | `runFlow` (file or inline, supports `when`) |
| Data | `env`, `${VAR}`, `evalScript`, `runScript` |
| Evidence | `takeScreenshot`, `startRecording` / `stopRecording` |
| Repeat | `repeat` (`times` / `while`) |

## Patterns
**Reuse steps**
```yaml
- runFlow: ../../subflows/login.yaml
```
**Conditional step** (e.g. optional permission dialog)
```yaml
- runFlow:
    when:
      visible: "Allow"
    commands:
      - tapOn: "Allow"
```
**Wait for async content**
```yaml
- extendedWaitUntil:
    visible: "Dashboard"
    timeout: 15000
```
**Scroll to element**
```yaml
- scrollUntilVisible:
    element:
      text: "Checkout"
```

## Do
- One scenario per file; short and readable
- End every flow with an assertion of the expected result
- Start from a known state (`launchApp` with `clearState: true`) unless the flow deliberately continues
- Put credentials and test data in env vars (`-e KEY=value`, `.env`)
- Tag flows: `smoke`, `regression`, `negative`, `wip`

## Don't
- No fixed sleeps; wait on UI state instead
- No coordinates when an id or text exists
- No duplicated login/navigation steps; extract to `subflows/`
- No secrets or real personal data in YAML
- Don't rely on selectors you did not see in the view hierarchy

## Android vs iOS
- Keep flows separate per platform under `flows/android/` and `flows/ios/`; app ids and ids/labels frequently differ.
- Same scenario = same file name and `name:` on both platforms.
- If a single flow truly must branch, use `runFlow` with `when: platform: Android` / `iOS`, but prefer separate files.
- Subflows live in `subflows/<platform>/` and are referenced with relative paths from the same platform only.
