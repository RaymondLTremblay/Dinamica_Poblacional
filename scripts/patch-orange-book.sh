#!/usr/bin/env bash
# scripts/patch-orange-book.sh
#
# Re-applies the orange-book pagebreak patch to the cached Typst package
# after Quarto downloads it. Idempotent — safe to run on every render.
#
# Why:
#   Typst 0.13+ rejects `pagebreak(to: "odd")` inside `show heading: it => {}`
#   show-rule bodies, but orange-book v0.7.1 (the Typst preview package the
#   bundled Quarto/RStudio extension imports) still has that call inside a
#   show-rule. Without this patch, the PDF render fails with
#   "pagebreaks are not allowed inside of containers".
#
# What it does:
#   The vendored, pre-patched copy of lib.typ lives in
#   typst-patches/orange-book-0.7.1-lib.typ. After Quarto fetches the package
#   into .quarto/typst/packages/preview/orange-book/0.7.1/, this script
#   overwrites the upstream lib.typ with our patched copy (only if the cache
#   exists and isn't already patched).
#
# When to remove this script:
#   When orange-book on the Typst preview registry ships a release that fixes
#   the pagebreak issue (i.e. when the chapter-break show-rule no longer wraps
#   the pagebreak inside a container). Then delete this script and the
#   typst-patches/ folder, and remove the pre-render hook in _quarto.yml.

set -euo pipefail

CACHE_LIB=".quarto/typst/packages/preview/orange-book/0.7.1/lib.typ"
PATCHED_LIB="typst-patches/orange-book-0.7.1-lib.typ"
SENTINEL="Patch (Typst 0.13+ compatibility)"

if [ ! -f "$PATCHED_LIB" ]; then
  echo "[patch-orange-book] WARN: vendored copy missing at $PATCHED_LIB" >&2
  echo "[patch-orange-book] WARN: cannot re-apply patch — typst PDF render will fail." >&2
  exit 0
fi

if [ ! -f "$CACHE_LIB" ]; then
  # First render in a fresh checkout — Quarto hasn't yet downloaded the
  # orange-book package. The next render will populate the cache, then this
  # script will patch it.
  echo "[patch-orange-book] Typst cache not populated yet; nothing to patch."
  echo "[patch-orange-book] If the next typst render fails on a pagebreak"
  echo "[patch-orange-book] error, simply re-render once more."
  exit 0
fi

if grep -q "$SENTINEL" "$CACHE_LIB"; then
  # Already patched — skip silently.
  exit 0
fi

cp "$PATCHED_LIB" "$CACHE_LIB"
echo "[patch-orange-book] Re-applied patch to $CACHE_LIB"
