# 🏥 Clínica FAM — Sistema Web Completo

> Sistema web multiprofissional para a Clínica FAM, especializada em Medicina de Família e Atenção Primária à Saúde — Fortaleza, CE.

![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)
![Sprint](https://img.shields.io/badge/sprint-3%20de%204-blue)
![Entrega](https://img.shields.io/badge/entrega%202-20%20Mai%202026-orange)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 📋 Sobre o Projeto

A Clínica FAM, fundada em 2018, é uma clínica multiprofissional localizada na Aldeota, Fortaleza-CE, com atendimento em Medicina de Família, Dermatologia, Psiquiatria, Nutrição, Cardiologia e mais. Com avaliação 5/5 estrelas em todas as plataformas, a clínica carecia de uma presença digital funcional — o domínio `clinicafam.com.br` retornava erro 500 e toda comunicação dependia de telefone, WhatsApp e redes sociais.

Este projeto desenvolve um sistema web completo com três módulos integrados, substituindo essa lacuna digital por uma plataforma moderna de autoatendimento.

---

## 🧩 Módulos do Sistema

### 🌐 Site Institucional
- Home com hero section e CTA de agendamento
- Página de especialidades com descrições detalhadas
- Corpo clínico com foto, nome, especialidade, CRM e mini-bio
- Convênios aceitos (Amil, Cassi, GEAP, Rede Saúde, Rede Mais Saúde)
- Blog/conteúdo educativo
- Contato + Google Maps interativo
- FAQ

### 👤 Portal do Paciente
- Login/Registro seguro
- Agendamento online 24/7
- Prontuário simplificado (read-only)
- Resultados de exames para download/visualização
- Mensageria assíncrona segura com o médico
- Link de teleconsulta (Google Meet/Jitsi)
- Extrato financeiro com status de pagamentos

### 🩺 Painel Médico / Admin
- Dashboard com métricas do dia
- Gestão de agenda e disponibilidade
- Notas de consulta
- Upload de resultados de exames
- Gestão de pacientes
- Relatórios administrativos

---

## 🛠️ Stack Tecnológica

| Camada | Tecnologia | Uso |
|--------|-----------|-----|
| **Frontend** | React + Tailwind CSS | Interface componentizada, responsiva |
| **Roteamento** | React Router | Navegação client-side |
| **HTTP Client** | Axios / Fetch | Comunicação com a API |
| **Tempo real** | Socket.io Client | Mensageria em tempo real |
| **Backend** | Node.js + Express | API RESTful e servidor |
| **Autenticação** | JWT + bcrypt | Tokens seguros com roles |
| **ORM** | Prisma | Type-safe, migrations automáticas |
| **Banco de dados** | PostgreSQL | Dados relacionais e médicos |
| **Mensageria** | Socket.io Server | Chat médico-paciente |

---

## 🏗️ Arquitetura

```
clinicafam/
├── frontend/                  # React SPA
│   ├── src/
│   │   ├── components/        # Componentes reutilizáveis
│   │   ├── pages/             # Páginas (Site, Portal, Painel)
│   │   ├── hooks/             # Custom hooks
│   │   ├── services/          # Chamadas à API (Axios)
│   │   └── context/           # Auth context, Socket context
│   └── public/
│
├── backend/                   # Node.js + Express
│   ├── src/
│   │   ├── controllers/       # Lógica de cada rota
│   │   ├── services/          # Regras de negócio
│   │   ├── middlewares/       # Auth JWT, validações
│   │   ├── routes/            # Definição das rotas REST
│   │   └── socket/            # Handlers Socket.io
│   └── prisma/
│       ├── schema.prisma      # Modelo de dados
│       └── migrations/
│
└── docs/                      # Documentação e plano de trabalho
```

### Fluxo de Comunicação

```
React SPA ──── HTTP/REST ────▶ Express API ──── Prisma ────▶ PostgreSQL
     │                              │
     └────── WebSocket (WS) ────────┘  (Socket.io — mensageria)
```

---

## 🗄️ Modelo de Dados

Entidades principais no PostgreSQL:

| Entidade | Descrição |
|----------|-----------|
| `Usuario` | Base de autenticação com roles (paciente, médico, admin) |
| `Paciente` | Dados clínicos, CPF, convênio — 1:1 com Usuario |
| `Medico` | CRM, especialidade, bio, foto — 1:1 com Usuario |
| `Disponibilidade` | Agenda semanal por horário do médico |
| `Agendamento` | Consulta agendada (paciente + médico + data/hora + link teleconsulta) |
| `Consulta` | Registro pós-atendimento com notas, diagnóstico, prescrição |
| `Exame` | Arquivo de resultado associado à consulta |
| `Mensagem` | Troca de mensagens médico-paciente com status de leitura |
| `Financeiro` | Cobranças, status e vencimento por paciente |

---

## 📋 Requisitos Funcionais

| Código | Descrição |
|--------|-----------|
| RF01 | Página inicial com serviços e CTA de agendamento |
| RF02 | Listagem de especialidades com descrições |
| RF03 | Corpo clínico com foto, CRM e mini-bio |
| RF04 | Convênios com logos e cobertura |
| RF05 | Contato com formulário e mapa interativo |
| RF06 | Registro de pacientes (nome, CPF, e-mail, telefone, nascimento) |
| RF07 | Autenticação JWT com roles: paciente, médico, admin |
| RF08 | Recuperação de senha por e-mail com token temporário |
| RF09 | Agendamento online por especialidade, médico, data e horário |
| RF10 | Prontuário simplificado read-only (histórico, diagnósticos, prescrições) |
| RF11 | Download/visualização de resultados de exames |
| RF12 | Mensageria assíncrona segura via Socket.io |
| RF13 | Geração de link de teleconsulta por agendamento |
| RF14 | Extrato financeiro com status de pagamentos |
| RF15 | Painel médico com agenda, disponibilidade e notas |
| RF16 | Dashboard administrativo com métricas gerais |

## ⚙️ Requisitos Não Funcionais

| Código | Categoria | Meta |
|--------|-----------|------|
| RNF01 | Responsividade | Mobile-first, adaptável a desktop, tablet e mobile |
| RNF02 | Performance | Carregamento inicial < 3s em conexão 4G |
| RNF03 | Segurança | bcrypt + JWT com expiração + HTTPS obrigatório |
| RNF04 | Usabilidade | Máximo 3 cliques para ações principais |
| RNF05 | Acessibilidade | WCAG 2.1 nível AA |
| RNF06 | Escalabilidade | Arquitetura modular para crescimento |
| RNF07 | Disponibilidade | Uptime mínimo de 99% |
| RNF08 | Manutenibilidade | Código documentado e componentizado |

---

## 🎨 Identidade Visual

**Conceito:** Neo-Frutiger Aero Médico — fusão da estética Frutiger Aero (natureza, otimismo, glassmorphism) com o Apple Liquid Glass.

### Paleta de Cores

| Nome | Hex | Uso |
|------|-----|-----|
| Deep Teal | `#1A3C40` | Header, textos principais |
| Mint Green | `#5DB89A` | CTAs, destaques |
| Soft Mint | `#7ECBAA` | Hover states, ícones |
| Sky Blue | `#7CC5D9` | Elementos secundários |
| Cloud White | `#F2F9F5` | Backgrounds |

### Tipografia
- **Headings:** Plus Jakarta Sans — humanist sans-serif
- **Body:** Inter — legível para conteúdo médico

### Princípios
- Glassmorphism com `backdrop-blur` nos painéis
- `border-radius` generoso (12–16px)
- Gradientes White → Mint → Sky Blue
- Negative space abundante
- Mobile-first, WCAG 2.1 AA

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos
- Node.js 20+
- PostgreSQL 15+
- npm ou yarn

### Instalação

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/clinicafam.git
cd clinicafam

# Backend
cd backend
npm install
cp .env.example .env       # Configure as variáveis de ambiente
npx prisma migrate dev     # Roda as migrations
npm run dev                # Inicia em http://localhost:3001

# Frontend (em outro terminal)
cd ../frontend
npm install
cp .env.example .env       # Configure VITE_API_URL
npm run dev                # Inicia em http://localhost:5173
```

### Variáveis de Ambiente

**Backend (`.env`)**
```env
DATABASE_URL="postgresql://user:password@localhost:5432/clinicafam"
JWT_SECRET="seu_segredo_jwt"
JWT_EXPIRES_IN="7d"
PORT=3001
```

**Frontend (`.env`)**
```env
VITE_API_URL=http://localhost:3001
VITE_SOCKET_URL=http://localhost:3001
```

---

## 📅 Cronograma

| Marco | Período | Entregáveis |
|-------|---------|-------------|
| **Entrega 1** | 07 Abr | Plano de Trabalho ✅ |
| Sprint 1 | 07–18 Abr | Setup, DB, Auth, estrutura base ✅ |
| Sprint 2 | 21 Abr–02 Mai | Site institucional, Portal paciente (MVP) ✅ |
| Sprint 3 | 05–16 Mai | Painel médico, Agendamento, Mensageria ⬅ *estamos aqui* |
| **Entrega 2** | 20 Mai | MVP funcional — apresentação |
| Sprint 4 | 21 Mai–Jun | Polimento, testes, relatório final |

---

## 👥 Equipe

| Membro | Papel | Responsabilidades |
|--------|-------|-------------------|
| **Felipe** | Front-end Developer | React, Tailwind, componentes, responsividade, animações |
| **Marcos Gomes** | Back-end Developer | Node.js/Express, PostgreSQL/Prisma, JWT, Socket.io, deploy |
| **Lucas Bomfim** | Designer UX/UI | Wireframes, protótipos, identidade visual, testes de usabilidade |
| **Emmanuel Dias** | Gerente de Projeto | Cronograma, integração, QA, apresentações, documentação |

---

## 📄 Documentação

- [`/docs/PlanoDeTrabalho_Entrega1.pdf`](./docs/PlanoDeTrabalho_Entrega1.pdf) — Plano de trabalho completo (Entrega 1)

---

## 📍 Sobre a Clínica FAM

**Clínica FAM — Medicina de Família Integrada**  
R. Osvaldo Cruz, 1089, 1º andar — Aldeota, Fortaleza-CE  
Fundada em 2018 | Avaliação 5/5 ⭐ em todas as plataformas  
Convênios: Amil, Cassi, GEAP, Rede Saúde, Rede Mais Saúde

---

*Projeto acadêmico — Desenvolvimento de Plataformas Web • 2026.1*
