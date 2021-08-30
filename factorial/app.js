const express = require('express');
const morgan = require('morgan');

const factorial = require('./factorial');

const app = express();

const PORT = 8080;

app.set('trust proxy', true);

app.use(morgan('combined'));

app.get('/', function (req, res) {
    const { number } = req.query;

    res.write(`The number is: ${number}.\n`);
    res.write(`Its factorial value is: ${factorial(number)}.`);
    res.end();
});


app.get('/health', function (req, res) {
    res.sendStatus(200);
});

app.listen(PORT, () => {
    console.log(`The server is running in port ${PORT}.`);
});