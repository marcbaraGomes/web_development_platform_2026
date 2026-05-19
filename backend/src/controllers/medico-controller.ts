import type { Request, Response } from "express";
import { prisma } from "../db.js";

export const listMedicos = async (req: Request, res: Response) => {
  try {
    const medicos = await prisma.medico.findMany();

    if (medicos.length === 0) {
      res.status(404).json({ message: "Não foram encontrados medicos" });
      return;
    }

    res.json(medicos);
  } catch (error) {
    res.status(500).json({ message: "Erro no servidor" });
    return;
  }
};

export const cadastroMedico = async (req: Request, res: Response) => {
  try {
    const { bio, crm, foto_url, especialidade, usuario_id } = req.body;
    console.log(req.body);

    if (!bio || !crm || !especialidade || !usuario_id) {
      res
        .status(400)
        .json({ message: "Todas as informações são obrigatórias" });
      return;
    }

    const medico = await prisma.medico.findFirst({
      where: { crm: crm },
    });
    console.log(medico);
    
    if (medico?.crm) {
      res.status(409).json({ message: "CRM já cadastrado" });
      return;
    }
    
    if (medico?.usuario_id) {
      res.status(400).json({ message: "ID de usuário inválido" });
      return;
    }
    
    const newMedico = await prisma.medico.create({
      data: {bio: bio, crm: crm, foto_url: foto_url, especialidade: especialidade, usuario_id: usuario_id },
    });

    res.status(201).json(newMedico);
  } catch (error) {
    res.status(500).json({ message: "Erro no servidor" });
    return;
  }
};

export const deleteMedico = async (req: Request, res: Response) => {
  try {
    const { user } = req;
    const { crm } = req.body;

    if (!user?.admin) {
      res.status(400).json({ message: "Usuário não autorizado" });
      return;
    }

    if (!crm) {
      res.status(400).json({ message: "CRM não encontrado" });
      return;
    }

    const deletedMedico = await prisma.medico.delete({
      where: { crm: crm },
    });

    if (!deletedMedico) {
      res.status(404).json({ message: "Erro ao deletar o médico" });
      return;
    }

    res.json(crm);
  } catch (error: any) {
    if (error.code === "P2025") {
      res.json({ message: "Médico não encontrado." });
      return;
    }
    res.status(500).json({ message: "Erro no servidor" });
    return;
  }
};
