# Maestro Mobile Automation Starter

Starter framework untuk automation mobile (Android & iOS) memakai Maestro, lengkap dengan custom agent + skill untuk VS Code GitHub Copilot yang membuat flow lewat Maestro MCP.

## Struktur
```
.
├── flows/
│   ├── android/
│   │   ├── config.yaml
│   │   ├── smoke/launch_app.yaml
│   │   └── auth/login_*.yaml
│   └── ios/                    # struktur sama dengan android/
├── subflows/
│   ├── android/login.yaml      # langkah reusable per platform
│   └── ios/login.yaml
├── scripts/run.sh              # runner: pilih device, load .env, output JUnit
├── reports/                    # hasil run (gitignored)
├── .env.example
├── .vscode/mcp.json            # Maestro MCP server
└── .github/
    ├── copilot-instructions.md
    ├── agents/maestro-automation.agent.md
    ├── skills/maestro-flow-authoring/SKILL.md
    ├── skills/maestro-debugging/SKILL.md
    └── prompts/create-flow.prompt.md
```

## Setup
1. Install Maestro (`maestro --version` harus jalan) dan Java 17+.
2. `cp .env.example .env`, lalu isi:
   - `PLATFORM` = `android` atau `ios`
   - `DEVICE_ID` (opsional, wajib jika ada lebih dari satu device aktif)
   - kredensial test
3. Ganti `appId: com.example.flutter_starter` di flow dan subflow tiap platform dengan app id yang benar, lalu sesuaikan selector (`id`) dengan aplikasimu.
4. Jalankan emulator/simulator dengan app sudah terinstall.

## Pemilihan device
Device ditentukan oleh CLI, bukan oleh file flow. `scripts/run.sh` membaca `.env`:

| Pengaturan | Efek |
|---|---|
| `DEVICE_ID=<id>` | `maestro --device <id> test ...` |
| hanya `PLATFORM=android\|ios` | `maestro --platform <platform> test ...` |

Cari id device:
```bash
adb devices                          # Android
xcrun simctl list devices booted     # iOS
```
Environment shell menimpa `.env`, contoh: `PLATFORM=ios scripts/run.sh`.

## Menjalankan test
```bash
scripts/run.sh                          # semua flow di flows/$PLATFORM
scripts/run.sh flows/android smoke      # hanya tag smoke
PLATFORM=ios DEVICE_ID=<uuid> scripts/run.sh
```
Report: `reports/report.xml` (JUnit), log/screenshot: `reports/debug/`.

## Memakai AI agent di VS Code
1. Buka folder ini di VS Code (Copilot Chat aktif).
2. Buka `.vscode/mcp.json` lalu klik **Start** di server `maestro`. Pertama kali akan muncul prompt trust.
3. Di Copilot Chat pilih agent **maestro-automation**.
4. Beri tugas, contoh: "Buat flow login untuk Android pakai emulator Pixel_7", atau jalankan prompt `/create-flow`.

Contoh penggunaan `/create-flow`:

```text
/create-flow
login menggunakan valid credential kemudian tambah product baru berikut:
- nama product: headset sony
- harga: 300000
- stok: 10
```

Agent akan: memilih device, inspect UI, menjalankan langkah lewat MCP, menulis flow di `flows/<platform>/`, lalu menjalankannya sampai lolos. Jika skenario dibutuhkan di dua platform, agent mengulang prosesnya di device platform lainnya.

### Troubleshooting MCP
- `maestro` tidak ditemukan oleh VS Code: pakai path absolut di `.vscode/mcp.json`, misalnya `"command": "/Users/<nama>/.maestro/bin/maestro"` (cek dengan `which maestro`).
- Tools MCP tidak muncul di agent: buka tool picker di Chat, pastikan tools server `maestro` dicentang, atau sesuaikan daftar `tools:` di file `.agent.md` (nama tool bawaan VS Code bisa berbeda antar versi).
- Skill tidak terbaca: pastikan fitur Agent Skills aktif di versi VS Code kamu, dan folder skill berisi `SKILL.md`.
