const express = require('express');

const factorial = require('./factorial');

const app = express();

const PORT = 8080;

app.get('/', function (req, res) {
    const { number } = req.query;

    res.write(`The number is: ${number}.\n`);
    res.write(`Its factorial value is: ${factorial(number)}.`);
    res.end();
});

app.listen(PORT, () => {
    console.log(`The server is running in port ${PORT}.`);
});