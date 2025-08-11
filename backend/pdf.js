const markdownIt = require("markdown-it")();
const puppeteer = require("puppeteer");

async function generatePDF(markdown) {
  const html = markdownIt.render(markdown);
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.setContent(html, { waitUntil: "networkidle0" });
  const pdf = await page.pdf({ format: "A4" });
  await browser.close();
  return pdf;
}

module.exports = { generatePDF };

