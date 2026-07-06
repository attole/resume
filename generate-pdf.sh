#!/usr/bin/env bash
# Shrinks images in docs/images, then prints docs/index.html to docs/resume.pdf via headless Chrome.
# One-page layout is tuned via the @page and @media print rules in the html.
set -euo pipefail
cd "$(dirname "$0")"

MAX_WIDTH=360
JPEG_QUALITY=85

# --- shrink images (idempotent; requires ImageMagick, skipped if absent) ---
if command -v mogrify >/dev/null 2>&1; then
	for f in docs/images/*.jpg docs/images/*.jpeg docs/images/*.png; do
		[ -e "$f" ] || continue
		w=$(identify -format '%w' "$f")
		if [ "$w" -gt "$MAX_WIDTH" ]; then
			mogrify -resize "${MAX_WIDTH}x" -quality "$JPEG_QUALITY" "$f"
			echo "shrunk $f -> ${MAX_WIDTH}px"
		else
			echo "skip $f (${w}px)"
		fi
	done
else
	echo "ImageMagick not found - skipping image shrink"
fi

# --- print to pdf ---
CHROME=""
for c in google-chrome google-chrome-stable chromium chromium-browser; do
	if command -v "$c" >/dev/null 2>&1; then
		CHROME="$c"
		break
	fi
done
[ -n "$CHROME" ] || { echo "chrome/chromium not found" >&2; exit 1; }

# --virtual-time-budget gives the Font Awesome CDN fonts time to load
"$CHROME" --headless=new --disable-gpu \
	--virtual-time-budget=8000 \
	--no-pdf-header-footer \
	--print-to-pdf="$PWD/docs/resume.pdf" \
	"file://$PWD/docs/index.html"

echo "PDF generated: $PWD/docs/resume.pdf"
