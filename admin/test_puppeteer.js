import puppeteer from 'puppeteer';
(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  page.on('console', msg => console.log('BROWSER LOG:', msg.type(), msg.text()));
  page.on('pageerror', err => console.log('BROWSER ERROR:', err.message));
  
  await page.goto('http://localhost:5173');
  await page.waitForTimeout(2000);
  
  const rootHtml = await page.$eval('#root', el => el.innerHTML);
  console.log('Root HTML length:', rootHtml.length);
  
  await browser.close();
})();
