# Resume

> Personal resume as a single hand-maintained HTML file, with a script to generate the PDF version.
> The HTML is hosted on GitHub Pages. This repo is for managing and hosting my resume, not a general resume generator.

---

## Resume Versions

- [Hosted HTML version](https://attole.github.io/resume/)
- [PDF version](https://attole.github.io/resume/resume.pdf)

## Structure

```
docs/               GitHub Pages publishing root
  index.html        the resume - single source of truth (content + inline CSS)
  resume.pdf        generated PDF
  images/           photos and other assets, referenced as images/...
generate-pdf.ps1    Windows: shrinks images, then prints docs/index.html to docs/resume.pdf via headless Chrome
generate-pdf.sh     Linux/macOS: same flow (image shrink needs ImageMagick, skipped if absent)
```

The HTML was originally rendered from [JSON Resume](https://jsonresume.org/) with the
[StackOverflow theme](https://www.npmjs.com/package/jsonresume-theme-stackoverflow), then heavily
hand-edited and currently no JSON pipeline is used, edited HTML is the only source.

## Prerequisites

- Google Chrome (the PDF is printed via headless Chrome)

## Workflow

```bash
# edit docs/index.html directly
# new photos can be dropped into docs/images at full resolution - they get shrunk automatically

# regenerate PDF (one-page layout tuned via @page / @media print rules in the html)
./generate-pdf.ps1   # Windows
./generate-pdf.sh    # Linux/macOS

# commit and push - GitHub Pages serves docs/ automatically
```
