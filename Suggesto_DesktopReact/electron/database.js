const mysql = require('mysql2/promise')

const db = mysql.createPool ({
    host : "143.106.241.4",
    user : "cl204225",
    password : "cl*05102007",
    database : "cl204225",
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

module.exports = db; 