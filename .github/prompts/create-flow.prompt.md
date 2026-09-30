---
description: Create a new Maestro flow for a scenario, verified on a device
agent: maestro-automation
---

Create a Maestro flow for this scenario:

${input:scenario:Describe the scenario, e.g. "user adds product to cart and checks out"}

Platform: ${input:platform:android or ios}
App id: ${input:appId:com.example.flutter_starter}

Follow your workflow: explore the app on the device via the Maestro MCP, write the flow (and subflows if needed), run it until it passes, then report.
