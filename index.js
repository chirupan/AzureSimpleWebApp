import express from "express";
import morgan from "morgan";
import { fileURLToPath } from 'url';

const PORT = 8081;
const app = express();
const __dirname = fileURLToPath(new URL('.', import.meta.url));

// define middleware
app.use(morgan("dev"));
app.use(express.static("public"));

app.get("/", (req, res) => {
    res.render("index.html");
})

app.listen(PORT, () => {
    console.log("Express server listening on ", PORT);
})