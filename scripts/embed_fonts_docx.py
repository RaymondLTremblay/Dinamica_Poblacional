#!/usr/bin/env python3
"""Embed JetBrains Mono into a rendered .docx so the code/script font renders
identically on any machine (the editor / Lankester may not have it installed).

WHY PYTHON (not R, the project default): this is binary surgery on the OOXML
package — font obfuscation (XOR) + zip part injection. Python's zipfile/struct
make it safe and testable; an R port would be error-prone and there is no value
in it. Run it as a POST step after rendering the Word file:

    quarto render --to docx
    python3 scripts/embed_fonts_docx.py            # defaults to the book .docx
    python3 scripts/embed_fonts_docx.py path/to/file.docx

Pandoc copies the reference doc's fontTable.xml but NOT the font binaries, so
embedding cannot live in reference.docx — it must be applied to the final file.
The script is idempotent: re-running replaces prior JetBrains Mono embedding.

Fonts come from fonts/JetBrainsMono-{Regular,Bold}.ttf (latin subset).
"""
import os, re, sys, uuid, shutil, zipfile, tempfile

FONT_NAME = "JetBrains Mono"

def project_root(start=None):
    d = os.path.abspath(start or os.getcwd())
    while True:
        if os.path.exists(os.path.join(d, "_quarto.yml")):
            return d
        p = os.path.dirname(d)
        if p == d:
            return os.path.abspath(os.path.dirname(__file__) + "/..")
        d = p

def obfuscate(ttf_bytes, guid_hex):
    """ECMA-376 §17.8.1 obfuscation: XOR first 32 bytes with the reversed GUID."""
    data = bytearray(ttf_bytes)
    key = bytes.fromhex(guid_hex)[::-1]
    for i in range(32):
        data[i] ^= key[i % 16]
    return bytes(data)

def ensure(text, needle, addition, anchor):
    """Insert `addition` before `anchor` if `needle` not already present."""
    return text if needle in text else text.replace(anchor, addition + anchor, 1)

def main():
    root = project_root()
    docx = sys.argv[1] if len(sys.argv) > 1 else os.path.join(
        root, "docs", "Introduccion-a-la-Dinamica-Poblacional-de-Orquideas.docx")
    if not os.path.exists(docx):
        sys.exit(f"No se encontró el .docx: {docx}\n"
                 f"Renderice primero con: quarto render --to docx")
    reg = open(os.path.join(root, "fonts", "JetBrainsMono-Regular.ttf"), "rb").read()
    bold = open(os.path.join(root, "fonts", "JetBrainsMono-Bold.ttf"), "rb").read()

    work = tempfile.mkdtemp(prefix="docxfont_")
    with zipfile.ZipFile(docx) as z:
        names = z.namelist()
        z.extractall(work)

    # 1) obfuscated font parts with fresh keys
    g1, g2 = uuid.uuid4().hex.upper(), uuid.uuid4().hex.upper()
    os.makedirs(os.path.join(work, "word", "fonts"), exist_ok=True)
    open(os.path.join(work, "word", "fonts", "font1.odttf"), "wb").write(obfuscate(reg, g1))
    open(os.path.join(work, "word", "fonts", "font2.odttf"), "wb").write(obfuscate(bold, g2))

    # 2) [Content_Types].xml — odttf default + fontTable override
    ct = os.path.join(work, "[Content_Types].xml"); s = open(ct, encoding="utf-8").read()
    s = ensure(s, 'Extension="odttf"',
               '<Default Extension="odttf" ContentType="application/vnd.openxmlformats-officedocument.obfuscatedFont"/>',
               "</Types>")
    s = ensure(s, '/word/fontTable.xml',
               '<Override PartName="/word/fontTable.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.fontTable+xml"/>',
               "</Types>")
    open(ct, "w", encoding="utf-8").write(s)

    # 3) word/_rels/document.xml.rels — fontTable relationship
    dr = os.path.join(work, "word", "_rels", "document.xml.rels"); s = open(dr, encoding="utf-8").read()
    s = ensure(s, "relationships/fontTable",
               '<Relationship Id="rIdFontTable" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable" Target="fontTable.xml"/>',
               "</Relationships>")
    open(dr, "w", encoding="utf-8").write(s)

    # 4) word/fontTable.xml — ensure font entry has embedRegular/embedBold (idempotent)
    embeds = (f'<w:embedRegular r:id="rIdF1" w:fontKey="{{{g1}}}" w:subsetted="false"/>'
              f'<w:embedBold r:id="rIdF2" w:fontKey="{{{g2}}}" w:subsetted="false"/>')
    ftp = os.path.join(work, "word", "fontTable.xml")
    ns = ('xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" '
          'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"')
    font_el = (f'<w:font w:name="{FONT_NAME}"><w:charset w:val="00"/>'
               f'<w:family w:val="modern"/><w:pitch w:val="fixed"/>{embeds}</w:font>')
    if not os.path.exists(ftp):
        s = f'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n<w:fonts {ns}>{font_el}</w:fonts>'
    else:
        s = open(ftp, encoding="utf-8").read()
        # drop any previous embed* entries (re-run safety)
        s = re.sub(r'<w:embed(Regular|Bold|Italic|BoldItalic)[^/]*/>', '', s)
        if f'w:name="{FONT_NAME}"' in s:
            # insert embeds just before the closing tag of THIS font element
            s = re.sub(r'(<w:font w:name="%s">.*?)(</w:font>)' % re.escape(FONT_NAME),
                       lambda m: m.group(1) + embeds + m.group(2), s, count=1, flags=re.S)
        else:
            s = s.replace("</w:fonts>", font_el + "</w:fonts>", 1)
    open(ftp, "w", encoding="utf-8").write(s)

    # 5) word/_rels/fontTable.xml.rels — point rIdF1/F2 at the font parts
    os.makedirs(os.path.join(work, "word", "_rels"), exist_ok=True)
    frp = os.path.join(work, "word", "_rels", "fontTable.xml.rels")
    rel = ('<Relationship Id="rIdF1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/font" Target="fonts/font1.odttf"/>'
           '<Relationship Id="rIdF2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/font" Target="fonts/font2.odttf"/>')
    if not os.path.exists(frp):
        s = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
             '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
             + rel + '</Relationships>')
    else:
        s = open(frp, encoding="utf-8").read()
        s = re.sub(r'<Relationship Id="rIdF[12]"[^/]*/>', '', s)  # re-run safety
        s = s.replace("</Relationships>", rel + "</Relationships>", 1)
    open(frp, "w", encoding="utf-8").write(s)

    # 6) word/settings.xml — enable embedding. CT_Settings has a STRICT element
    # order: ... embedTrueTypeFonts, embedSystemFonts, saveSubsetFonts, ...
    # so we anchor on embedSystemFonts (pandoc already emits it) to stay valid.
    st = os.path.join(work, "word", "settings.xml"); s = open(st, encoding="utf-8").read()
    if "<w:embedTrueTypeFonts" not in s:
        if "<w:embedSystemFonts" in s:
            s = s.replace("<w:embedSystemFonts", "<w:embedTrueTypeFonts/><w:embedSystemFonts", 1)
            s = re.sub(r'(<w:embedSystemFonts[^>]*/>)',
                       r'\1<w:saveSubsetFonts w:val="false"/>', s, count=1)
        elif "<w:zoom" in s:
            s = re.sub(r'(<w:zoom[^>]*/>)',
                       r'\1<w:embedTrueTypeFonts/><w:saveSubsetFonts w:val="false"/>', s, count=1)
        else:
            s = re.sub(r'(<w:settings[^>]*>)',
                       r'\1<w:embedTrueTypeFonts/><w:saveSubsetFonts w:val="false"/>', s, count=1)
        open(st, "w", encoding="utf-8").write(s)

    # 7) repack (write to temp, then replace original)
    tmp_out = docx + ".tmp"
    if os.path.exists(tmp_out):
        os.remove(tmp_out)
    with zipfile.ZipFile(tmp_out, "w", zipfile.ZIP_DEFLATED) as zf:
        for r, _, files in os.walk(work):
            for f in files:
                full = os.path.join(r, f)
                zf.write(full, os.path.relpath(full, work))
    shutil.move(tmp_out, docx)
    shutil.rmtree(work, ignore_errors=True)
    print(f"Embebido {FONT_NAME} en {os.path.basename(docx)} "
          f"(+{(len(reg)+len(bold))//1024} KB).")

if __name__ == "__main__":
    main()
