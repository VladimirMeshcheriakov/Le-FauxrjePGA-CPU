const fs = require("fs");
const puppeteer = require("puppeteer");

// URL of the target page
const url = "https://riscvasm.lucasteske.dev/#";

// Read the content from the input file
const inputFilePath = process.argv[2];
const outputFilePath = process.argv[3];

if (!inputFilePath) {
  console.error("Please provide the path to the input file.");
  process.exit(1);
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

const inputContent = fs.readFileSync(inputFilePath, "utf-8");

(async () => {
  try {
    // Launch a headless browser instance
    const browser =  await puppeteer.launch({
      headless: "new",
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-web-security',
        '--no-deprecation', // Add this flag to suppress deprecation warnings
      ],
    });
    // Open a new page
    const page = await browser.newPage();

    // Navigate to the URL
    await page.goto(url);
    await page.waitForFunction(() => typeof doAssemble === 'function');
    // Find the textarea element
    const res = await page.evaluate(async (inputContent) => {
      // Call the buildStuff function with the provided input
      const l = await doAssemble(inputContent);
      return l.hex;
    }, inputContent);

      const regex = /([0-9a-f]{2})/g;
      const modifiedData = res.replace(regex, "$1 ");
      fs.writeFile(outputFilePath, modifiedData, "utf8", (err) => {
        if (err) {
          console.error("Error writing to the file:", err);
          return;
        }
      });
    // Close the browser
    await browser.close();
  } catch (error) {
    console.error("Error:", error);
  }
})();
