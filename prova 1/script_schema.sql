-- Tipos compostos
CREATE TYPE endereco AS (
    rua VARCHAR(255),
    numero VARCHAR(10),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    cep VARCHAR(10)
);

CREATE TYPE contato AS (
    email VARCHAR(255),
    telefone_principal VARCHAR(20),
    telefone_secundario VARCHAR(20)
);

-- Tabela de categorias de fidelidade
CREATE TABLE CATEGORIAS_FIDELIDADE (
    id SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(20) NOT NULL UNIQUE,
    percentual_desconto DECIMAL(5,2) NOT NULL
);

-- Tabela de clientes
CREATE TABLE CLIENTES (
    id SERIAL PRIMARY KEY,
    cpf_cnpj VARCHAR(14) NOT NULL UNIQUE,
    nome_razao_social VARCHAR(255) NOT NULL,
    endereco_cliente endereco,
    info_contato contato,
    data_nascimento_fundacao DATE,
    tipo_cliente VARCHAR(20) CHECK (tipo_cliente IN ('individual', 'corporativo', 'grupo')) NOT NULL,
    categoria_fidelidade_id INTEGER REFERENCES CATEGORIAS_FIDELIDADE(id),
    data_cadastro DATE DEFAULT CURRENT_DATE,
    status_cliente VARCHAR(20) CHECK (status_cliente IN ('ativo', 'inativo')) DEFAULT 'ativo'
);

-- Tabela de destinos
CREATE TABLE DESTINOS (
    id SERIAL PRIMARY KEY,
    codigo_destino VARCHAR(10) NOT NULL UNIQUE,
    nome_destino VARCHAR(255) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    estado_provincia VARCHAR(100),
    cidade_principal VARCHAR(100) NOT NULL,
    descricao_detalhada TEXT,
    clima_predominante VARCHAR(50),
    melhor_epoca_visitar VARCHAR(100),
    nivel_dificuldade VARCHAR(20) CHECK (nivel_dificuldade IN ('facil', 'moderado', 'dificil')),
    categoria_turistica VARCHAR(50) CHECK (categoria_turistica IN ('praia', 'montanha', 'cidade historica', 'aventura', 'cultural', 'gastronomico')),
    custo_medio_diario DECIMAL(10,2),
    idioma_local VARCHAR(50),
    moeda_local VARCHAR(10),
    documentacao_necessaria TEXT,
    status_destino VARCHAR(20) CHECK (status_destino IN ('ativo', 'inativo', 'sazonal')) DEFAULT 'ativo'
);

-- Tabela de pacotes turísticos
CREATE TABLE PACOTES_TURISTICOS (
    id SERIAL PRIMARY KEY,
    codigo_pacote VARCHAR(10) NOT NULL UNIQUE,
    nome_pacote VARCHAR(255) NOT NULL,
    descricao_detalhada TEXT,
    destino_principal_id INTEGER REFERENCES DESTINOS(id) NOT NULL,
    duracao_dias INTEGER NOT NULL,
    preco_base_por_pessoa DECIMAL(10,2) NOT NULL,
    categoria_pacote VARCHAR(20) CHECK (categoria_pacote IN ('economico', 'standard', 'premium', 'luxo')),
    tipo_viagem VARCHAR(20) CHECK (tipo_viagem IN ('individual', 'casal', 'familia', 'grupo')),
    inclui_transporte BOOLEAN,
    inclui_hospedagem BOOLEAN,
    inclui_alimentacao VARCHAR(20) CHECK (inclui_alimentacao IN ('cafe', 'meia pensao', 'pensao completa')),
    nivel_atividade_fisica VARCHAR(20) CHECK (nivel_atividade_fisica IN ('baixo', 'medio', 'alto')),
    idade_minima_recomendada INTEGER,
    idade_maxima_recomendada INTEGER,
    numero_maximo_participantes INTEGER,
    status_pacote VARCHAR(20) CHECK (status_pacote IN ('ativo', 'inativo', 'sazonal')) DEFAULT 'ativo'
);

-- Entidade associativa: pacotes x destinos secundários
CREATE TABLE PACOTES_DESTINOS_SECUNDARIOS (
    pacote_id INTEGER REFERENCES PACOTES_TURISTICOS(id),
    destino_secundario_id INTEGER REFERENCES DESTINOS(id),
    PRIMARY KEY (pacote_id, destino_secundario_id)
);

-- Tabela de reservas
CREATE TABLE RESERVAS (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES CLIENTES(id) NOT NULL,
    pacote_id INTEGER REFERENCES PACOTES_TURISTICOS(id) NOT NULL,
    data_reserva DATE DEFAULT CURRENT_DATE,
    data_inicio_viagem DATE NOT NULL,
    data_retorno DATE NOT NULL,
    numero_total_pessoas INTEGER NOT NULL,
    valor_total_reserva DECIMAL(10,2) NOT NULL,
    valor_entrada_pago DECIMAL(10,2),
    forma_pagamento VARCHAR(50),
    numero_parcelas INTEGER,
    data_limite_pagamento_final DATE,
    vendedor_responsavel VARCHAR(255),
    observacoes_especiais TEXT,
    status_reserva VARCHAR(20) CHECK (status_reserva IN ('pendente', 'confirmada', 'paga', 'cancelada', 'em andamento', 'finalizada')) DEFAULT 'pendente',
    motivo_cancelamento TEXT
);

-- Entidade associativa: participantes da reserva
CREATE TABLE PARTICIPANTES_RESERVA (
    reserva_id INTEGER REFERENCES RESERVAS(id),
    nome_participante VARCHAR(255) NOT NULL,
    PRIMARY KEY (reserva_id, nome_participante)
);

-- Função para calcular o valor restante a pagar
CREATE OR REPLACE FUNCTION calcular_valor_restante_a_pagar(p_valor_total DECIMAL, p_valor_entrada DECIMAL) RETURNS DECIMAL AS $$
BEGIN
    RETURN p_valor_total - COALESCE(p_valor_entrada, 0);
END;
$$ LANGUAGE plpgsql;



