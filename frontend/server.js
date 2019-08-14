const express = require('express');
const serveStatic = require('serve-static');

const app = express();

app.use(serveStatic(`${__dirname}/dist`));

// Catch all routes and redirect to the index file
app.get('*', (req, res) => {
  res.sendFile(`${__dirname}/dist/index.html`);
});

const port = process.env.PORT || 5000;
app.listen(port);

console.log(`Server is running on port ${port}!`);
