import express, {type Request, type Response} from "express";
import { connection } from "./src/db.js";
import cors from "cors";
import { router } from "./src/routes.js";


const PORT = process.env.HTTP_DATA_PORT;
const app = express();
app.use(express.json());
app.use(cors({
    origin: "http://localhost:5173",
    credentials: true,
}));
app.use(router);

//Conecção com o banco
connection();

console.log(process.env.HTTP_DATA_PORT)
console.log(process.env.DATABASE_URL)

app.listen(PORT, () => {
    console.log("Servirdor rodando na porta 3001, now!")
});

