import { Router } from "express";
import { authUsuario, loginUsuario, logoutUsuario, cadastroUsuario } from "./controllers/usuario-controller.js";
import { listMedicos, deleteMedico, cadastroMedico } from "./controllers/medico-controller.js";
import { authMiddleware } from "./middlewares/auth.js";

export const router = Router();

// Rotas de usuário
router.post("/loginUsuario", loginUsuario);
router.post("/cadastroUsuario", cadastroUsuario);
router.get("/me", authMiddleware, authUsuario);
router.post("/logoutUsuario", logoutUsuario);

// Rota de médico
router.get("/listMedicos", listMedicos);
router.post("/cadastroMedico", cadastroMedico);
router.delete("/deleteMedico/:id", deleteMedico);
