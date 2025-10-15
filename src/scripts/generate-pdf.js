const fs = require('fs');
const wkhtmltopdf = require('wkhtmltopdf');
const path = require('path');

const inputPath = path.resolve(__dirname, '../edited/resume.html');
const outputPath = path.resolve(__dirname, '../edited/resume.pdf');

const fileUrl = `file:///${inputPath.replace(/\\/g, '/')}`;

//custom margins set to get all content included on one page
wkhtmltopdf(fileUrl, {
	enableLocalFileAccess: true,
	marginTop: '5mm',
	marginBottom: '0mm',
})
	.pipe(fs.createWriteStream(outputPath))
	.on('finish', () => console.log('PDF generated:', outputPath))
	.on('error', (err) => console.error('PDF error:', err));
