# typst-patches

Project-local patched copies of upstream Typst packages, plus a brief explanation
of why each patch exists.

## orange-book-0.7.1-lib.typ

A copy of `lib.typ` from the
[`@preview/orange-book:0.7.1`](https://typst.app/universe/package/orange-book)
package, with **two cumulative modifications** for Typst 0.13+ compatibility.
Both are documented in-file with a `// Patch (Typst 0.13+ compatibility…)`
header immediately above the modified show rule.

### Iteration 1 — remove the chapter pagebreak

The original code wraps `pagebreak(to: "odd")` inside the body of a
`show heading: it => { ... }` show rule. Typst 0.13+ raises:

```
error: pagebreaks are not allowed inside of containers
```

Show-rule bodies that take the captured element as a closure are treated as
containers regardless of weak/parameter flags, so the pagebreak had to be
removed entirely. As a side effect, chapters no longer force a page break in
the PDF — prose now flows continuously across chapter boundaries.

### Iteration 2 — replace `place()`-based chapter ornament with flow content

Removing the pagebreak introduced a second problem: the original
`heading-style == 0` branch uses `place(move(dx: -3cm, dy: -3cm, ...))` to
draw the decorative chapter banner ABOVE the cursor (negative `dy`). When
chapters started on a fresh page (with the original pagebreak), the negative
`dy` placed the banner in the page header area — that's the intended look.
Without the pagebreak, chapters now start mid-page, so the banner gets
`place()`-d on top of whatever content was already there, producing a glaring
overlap of chapter ornaments with callouts, figures and prose.

The fix collapses `heading-style == 0` into the same flow-based rendering as
`heading-style == 1` — `align(right + top, block(...))`, no `place()`, no
absolute positioning. The chapter title now appears as a normal block in
document flow, slightly less fancy than the original orange-book look but
without overlap. The decorative chapter-image variant is dropped (the book
doesn't use heading-image).

To restore odd-page chapter breaks AND the fancy ornaments together, either
pin Typst to ≤ 0.12 or wait for an upstream orange-book release that fixes
the pagebreak issue at the source.

## How the patch is applied

Quarto's bundled `orange-book` extension (shipped with RStudio's Quarto)
imports `@preview/orange-book:0.7.1`, which Quarto downloads into
`.quarto/typst/packages/preview/orange-book/0.7.1/` on first PDF render.

The pre-render hook in `_quarto.yml` invokes `scripts/patch-orange-book.sh`,
which:

1. Does nothing if the cache directory doesn't yet exist (first render in a
   fresh clone).
2. Does nothing if `lib.typ` already has the patch sentinel (most renders).
3. Otherwise, copies `typst-patches/orange-book-0.7.1-lib.typ` over the
   cached copy.

So the patch survives `quarto render --clean`, fresh `git clone`, manual
`rm -rf .quarto`, and any cache invalidation Quarto might do internally — as
long as the user runs the full render pipeline.

**First-render-in-a-fresh-clone caveat.** Because Quarto only downloads the
typst package on its first PDF compile, the very first render after a fresh
clone may fail with the pagebreak error. Simply re-render once more: the
package is now cached, the patch script applies the fix, and the build
succeeds.

## When to remove this directory

Watch the orange-book repository
([typst/packages](https://github.com/typst/packages/tree/main/packages/preview/orange-book))
for a release that fixes the show-rule pagebreak. When that ships and Quarto
picks it up, this directory and the pre-render script can both be deleted.
