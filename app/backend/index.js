const tasks = require("./routes/tasks");
const connection = require("./db");
const cors = require("cors");
const express = require("express");
const mongoose = require("mongoose");
const app = express();

connection();

app.use(express.json());
app.use(cors());

app.get('/health', (req, res) => {
    res.status(200).send('ok');
});

app.get('/api/health/ready', (req, res) => {
    if (mongoose.connection.readyState === 1) {
        res.status(200).send('Ready');
    } else {
        res.status(503).send('Database connection not established');
    }
});

app.get('/ok', (req, res) => {
    res.status(200).send('ok');
});

app.use("/api/tasks", tasks);

const port = process.env.PORT || 8080;
app.listen(port, () => {
    console.log(`API Server started on port ${port}`);
    console.log(`Health check available at http://localhost:${port}/health`);
});