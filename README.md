# Movie Mate — trakt.tv reliability patch

[Movie Mate](https://en.wikipedia.org/wiki/Movie-related_software) (package
`com.moviematelite`) is an Android app that syncs with
[trakt.tv](https://trakt.tv). Development stopped years ago. Two bugs have
since surfaced that make the trakt integration unreliable:

1. **You get logged out of trakt over and over.** The app's token-refresh
   logic wipes both your access token *and* refresh token on almost any
   failure — not just an actually-invalid token, but also plain network
   hiccups, timeouts, or a flaky connection. Once both tokens are gone,
   there's nothing left to refresh, so you're forced to log in again from
   scratch. The refresh was also only attempted opportunistically, gated by
   an unrelated date comparison, rather than reliably on each app resume.

2. **Only ~100 items sync (watched list, collection, ratings, watchlist).**
   Trakt added pagination to these sync endpoints after this app was built.
   The app has no idea pagination exists — it has no `page`/`limit`
   parameters at all, so it just silently accepts page 1 and stops there.
   If you've watched more than a page's worth of movies, the rest never
   shows up.

This repo contains a small patch (a few hundred lines of
[smali](https://github.com/JesusFreke/smali)/bytecode, applied via
[apktool](https://apktool.org/)) that fixes both.

## What this fixes

- **Token refresh:** only wipes your login when trakt explicitly says the
  token is invalid (HTTP 401). Network errors and timeouts now just leave
  your existing tokens alone, to be retried next time the app resumes.
  The refresh attempt itself also no longer depends on an unrelated date
  coincidence — it fires reliably.
- **Sync pagination:** the watched list, collection, ratings, and watchlist
  syncs now request the maximum page size (250) and automatically follow
  trakt's `X-Pagination-Page-Count` header to fetch every page, combining
  the results before handing them to the app's existing (unmodified)
  processing logic. No item-count ceiling anymore.

## Why this is a patch, not a rebuilt APK

Movie Mate's original code is copyrighted by its original developer, not
by anyone here. Decompiling an app you own for personal repair is one
thing; redistributing a rebuilt copy of someone else's app is a different
question I'm not in a position to answer for you.

So instead of publishing a patched APK, this repo only contains:

- the *diff* — the specific lines this patch adds or changes, in
  [`patches/`](./patches), as plain unified diffs against the smali apktool
  produces from the original APK
- one small new file ([`new_files/`](./new_files)) implementing the
  pagination loop
- a [build script](./build.sh) that applies these against **your own**
  copy of the APK and rebuilds it, entirely on your machine

Nobody downloads any of the original app's code from this repo — only the
delta. You need to already have your own copy of the APK to use this.

**I can't provide the original APK here, and this repo doesn't include
it.** If you don't already have a copy, that's between you and wherever
you'd normally obtain abandoned software you have a legitimate right to
use.

## Requirements

- An APK for Movie Mate Lite 6.8.1, internal version number 6082, MD5
  checksum 1381533d7dcd048fc39815b1caf338c4 (can be obtained, among others, from
  softonic.com under the filename
  com-moviematelite-6082-62742941-1381533d7dcd048fc39815b1caf338c4.apk)
- A JDK (for `apktool`, `apksigner`, `zipalign`, `keytool`)
- [`apktool`](https://apktool.org/docs/install) on your `PATH`
- Android SDK build-tools installed, with `apksigner` and `zipalign` on
  your `PATH` (these ship with Android Studio, or install standalone via
  `sdkmanager "build-tools;<version>"`)
- The `patch` command (preinstalled on Linux/macOS; on Windows, use WSL or
  Git Bash)

## Usage

```bash
git clone https://github.com/braunglasrakete/moviemate-trakt-patch.git
cd <repo>
./build.sh /path/to/your/moviemate.apk
```

The first run generates a new local signing key
(`.local-signing-key.jks`, gitignored, never shared) and reuses it on
subsequent runs. Output lands at `dist/MovieMate-patched.apk`.

**Before installing:** uninstall your existing Movie Mate first. The
rebuilt APK is signed with a new key (necessarily — nobody outside the
original developer has their signing key), and Android refuses to install
an update signed with a different key than what's already installed.
Uninstalling first will lose Movie Mate's local database (locally cached
watchlist/ratings/etc.) — anything already synced to trakt.tv is safe
there and will resync after you log in again.

## How the patches were made

Decompiled with [jadx](https://github.com/skylot/jadx) to understand the
logic, then hand-edited at the smali (Dalvik bytecode) level and rebuilt
with apktool — no source code from the original developer was ever
available or used. See the patch files themselves for the exact bytecode
changes; they're small enough to read in full.

## Disclaimer

Not affiliated with the original Movie Mate developer or with trakt.tv.
Provided as-is, patches an app you already have, use at your own
discretion. If the original developer would prefer this patch not be
distributed this way, or wants to fold it into an official release
instead, please open an issue — that'd be the better outcome.

## License

The contents of this repository (the patch files, the new pagination
class, this build script, and this README) are released under the
[MIT License](./LICENSE). This license covers only what's in this repo —
it does **not** grant any rights to Movie Mate itself, whose copyright
remains with its original developer.
