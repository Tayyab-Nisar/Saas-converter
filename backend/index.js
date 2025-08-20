const express = require('express');
const cors = require('cors');
const multer = require('multer');
const puppeteer = require('puppeteer');
const fs = require('fs');
const libre = require('libreoffice-convert');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());

const upload = multer({ storage: multer.memoryStorage() });

// 🔹 Text to PDF
app.post('/convert-text', async (req, res) => {
  try {
    const { text } = req.body;
    if (!text) return res.status(400).json({ error: 'Text is required' });

    const html = `<html><body style="font-family:Arial, sans-serif; margin:40px;">${text}</body></html>`;
    const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: 'networkidle0' });
    const pdf = await page.pdf({ format: 'A4', printBackground: true });
    await browser.close();

    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', 'attachment; filename=text.pdf');
    res.send(pdf);
  } catch (err) {
    res.status(500).json({ error: 'Failed to convert text' });
  }
});

// 🔹 Image to PDF (JPEG/PNG)
app.post('/convert-image', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ error: 'Image file required' });

    const base64 = req.file.buffer.toString('base64');
    const html = `<html><body><img style="max-width:100%;height:auto;" src="data:${req.file.mimetype};base64,${base64}"/></body></html>`;

    const browser = await puppeteer.launch({ args: ['--no-sandbox'] });
    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: 'networkidle0' });
    const pdf = await page.pdf({ format: 'A4', printBackground: true });
    await browser.close();

    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', 'attachment; filename=image.pdf');
    res.send(pdf);
  } catch (err) {
    res.status(500).json({ error: 'Failed to convert image' });
  }
});

// 🔹 Word to PDF
app.post('/convert-word', upload.single('file'), (req, res) => {
  if (!req.file) return res.status(400).json({ error: 'Word file required' });

  const ext = '.pdf';
  libre.convert(req.file.buffer, ext, undefined, (err, done) => {
    if (err) return res.status(500).json({ error: 'Conversion failed' });

    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', 'attachment; filename=document.pdf');
    res.send(done);
  });
});

app.listen(3001, () => console.log('PDF Converter API running on port 3001'));
