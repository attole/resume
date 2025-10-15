# Resume

This repository contains my resume in multiple formats along with the scripts used to generate them.

## Resume Versions

- [Hosted HTML version](https://attole.github.io/resume/)
- [PDF version](./src/edited/resume.pdf)

## Tools / Technologies Used

- [JSON Resume](https://jsonresume.org/) - JSON format for resume
- [resumed CLI](https://www.npmjs.com/package/resumed) - init, validate and render JSON to HTML
- [StackOverflow theme](https://www.npmjs.com/package/jsonresume-theme-stackoverflow) - HTML theme
- [Node.js](https://nodejs.org/) - runtime for scripts
- [wkhtmltopdf](https://www.npmjs.com/package/wkhtmltopdf) - HTML to PDF conversion
- [GitHub Pages](https://pages.github.com/) - hosting HTML

## Build / Generate

An external HTML to PDF converter is used because the HTML is manually polished before conversion, so `resumed export` cannot be applied.

If you want to use this repo on own workflow:

```bash
git clone https://github.com/attole/resume.git
cd resume

# install dependencies
npm install

# edit json file or create new one
npx resumed init ./src/base/resume.json

# any images on should be located under ./host/images and referenced by:
# - ../../host/images/ for local/non-hosted HTML
# - images/ for hosted HTML

# validate on big changes
npx resumed validate ./src/base/resume.json

# generate HTML
npx resumed render ./src/base/resume.json -o ./src/base/resume.html

# create copy to ./edited
cp ./src/base/resume.html ./src/edited

# edit copy to whatever needed, and copy final version to ./host/

# generate PDF
npm run generate-pdf
```
