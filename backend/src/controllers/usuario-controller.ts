import type { Request, Response } from "express";
import { prisma } from "../db.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { role_enum } from "../../generated/prisma/enums.js";

export const loginUsuario = async (req: Request, res: Response) => {
  try {
    const { email, senha_hash } = req.body;

    if (!email || !senha_hash) {
      res.status(400).json({ message: "E-mail e senha são obrigatórios." });
      return;
    }

    const user = await prisma.usuario.findFirst({
      where: { email },
    });

    if (!user) {
      res.status(404).json({ message: "Usuário não encontrado." });
      return;
    }

    const match = await bcrypt.compare(senha_hash, user?.senha_hash);

    if (!match) {
      res.status(401).json({ message: "Credenciais inválidas" });
      return;
    }

    const userInfos = {
      id: user.id,
      name: user.nome,
      email: user.email,
      role: user.role,
      telefone: user.telefone,
    };

    if (!process.env.JWT_SECRET) {
      return;
    }

    const token = jwt.sign(userInfos, process.env.JWT_SECRET);

    res.cookie("user", token, {
      maxAge: 18000000,
    });

    res.status(200).json(userInfos);
  } catch (error) {
    res.status(500).json({ message: "Erro no servidor." });
    return;
  }
};

export const cadastroUsuario = async (req: Request, res: Response) => {
  try {
    const { nome, email, senha_hash, role, telefone } = req.body;
    console.log(req.body);

    console.log(nome, email, senha_hash, role, telefone);

    if (!nome || !email || !senha_hash || !telefone || !role) {
      res
        .status(400)
        .json({ message: "Todas as informações são obrigatórias" });
      return;
    }

    const hash = await bcrypt.hash(senha_hash, 10);

    const user = await prisma.usuario.findFirst({
      where: { email: email },
    });

    if (user?.email) {
      res.status(409).json({ message: "E-mail já cadastrado" });
      return;
    }
    
    if (user?.role !in role_enum) {
      res.status(400).json({ message: "Tipo de usuário inválido" });
      return;
    }
    
    const newUser = await prisma.usuario.create({
      data: { nome: nome, email: email, senha_hash: hash, role: role, telefone: telefone },
    });

    res.status(201).json(newUser);
  } catch (error) {
    res.status(500).json({ message: "Erro no servidor" });
    return;
  }
};

export const authUsuario = async (req: Request, res: Response) => {
  try {
    const { usuario } = req.body;
    res.status(200).json(usuario);
  } catch (error) {
    res.status(500).json({ message: "Erro no servidor" });
    return;
  }
};

export const logoutUsuario = async (req: Request, res: Response) => {
  const { user } = req.cookies;

  if (user) {
    res.clearCookie("user");
    res.json({ message: "Usuário deslogado" });
  }

  console.log(user);
};
