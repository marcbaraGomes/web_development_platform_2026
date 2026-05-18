-- ============================================================
-- Schema: Sistema de Saúde / Telemedicina
-- Banco: PostgreSQL
-- ============================================================

-- Extensões úteis
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- ENUM TYPES
-- ============================================================

CREATE TYPE role_enum AS ENUM ('admin', 'medico', 'paciente');

CREATE TYPE status_agendamento_enum AS ENUM (
    'pendente',
    'confirmado',
    'cancelado',
    'realizado'
);

CREATE TYPE tipo_consulta_enum AS ENUM (
    'presencial',
    'teleconsulta'
);

CREATE TYPE dia_semana_enum AS ENUM (
    'segunda',
    'terca',
    'quarta',
    'quinta',
    'sexta',
    'sabado',
    'domingo'
);

CREATE TYPE status_financeiro_enum AS ENUM (
    'pendente',
    'pago',
    'vencido',
    'cancelado'
);

-- ============================================================
-- TABELA: Usuario
-- ============================================================

CREATE TABLE usuario (
    id          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    nome        VARCHAR(150)    NOT NULL,
    email       VARCHAR(255)    NOT NULL UNIQUE,
    senha_hash  TEXT            NOT NULL,
    role        role_enum       NOT NULL DEFAULT 'paciente',
    telefone    VARCHAR(20),
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- ============================================================
-- TABELA: Paciente  (1:1 com Usuario)
-- ============================================================

CREATE TABLE paciente (
    id          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id  UUID            NOT NULL UNIQUE REFERENCES usuario(id) ON DELETE CASCADE,
    cpf         VARCHAR(14)     NOT NULL UNIQUE,
    data_nasc   DATE            NOT NULL,
    endereco    TEXT,
    convenio    VARCHAR(100)
);

-- ============================================================
-- TABELA: Medico  (1:1 com Usuario)
-- ============================================================

CREATE TABLE medico (
    id          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id  UUID            NOT NULL UNIQUE REFERENCES usuario(id) ON DELETE CASCADE,
    crm         VARCHAR(20)     NOT NULL UNIQUE,
    especialidade VARCHAR(100)  NOT NULL,
    bio         TEXT,
    foto_url    TEXT
);

-- ============================================================
-- TABELA: Disponibilidade  (1:N com Medico)
-- ============================================================

CREATE TABLE disponibilidade (
    id          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    medico_id   UUID            NOT NULL REFERENCES medico(id) ON DELETE CASCADE,
    dia_semana  dia_semana_enum NOT NULL,
    hora_inicio TIME            NOT NULL,
    hora_fim    TIME            NOT NULL,
    ativo       BOOLEAN         NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_hora_disponibilidade CHECK (hora_fim > hora_inicio)
);

-- ============================================================
-- TABELA: Agendamento  (N:1 Paciente, N:1 Medico)
-- ============================================================

CREATE TABLE agendamento (
    id              UUID                        PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id     UUID                        NOT NULL REFERENCES paciente(id) ON DELETE RESTRICT,
    medico_id       UUID                        NOT NULL REFERENCES medico(id)   ON DELETE RESTRICT,
    data_hora       TIMESTAMPTZ                 NOT NULL,
    status          status_agendamento_enum      NOT NULL DEFAULT 'pendente',
    tipo_consulta   tipo_consulta_enum           NOT NULL DEFAULT 'presencial',
    link_teleconsulta TEXT
);

-- ============================================================
-- TABELA: Consulta  (1:1 com Agendamento)
-- ============================================================

CREATE TABLE consulta (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    agendamento_id  UUID        NOT NULL UNIQUE REFERENCES agendamento(id) ON DELETE CASCADE,
    notas           TEXT,
    diagnostico     TEXT,
    prescricao      TEXT,
    data_realizada  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- TABELA: Exame  (N:1 Consulta, N:1 Paciente)
-- ============================================================

CREATE TABLE exame (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    consulta_id UUID        NOT NULL REFERENCES consulta(id)  ON DELETE CASCADE,
    paciente_id UUID        NOT NULL REFERENCES paciente(id)  ON DELETE RESTRICT,
    tipo        VARCHAR(100) NOT NULL,
    arquivo_url TEXT,
    data_upload TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ============================================================
-- TABELA: Financeiro  (N:1 Paciente)
-- ============================================================

CREATE TABLE financeiro (
    id          UUID                    PRIMARY KEY DEFAULT gen_random_uuid(),
    paciente_id UUID                    NOT NULL REFERENCES paciente(id) ON DELETE RESTRICT,
    descricao   TEXT                    NOT NULL,
    valor       NUMERIC(10, 2)          NOT NULL CHECK (valor >= 0),
    status      status_financeiro_enum  NOT NULL DEFAULT 'pendente',
    data_venc   DATE                    NOT NULL
);

-- ============================================================
-- TABELA: Mensagem  (N:N entre Usuarios — remetente/destinatário)
-- ============================================================

CREATE TABLE mensagem (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    remetente_id    UUID        NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
    destinatario_id UUID        NOT NULL REFERENCES usuario(id) ON DELETE CASCADE,
    conteudo        TEXT        NOT NULL,
    lida            BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_mensagem_self CHECK (remetente_id <> destinatario_id)
);

-- ============================================================
-- ÍNDICES
-- ============================================================

-- Agendamento
CREATE INDEX idx_agendamento_paciente  ON agendamento(paciente_id);
CREATE INDEX idx_agendamento_medico    ON agendamento(medico_id);
CREATE INDEX idx_agendamento_data_hora ON agendamento(data_hora);
CREATE INDEX idx_agendamento_status    ON agendamento(status);

-- Disponibilidade
CREATE INDEX idx_disponibilidade_medico ON disponibilidade(medico_id);

-- Exame
CREATE INDEX idx_exame_consulta  ON exame(consulta_id);
CREATE INDEX idx_exame_paciente  ON exame(paciente_id);

-- Financeiro
CREATE INDEX idx_financeiro_paciente   ON financeiro(paciente_id);
CREATE INDEX idx_financeiro_data_venc  ON financeiro(data_venc);
CREATE INDEX idx_financeiro_status     ON financeiro(status);

-- Mensagem
CREATE INDEX idx_mensagem_remetente    ON mensagem(remetente_id);
CREATE INDEX idx_mensagem_destinatario ON mensagem(destinatario_id);
CREATE INDEX idx_mensagem_lida         ON mensagem(lida) WHERE lida = FALSE;