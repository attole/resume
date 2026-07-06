# Shrinks images in docs\images, then prints docs\index.html to docs\resume.pdf via headless Chrome.
# One-page layout is tuned via the @page and @media print rules in the html.
# If output shows stale assets (e.g. old image), delete %TEMP%\resume-pdf-profile and rerun.

$MaxWidth = 360
$JpegQuality = 85
$Chrome = 'C:\Program Files\Google\Chrome\Application\chrome.exe'

# --- shrink images (idempotent: skips anything already at or below MaxWidth) ---
Add-Type -AssemblyName System.Drawing

Get-ChildItem (Join-Path $PSScriptRoot 'docs\images') -Include *.jpg, *.jpeg, *.png -Recurse | ForEach-Object {
	$img = [System.Drawing.Image]::FromFile($_.FullName)
	$srcWidth = $img.Width
	if ($srcWidth -le $MaxWidth) {
		$img.Dispose()
		Write-Host "skip $($_.Name) (${srcWidth}px)"
		return
	}

	$w = $MaxWidth
	$h = [int]($img.Height * $w / $srcWidth)
	$bmp = New-Object System.Drawing.Bitmap($w, $h)
	$g = [System.Drawing.Graphics]::FromImage($bmp)
	$g.InterpolationMode = 'HighQualityBicubic'
	$g.SmoothingMode = 'HighQuality'
	$g.PixelOffsetMode = 'HighQuality'
	$g.DrawImage($img, 0, 0, $w, $h)
	$g.Dispose()
	$img.Dispose()

	$tmp = "$($_.FullName).tmp"
	if ($_.Extension -eq '.png') {
		$bmp.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
	} else {
		$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object MimeType -eq 'image/jpeg'
		$ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
		$ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$JpegQuality)
		$bmp.Save($tmp, $codec, $ep)
	}
	$bmp.Dispose()

	Move-Item $tmp $_.FullName -Force
	Write-Host "shrunk $($_.Name) -> ${w}px, $((Get-Item $_.FullName).Length) bytes"
}

# --- print to pdf ---
if (-not (Test-Path $Chrome)) {
	Write-Error "Chrome not found at $Chrome"
	exit 1
}

$rootUrl = $PSScriptRoot -replace '\\', '/'
$pdf = Join-Path $PSScriptRoot 'docs\resume.pdf'

# --virtual-time-budget gives the Font Awesome CDN fonts time to load
Start-Process -FilePath $Chrome -Wait -ArgumentList @(
	'--headless=new',
	'--disable-gpu',
	"--user-data-dir=`"$env:TEMP\resume-pdf-profile`"",
	'--virtual-time-budget=8000',
	'--no-pdf-header-footer',
	"--print-to-pdf=`"$pdf`"",
	"file:///$rootUrl/docs/index.html"
)

if (Test-Path $pdf) {
	Write-Host "PDF generated: $pdf"
} else {
	Write-Error 'PDF was not generated'
	exit 1
}
