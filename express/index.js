const express = require("express");

const MAX_STORED_CATS = 1000;
const cats = [];

const app = express();

app.use(express.json());

app.get("/cats/:id", (req, res) => {
    const catId = req.params.id;
    const cat = cats.find(c => c.id === parseInt(catId));
    if (!cat) {
        return res.status(404).json({message: "404 - Not Found"});
    }
    res.status(200).json(cat);
});

app.post("/cats", (req, res) => {
    const cat = req.body;
    if (cats.length >= MAX_STORED_CATS) {
        cats.shift();
    }
    cats.push(cat);
    res.status(201).json(cat);
});

app.listen(1337, "0.0.0.0");