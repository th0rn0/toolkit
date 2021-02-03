const puppeteer = require('puppeteer');
const axios = require('axios');
const https = require("https");
const fs = require('fs');
const url = require("url");
const shortid = require('shortid')

db.defaults({ urls: [] })
  .write();


(async () => {

  const browser = await puppeteer.launch({
    slowMo: 400
  });
  const page = await browser.newPage();
  await page.goto(ADDRESSTOSCRAPE);

  const hrefs = await page.$$eval('a', as => as.map(a => a.href));

  for (var i = hrefs.length - 1; i >= 0; i--) {
    if (hrefs[i].includes(url) && hrefs[i].includes('mp4')) {
      console.log(hrefs[i]);

      const method = 'GET';
      const url = hrefs[i];
      
      await downloadFile(hrefs[i], 'downloads/');
    }
  }

  await page.screenshot({path: 'example.png'});

  await browser.close();

  console.log('closing connection');
})();


// Downloads

function downloadFile ( fileURL, downloadDir ) {
https.get( fileURL, (res) => {
      // Handle network errors
      const { statusCode } = res;
      let error;
      if (statusCode !== 200) {
         error = new Error('Request Failed.\n' + `Status Code: ${statusCode}`);
      }

      // Save file to Disk
      saveFileToDisk( fileURL, downloadDir , res );  
   }).on('error', (e) => {
      console.error( ' Failed downloading: ' + fileURL + ' error message: ' + e.message);
   });

}

function saveFileToDisk ( fileURL, downloadDir, res ) {
   // Get file name
   try {
      fileName = extractFileNameFromURL( fileURL );
   } catch( e ) {
      console.log ( 'Could not extract file name from URL: ' + fileURL + ' ' + e.message );
      return;
   }

   // Ensure dir exists
   if ( !fs.existsSync( downloadDir ) ) {
      console.log( "Directory does not exist: " + downloadDir );
      return;
   }

   // Save to Disk
   try {
      var filePath =  downloadDir + '/' + fileName 
      var file = fs.createWriteStream( filePath );
      res.pipe(file);
   } catch ( e ) {
      console.log ( 'Could not save to disk file: ' + fileName + ' URL: ' + fileURL + ' ' + e.message );
      return;
   }
   console.log( 'Downloaded succesfully ' + fileURL + ' to file: ' + fileName );
   return filePath;
}

// Helpers

function extractFileNameFromURL ( fileURL ) {
   var parsed = url.parse( fileURL );
   filePath = parsed.pathname;
   return path.basename( filePath );
}

function makeid(length) {
   var result           = '';
   var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
   var charactersLength = characters.length;
   for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
   }
   return result;
}
