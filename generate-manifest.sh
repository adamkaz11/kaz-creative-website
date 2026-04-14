#!/bin/bash
DIR="$(dirname "$0")/images"
MANIFEST="$DIR/manifest.js"

[ -d "$DIR" ] || { echo "Error: images/ folder not found."; exit 1; }

files=()
for f in "$DIR"/*.jpg "$DIR"/*.jpeg "$DIR"/*.JPG "$DIR"/*.png "$DIR"/*.PNG "$DIR"/*.webp; do
  [ -f "$f" ] || continue
  name="$(basename "$f")"
  [[ "$name" == "hero.jpg" || "$name" == "about.jpg" ]] && continue
  files+=("$name")
done

if [ ${#files[@]} -eq 0 ]; then
  echo "No images found (hero.jpg and about.jpg are excluded)."
  echo "window.GALLERY_IMAGES = [];" > "$MANIFEST"
  exit 0
fi

{
  echo "window.GALLERY_IMAGES = ["
  count=0
  total=${#files[@]}
  for name in "${files[@]}"; do
    count=$((count + 1))
    if [ $count -lt $total ]; then
      echo "  \"$name\","
    else
      echo "  \"$name\""
    fi
  done
  echo "];"
} > "$MANIFEST"

echo "manifest.js updated with ${#files[@]} image(s):"
for name in "${files[@]}"; do echo "  $name"; done
