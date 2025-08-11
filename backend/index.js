const express = require('express');
const cors = require('cors');
const MarkdownIt = require('markdown-it');
const puppeteer = require('puppeteer');

const app = express();
const md = new MarkdownIt();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Markdown to PDF API is running!');
});

app.post('/convert', async (req, res) => {
  try {
    const { markdown } = req.body;
    if (!markdown) {
      return res.status(400).json({ error: 'Markdown content is required' });
    }

    // Convert Markdown to HTML
    const htmlContent = md.render(markdown);

    // Wrap HTML content in basic HTML structure
    const fullHtml = `
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8" />
          <title>Markdown PDF</title>
          <style>
            body { font-family: Arial, sans-serif; margin: 40px; }
          </style>
        </head>
        <body>${htmlContent}</body>
      </html>
    `;

    // Launch puppeteer with no sandbox (needed on many servers)
    const browser = await puppeteer.launch({
      args: ['--no-sandbox', '--disable-setuid-sandbox'],
    });

    const page = await browser.newPage();
    await page.setContent(fullHtml, { waitUntil: 'networkidle0' });

    // Generate PDF buffer (no file saved to disk)
    const pdfBuffer = await page.pdf({
      format: 'A4',
      printBackground: true,
    });

    await browser.close();

    // Send PDF file in response with proper headers
    res.set({
      'Content-Type': 'application/pdf',
      'Content-Disposition': 'attachment; filename=converted.pdf',
      'Content-Length': pdfBuffer.length,
    });

    return res.send(pdfBuffer);
  } catch (error) {
    console.error('Error generating PDF:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Markdown to PDF API listening on port ${PORT}`);
});

