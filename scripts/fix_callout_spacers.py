#!/usr/bin/env python3
"""Convert standalone U+00A0 spacer lines to literal &nbsp;, and ensure a
&nbsp; spacer line both immediately before AND after every callout block.
Idempotent: normalises any run of blank/&nbsp; lines that contains a &nbsp;
into exactly ['', '&nbsp;', '']."""
import re, sys, io

NBSP = chr(0xA0)
CALLOUT_OPEN = re.compile(r'^:::+\s*\{?\.?callout-')
FENCE_OPEN   = re.compile(r'^:::+\s*\S')   # fenced-div open (content after colons)
FENCE_CLOSE  = re.compile(r'^:::+\s*$')    # bare colons => close
CODE_FENCE   = re.compile(r'^\s*```')

def is_nbsp_only(line):
    # line consists solely of U+00A0 plus optional ASCII whitespace
    return NBSP in line and set(line) <= {NBSP, ' ', '\t', '\r'}

def find_callout_bounds(lines):
    """Return (set of callout open_idx, set of callout close_idx)."""
    opens, closes = set(), set()
    stack = []          # list of (idx, is_callout)
    in_code = False
    for i, l in enumerate(lines):
        if CODE_FENCE.match(l):
            in_code = not in_code
            continue
        if in_code:
            continue
        if FENCE_CLOSE.match(l):
            if stack:
                idx, is_co = stack.pop()
                if is_co:
                    opens.add(idx); closes.add(i)
        elif FENCE_OPEN.match(l):
            stack.append((i, bool(CALLOUT_OPEN.match(l))))
    return opens, closes

def process(path):
    with io.open(path, encoding='utf-8') as fh:
        text = fh.read()
    nl = '\n'
    lines = text.split(nl)

    # --- pass 1: U+00A0-only lines -> &nbsp;
    conv = 0
    for i, l in enumerate(lines):
        if is_nbsp_only(l):
            lines[i] = '&nbsp;'
            conv += 1

    # --- pass 2: crude-insert &nbsp; before each callout open and after close
    opens, closes = find_callout_bounds(lines)
    out = []
    for i, l in enumerate(lines):
        if i in opens:
            out.append('&nbsp;')   # before open (normalised later)
        out.append(l)
        if i in closes:
            out.append('&nbsp;')   # after close (normalised later)
    lines = out

    # --- pass 3: normalise runs of (blank|&nbsp;) that contain a &nbsp;
    res = []
    n = len(lines)
    i = 0
    while i < n:
        l = lines[i]
        if l.strip() == '' or l.strip() == '&nbsp;':
            j = i
            has_nbsp = False
            while j < n and (lines[j].strip() == '' or lines[j].strip() == '&nbsp;'):
                if lines[j].strip() == '&nbsp;':
                    has_nbsp = True
                j += 1
            run = lines[i:j]
            if has_nbsp:
                block = ['', '&nbsp;', '']
                if not res:           # file start: no leading blank
                    block = ['&nbsp;', '']
                if j >= n and block and block[-1] == '':  # file end: drop trailing blank
                    block = block[:-1]
                res.extend(block)
            else:
                res.extend(run)       # leave plain blank runs untouched
            i = j
        else:
            res.append(l)
            i += 1

    new_text = nl.join(res)
    if new_text != text:
        with io.open(path, 'w', encoding='utf-8') as fh:
            fh.write(new_text)
        return conv, len(opens)
    return conv, 0

if __name__ == '__main__':
    total_conv = 0
    for p in sys.argv[1:]:
        c, ncall = process(p)
        print(f"{p}: nbsp-converted={c}, callouts={ncall}")
        total_conv += c
    print(f"TOTAL U+00A0 converted: {total_conv}")
