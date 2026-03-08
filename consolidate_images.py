import os
import shutil
import re

os.makedirs("images", exist_ok=True)

skip_files = {'mi_gragico.tiff', 'Total.jpg'}
image_exts = {'.png', '.jpg', '.jpeg'}

def clean_name(name):
    name = name.replace(' ', '_')
    name = name.replace('%20', '_')
    # lowercase extension
    base, ext = os.path.splitext(name)
    return base + ext.lower()

moves = []

# Root level
for f in os.listdir('.'):
    if f in skip_files or not os.path.isfile(f):
        continue
    ext = os.path.splitext(f)[1].lower()
    if ext in image_exts:
        moves.append((f, "images/" + clean_name(f)))

# Figures/
if os.path.isdir('Figures'):
    for f in os.listdir('Figures'):
        ext = os.path.splitext(f)[1].lower()
        if ext in image_exts:
            moves.append(("Figures/" + f, "images/" + clean_name(f)))

# Species/
if os.path.isdir('Species'):
    for f in os.listdir('Species'):
        ext = os.path.splitext(f)[1].lower()
        if ext in image_exts:
            moves.append(("Species/" + f, "images/" + clean_name(f)))

# figs/
if os.path.isdir('figs'):
    for f in os.listdir('figs'):
        ext = os.path.splitext(f)[1].lower()
        if ext in image_exts:
            moves.append(("figs/" + f, "images/" + clean_name(f)))

print("FILES TO MOVE:")
for old, new in sorted(moves):
    print("  " + old + " -> " + new)
print("\nTotal: " + str(len(moves)) + " files")
print("\nTo actually move files, change DRY_RUN to False and run again.")

DRY_RUN = False

if not DRY_RUN:
    # Build a mapping of old paths to new paths for qmd updates
    path_map = {}
    for old, new in moves:
        shutil.move(old, new)
        # Store mapping for qmd reference updates
        old_name = os.path.basename(old)
        new_rel = new
        # Store various forms of the old path
        path_map[old] = new
        path_map[old.replace(' ', '%20')] = new

    # Update all .qmd files
    qmd_files = [f for f in os.listdir('.') if f.endswith('.qmd')]
    for qmd in qmd_files:
        with open(qmd, 'r') as file:
            content = file.read()
        original = content
        for old_path, new_path in path_map.items():
            content = content.replace(old_path, new_path)
        if content != original:
            with open(qmd, 'w') as file:
                file.write(content)
            print("Updated: " + qmd)

    print("\nDone! All images moved to images/ and .qmd files updated.")
