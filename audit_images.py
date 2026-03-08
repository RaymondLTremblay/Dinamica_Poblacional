import os
import re

# Get all images in images/ folder
images_on_disk = set(os.listdir('images'))

# Get all image references in .qmd files
referenced = set()
qmd_files = [f for f in os.listdir('.') if f.endswith('.qmd')]

for qmd in qmd_files:
    with open(qmd, 'r') as f:
        content = f.read()
    # Find markdown image references
    for match in re.findall(r'images/([^\s\)"\']+)', content):
        referenced.add(match.strip())

# Images referenced but NOT on disk (broken links)
missing = referenced - images_on_disk
# Images on disk but NOT referenced (orphans)
orphans = images_on_disk - referenced

print("=== REFERENCED BUT MISSING (broken image links) ===")
if missing:
    for f in sorted(missing):
        print("  MISSING: " + f)
else:
    print("  None! All referenced images exist.")

print("\n=== ON DISK BUT NOT REFERENCED (orphaned images) ===")
if orphans:
    for f in sorted(orphans):
        print("  ORPHAN: " + f)
else:
    print("  None! All images are used.")

print("\nSummary:")
print("  Images on disk: " + str(len(images_on_disk)))
print("  Images referenced: " + str(len(referenced)))
print("  Missing: " + str(len(missing)))
print("  Orphaned: " + str(len(orphans)))
