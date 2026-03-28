# YTTweak

A flexible YouTube enhancer for iOS, inspired by [YTLite / YouTube Plus](https://github.com/dayanch96/YTLite).  
Built with **Theos + Logos** — the same toolchain used by the iOS jailbreak community.

---

## ✨ Features

| Feature | Default |
|---|---|
| Block ads (pre-roll + banner) | ✅ On |
| Background playback | ✅ On |
| Hide Premium upsell dialogs | ✅ On |
| Hide annotations / end-screen cards | ✅ On |
| OLED / pure black mode | ⬜ Off |
| Remove Shorts tab | ⬜ Off |
| Remove Explore tab | ⬜ Off |
| Hide comments section | ⬜ Off |
| Default 1080p quality | ⬜ Off |
| Long-press 2× speed gesture | ⬜ Off |

All settings are toggled inside **YouTube → Settings → YTTweak**.

---

## 🛠️ How to Build (Local)

### Requirements
- macOS (Apple Silicon or Intel)
- [Theos](https://theos.dev/docs/installation) installed
- Xcode Command Line Tools
- A decrypted YouTube `.ipa` (you must obtain this yourself)

### Steps

```bash
# 1. Clone this repo
git clone https://github.com/yourname/YTTweak
cd YTTweak

# 2. Make sure THEOS is set
export THEOS=~/theos

# 3. Build
make

# 4. Install to a connected jailbroken device
make install   # requires THEOS_DEVICE_IP set in environment
```

---

## 🚀 Build a Sideloadable IPA via GitHub Actions

No Mac required — GitHub's CI does it for you.

1. **Fork** this repository
2. In your fork → **Settings → Actions** → enable **Read and Write** permissions
3. Go to **Actions → Build YouTube Tweak IPA → Run workflow**
4. Paste a direct URL to a decrypted YouTube IPA  
   *(Tip: filebin.net or Dropbox work well)*
5. Optionally customise the bundle ID and display name
6. Wait ~5 minutes → download the patched IPA from the run's **Artifacts** section
7. Install with [AltStore](https://altstore.io), [Sideloadly](https://sideloadly.io), or [TrollStore](https://github.com/opa334/TrollStore)

---

## 📁 Project Structure

```
YTTweak/
├── YTTweak.x          ← Main Logos hooks (runtime method swizzling)
├── YTTweak.h          ← Shared header + YouTube class forward declarations
├── Settings.x         ← Injects settings panel into YouTube Settings
├── Sideloading.x      ← Sideload-specific compatibility patches
├── YTTweak.plist      ← Substrate injection filter (YouTube bundle ID only)
├── Makefile           ← Theos build configuration
├── control            ← Debian package metadata
└── .github/
    └── workflows/
        └── build.yml  ← GitHub Actions IPA builder
```

---

## 🔧 Extending the Tweak

To add a new feature:

1. **Hook the class** in `YTTweak.x` using `%hook ClassName`
2. **Add a preference key** constant in `YTTweak.h`
3. **Add a toggle** in `Settings.x` inside `itemsForSection:`
4. **Register a default** in the `%ctor` block in `YTTweak.x`

Finding the right class to hook requires a tool like **class-dump** or **Frida** to inspect the YouTube binary. The [YouTubeHeader](https://github.com/PoomSmart/YouTubeHeader) repo by PoomSmart is an invaluable reference.

---

## ⚖️ Legal

This project does not distribute any YouTube code or IPA files.  
It is provided for **educational and personal use only**.  
You must supply your own decrypted IPA obtained lawfully.

---

## 🙏 Credits

- [dayanch96/YTLite](https://github.com/dayanch96/YTLite) — original inspiration and architecture reference  
- [PoomSmart/YouTubeHeader](https://github.com/PoomSmart/YouTubeHeader) — reverse-engineered YouTube headers  
- [theos/theos](https://github.com/theos/theos) — build system  
