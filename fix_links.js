const fs = require('fs');
const filename = 'CronogramaLector.html';
let content = fs.readFileSync(filename, 'utf8');
content = content.replace(/docs\.google\.com\/spreadsheets\/d\//g, 'docs.google.com/spreadsheets/u/0/d/');
fs.writeFileSync(filename, content, 'utf8');
console.log('Fixed CronogramaLector.html');
