import express from "express";
import { connection } from "./src/db.js";
import { prisma } from "./src/db.js";
import cors from "cors";

const PORT = process.env.HTTP_DATA_PORT;
const app = express();
app.use(express.json());
app.use(cors());

//Conecção com o banco
connection();

console.log(process.env.HTTP_DATA_PORT)
console.log(process.env.DATABASE_URL)


app.get("/login", async (req, res)=>{
    
    const {email, password } = req.body; 
    console.log(req.body)
    //console.log(email, password);

    const user = await prisma.user.findFirst({
         where: { email}
     })

    console.log(user?.email)
    res.status(200).json(user)
    console.log("Acionando Get!")
    //res.status(200).json("Você acessou a rota inicial, show my brother!")
 
})

app.listen(PORT, () => {
    console.log("Servirdor rodando na porta 3001, now!")
});

