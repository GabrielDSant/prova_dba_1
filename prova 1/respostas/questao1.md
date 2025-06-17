# QUESTÃO 1 - MODELAGEM CONCEITUAL E LÓGICA

## a) Identificação e Listagem de Entidades e Atributos

Com base no mini mundo apresentado do Sistema de Gestão da Agência de Turismo "Mundo Aventura" e considerando a flexibilidade do PostgreSQL para abordar conceitos de BDOO, as seguintes entidades foram identificadas, juntamente com seus principais atributos, chaves primárias (PK), chaves estrangeiras (FK) e tipos de dados sugeridos. Notamos a aplicação de **tipos compostos** para atributos que representam estruturas complexas, alinhando-se à discussão da Questão 4.

### Entidade: CLIENTES
*   **Descrição**: Representa os diferentes perfis de clientes da agência, sejam eles individuais, corporativos ou grupos organizados.
*   **Atributos**:
    *   `id` SERIAL - **Chave Primária (PK)**. Identificador único do cliente.
    *   `cpf_cnpj`: VARCHAR(14) - Identificador único para clientes (CPF para individuais, CNPJ para corporativos/grupos). **UNIQUE**
    *   `nome_razao_social`: VARCHAR(255) - Nome completo do cliente ou razão social da empresa.
    *   `endereco_cliente`: `endereco` (Tipo Composto) - Endereço completo (rua, número, bairro, cidade, estado, CEP).
    *   `info_contato`: `contato` (Tipo Composto) - Informações de contato (email, telefone principal, telefone secundário).
    *   `data_nascimento_fundacao`: DATE - Data de nascimento para clientes individuais ou data de fundação para corporativos/grupos.
    *   `tipo_cliente`: VARCHAR(20) - Categoria do cliente (ex: 'individual', 'corporativo', 'grupo').
    *   `categoria_fidelidade_id`: INTEGER - **Chave Estrangeira (FK)** referenciando `CATEGORIAS_FIDELIDADE.id`. Nível de fidelidade do cliente.
    *   `data_cadastro`: DATE - Data em que o cliente foi cadastrado no sistema.
    *   `status_cliente`: VARCHAR(20) - Situação do cliente (ex: 'ativo', 'inativo').

### Entidade: DESTINOS
*   **Descrição**: Representa os locais turísticos para os quais a agência oferece pacotes.
*   **Atributos**:
    *   `id` SERIAL - **Chave Primária (PK)**. Identificador único do destino.
    *   `codigo_destino`: VARCHAR(10) - Código identificador único do destino. **UNIQUE**
    *   `nome_destino`: VARCHAR(255) - Nome do destino turístico.
    *   `pais`: VARCHAR(100) - País onde o destino está localizado.
    *   `estado_provincia`: VARCHAR(100) - Estado ou província do destino.
    *   `cidade_principal`: VARCHAR(100) - Cidade principal do destino.
    *   `descricao_detalhada`: TEXT - Descrição abrangente do destino.
    *   `clima_predominante`: VARCHAR(50) - Tipo de clima predominante no destino.
    *   `melhor_epoca_visitar`: VARCHAR(100) - Meses ideais para visitar o destino.
    *   `nivel_dificuldade`: VARCHAR(20) - Nível de dificuldade associado ao destino (ex: 'facil', 'moderado', 'dificil').
    *   `categoria_turistica`: VARCHAR(50) - Categoria do turismo (ex: 'praia', 'montanha', 'cidade historica', 'aventura', 'cultural', 'gastronomico').
    *   `custo_medio_diario`: DECIMAL(10,2) - Custo médio diário estimado para o destino.
    *   `idioma_local`: VARCHAR(50) - Idioma(s) falado(s) no local.
    *   `moeda_local`: VARCHAR(10) - Moeda utilizada no destino.
    *   `documentacao_necessaria`: TEXT - Informações sobre documentos exigidos para o destino.
    *   `status_destino`: VARCHAR(20) - Situação do destino (ex: 'ativo', 'inativo', 'sazonal').

### Entidade: PACOTES_TURISTICOS
*   **Descrição**: Representa os pacotes de viagem pré-definidos oferecidos pela agência.
*   **Atributos**:
    *   `id` SERIAL - **Chave Primária (PK)**. Identificador único do pacote.
    *   `codigo_pacote`: VARCHAR(10) - Código identificador único do pacote. **UNIQUE**
    *   `nome_pacote`: VARCHAR(255) - Nome do pacote turístico.
    *   `descricao_detalhada`: TEXT - Descrição detalhada do pacote.
    *   `destino_principal_id`: INTEGER - **Chave Estrangeira (FK)** referenciando `DESTINOS.id`. O destino principal do pacote.
    *   `duracao_dias`: INTEGER - Duração total do pacote em dias.
    *   `preco_base_por_pessoa`: DECIMAL(10,2) - Preço base por pessoa para o pacote.
    *   `categoria_pacote`: VARCHAR(20) - Categoria do pacote (ex: 'economico', 'standard', 'premium', 'luxo').
    *   `tipo_viagem`: VARCHAR(20) - Tipo de viagem para o qual o pacote é adequado (ex: 'individual', 'casal', 'familia', 'grupo').
    *   `inclui_transporte`: BOOLEAN - Indica se o pacote inclui transporte (sim/não).
    *   `inclui_hospedagem`: BOOLEAN - Indica se o pacote inclui hospedagem (sim/não).
    *   `inclui_alimentacao`: VARCHAR(20) - Tipo de alimentação incluída (ex: 'cafe', 'meia pensao', 'pensao completa').
    *   `nivel_atividade_fisica`: VARCHAR(20) - Nível de atividade física requerido (ex: 'baixo', 'medio', 'alto').
    *   `idade_minima_recomendada`: INTEGER - Idade mínima recomendada para o pacote.
    *   `idade_maxima_recomendada`: INTEGER - Idade máxima recomendada para o pacote.
    *   `numero_maximo_participantes`: INTEGER - Número máximo de participantes permitidos no pacote.
    *   `status_pacote`: VARCHAR(20) - Situação do pacote (ex: 'ativo', 'inativo', 'sazonal').

### Entidade: RESERVAS
*   **Descrição**: Controla todas as reservas e vendas realizadas pela agência.
*   **Atributos**:
    *   `id` SERIAL - **Chave Primária (PK)**. Identificador único da reserva.
    *   `cliente_id`: INTEGER - **Chave Estrangeira (FK)** referenciando `CLIENTES.id`. O cliente que realizou a reserva.
    *   `pacote_id`: INTEGER - **Chave Estrangeira (FK)** referenciando `PACOTES_TURISTICOS.id`. O pacote turístico reservado.
    *   `data_reserva`: DATE - Data em que a reserva foi efetuada.
    *   `data_inicio_viagem`: DATE - Data de início da viagem.
    *   `data_retorno`: DATE - Data de retorno da viagem.
    *   `numero_total_pessoas`: INTEGER - Número total de pessoas incluídas na reserva.
    *   `valor_total_reserva`: DECIMAL(10,2) - Valor total da reserva.
    *   `valor_entrada_pago`: DECIMAL(10,2) - Valor já pago como entrada.
    *   `forma_pagamento`: VARCHAR(50) - Método de pagamento (ex: 'cartão', 'transferência', 'dinheiro', 'parcelado').
    *   `numero_parcelas`: INTEGER - Número de parcelas, se a forma de pagamento for 'parcelado' (opcional).
    *   `data_limite_pagamento_final`: DATE - Data limite para o pagamento final da reserva.
    *   `vendedor_responsavel`: VARCHAR(255) - Nome ou identificador do vendedor que realizou a reserva.
    *   `observacoes_especiais`: TEXT - Quaisquer observações adicionais sobre a reserva.
    *   `status_reserva`: VARCHAR(20) - Situação atual da reserva (ex: 'pendente', 'confirmada', 'paga', 'cancelada', 'em andamento', 'finalizada').
    *   `motivo_cancelamento`: TEXT - Motivo do cancelamento, se aplicável (opcional).
    *   **Nota**: O atributo `valor_restante_a_pagar` é um valor derivado (`valor_total_reserva - valor_entrada_pago`) e, portanto, não é armazenado diretamente na tabela para evitar redundância e inconsistências. Ele pode ser calculado por uma função ou view no banco de dados.

### Entidade: PACOTES_DESTINOS_SECUNDARIOS
*   **Descrição**: Entidade associativa para representar os múltiplos destinos secundários que um pacote turístico pode ter, e um destino pode ser secundário em múltiplos pacotes. Resolve o relacionamento N:M entre `PACOTES_TURISTICOS` e `DESTINOS` para destinos secundários.
*   **Atributos**:
    *   `pacote_id`: INTEGER - **Chave Primária (PK), Chave Estrangeira (FK)** referenciando `PACOTES_TURISTICOS.id`.
    *   `destino_secundario_id`: INTEGER - **Chave Primária (PK), Chave Estrangeira (FK)** referenciando `DESTINOS.id`.
    *   **Chave Primária Composta**: (`pacote_id`, `destino_secundario_id`)

### Entidade: PARTICIPANTES_RESERVA
*   **Descrição**: Entidade para armazenar os nomes dos participantes de uma reserva. Resolve o atributo multivalorado `lista_nomes_participantes` da entidade `RESERVAS`.
*   **Atributos**:
    *   `reserva_id`: INTEGER - **Chave Primária (PK), Chave Estrangeira (FK)** referenciando `RESERVAS.id`.
    *   `nome_participante`: VARCHAR(255) - **Chave Primária (PK)**. Nome completo do participante.
    *   **Chave Primária Composta**: (`reserva_id`, `nome_participante`)

### Entidade: CATEGORIAS_FIDELIDADE
*   **Descrição**: Armazena as diferentes categorias de fidelidade e seus respectivos percentuais de desconto.
*   **Atributos**:
    *   `id` SERIAL - **Chave Primária (PK)**. Identificador único da categoria.
    *   `nome_categoria`: VARCHAR(20) - Nome da categoria (ex: 'bronze', 'prata', 'ouro', 'platinum'). **UNIQUE**
    *   `percentual_desconto`: DECIMAL(5,2) - Percentual de desconto associado à categoria.
    
## b) Identificação e Descrição dos Relacionamentos

Os relacionamentos entre as entidades são fundamentais para a integridade e funcionalidade do banco de dados. Abaixo, descrevemos os relacionamentos identificados, suas cardinalidades e justificativas, com a devida atenção às entidades associativas e à representação de atributos complexos.

### Relacionamento 1: CLIENTES e RESERVAS
*   **Entidades Envolvidas**: CLIENTES e RESERVAS.
*   **Cardinalidade**: 1:N (Um para Muitos).
*   **Descrição**: Um cliente pode realizar múltiplas reservas ao longo do tempo, mas cada reserva é associada a um único cliente responsável.
*   **Atributos do Relacionamento**: Não há atributos específicos no relacionamento em si, pois a chave estrangeira `cliente_id` na tabela `RESERVAS` já estabelece a ligação.
*   **Justificativa para a Cardinalidade Escolhida**: A regra de negócio indica que o `cliente_responsavel` é quem contrata o pacote, e um cliente pode ter um histórico de várias reservas. No entanto, uma reserva específica é sempre atribuída a um único cliente responsável. Isso é modelado pela chave estrangeira `cliente_id` em `RESERVAS` que referencia a chave primária `id` em `CLIENTES`.

### Relacionamento 2: DESTINOS e PACOTES_TURISTICOS (Destino Principal)
*   **Entidades Envolvidas**: DESTINOS e PACOTES_TURISTICOS.
*   **Cardinalidade**: 1:N (Um para Muitos).
*   **Descrição**: Um destino turístico pode ser o destino principal de vários pacotes turísticos, mas cada pacote turístico possui apenas um destino principal.
*   **Atributos do Relacionamento**: Não há atributos específicos no relacionamento.
*   **Justificativa para a Cardinalidade Escolhida**: A regra de negócio estabelece que "Cada pacote deve ter obrigatoriamente um destino principal". Isso significa que um pacote está ligado a um único destino como seu principal. Por outro lado, um destino como Paris pode ser o destino principal de diversos pacotes (ex: "Pacote Paris Romântica", "Pacote Paris Cultural"). A chave estrangeira `destino_principal_id` em `PACOTES_TURISTICOS` que referencia `id` em `DESTINOS` reflete essa cardinalidade.

### Relacionamento 3: PACOTES_TURISTICOS e RESERVAS
*   **Entidades Envolvidas**: PACOTES_TURISTICOS e RESERVAS.
*   **Cardinalidade**: 1:N (Um para Muitos).
*   **Descrição**: Um pacote turístico pode ser contratado em várias reservas, mas cada reserva é feita para um único pacote turístico.
*   **Atributos do Relacionamento**: Não há atributos específicos no relacionamento.
*   **Justificativa para a Cardinalidade Escolhida**: Uma reserva é a contratação de um pacote específico. Portanto, uma reserva aponta para um único pacote. No entanto, o mesmo pacote turístico (ex: "Pacote Aventura na Amazônia") pode ser reservado por múltiplos clientes em diferentes ocasiões. A chave estrangeira `pacote_id` em `RESERVAS` que referencia `id` em `PACOTES_TURISTICOS` estabelece essa relação.

### Relacionamento 4: PACOTES_TURISTICOS e DESTINOS (Destinos Secundários)
*   **Entidades Envolvidas**: PACOTES_TURISTICOS e DESTINOS, através da entidade associativa `PACOTES_DESTINOS_SECUNDARIOS`.
*   **Cardinalidade**: N:M (Muitos para Muitos).
*   **Descrição**: Um pacote turístico pode incluir múltiplos destinos secundários, e um destino pode ser um destino secundário em múltiplos pacotes turísticos.
*   **Atributos do Relacionamento**: Não há atributos adicionais no relacionamento em si, mas a entidade associativa `PACOTES_DESTINOS_SECUNDARIOS` contém as chaves estrangeiras de `PACOTES_TURISTICOS` e `DESTINOS`.
*   **Justificativa para a Cardinalidade Escolhida**: O atributo `destinos_secundarios_incluidos` no texto original indicava uma lista de valores, o que é uma violação da 1FN e representa um relacionamento N:M implícito. Para normalizar, foi criada a entidade associativa `PACOTES_DESTINOS_SECUNDARIOS`, que permite que um pacote esteja associado a vários destinos secundários e que um destino seja secundário em vários pacotes. A chave primária composta (`pacote_id`, `destino_secundario_id`) garante a unicidade de cada par pacote-destino secundário.

### Relacionamento 5: RESERVAS e PARTICIPANTES_RESERVA
*   **Entidades Envolvidas**: RESERVAS e PARTICIPANTES_RESERVA.
*   **Cardinalidade**: 1:N (Um para Muitos).
*   **Descrição**: Uma reserva pode ter múltiplos participantes, e cada participante está associado a uma única reserva.
*   **Atributos do Relacionamento**: Não há atributos adicionais no relacionamento em si, mas a entidade `PARTICIPANTES_RESERVA` contém a chave estrangeira de `RESERVAS` e o nome do participante.
*   **Justificativa para a Cardinalidade Escolhida**: O atributo `lista_nomes_participantes` no texto original era um atributo multivalorado, violando a 1FN. Para normalizar, foi criada a entidade `PARTICIPANTES_RESERVA`, onde cada nome de participante é um registro separado, associado à sua respectiva reserva. A chave primária composta (`reserva_id`, `nome_participante`) garante a unicidade de cada participante dentro de uma reserva.

## c) Modelo Lógico Relacional Resultante

### SGDB usado = postgreeSQL

```sql
-- Tipo composto para endereço
CREATE TYPE endereco AS (
    rua VARCHAR(255),
    numero VARCHAR(10),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    cep VARCHAR(10)
);

-- Tipo composto para contato
CREATE TYPE contato AS (
    email VARCHAR(255),
    telefone_principal VARCHAR(20),
    telefone_secundario VARCHAR(20)
);

-- Tabela: CATEGORIAS_FIDELIDADE
CREATE TABLE CATEGORIAS_FIDELIDADE (
    id SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(20) NOT NULL UNIQUE,
    percentual_desconto DECIMAL(5,2) NOT NULL
);

-- Tabela: CLIENTES
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
    -- PK: id
    -- FK: categoria_fidelidade_id → CATEGORIAS_FIDELIDADE(id)
);

-- Tabela: DESTINOS
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
    -- PK: id
);

-- Tabela: PACOTES_TURISTICOS
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
    -- PK: id
    -- FK: destino_principal_id → DESTINOS(id)
);

-- Tabela: RESERVAS
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
    -- PK: id
    -- FK: cliente_id → CLIENTES(id)
    -- FK: pacote_id → PACOTES_TURISTICOS(id)
);

-- Tabela: PACOTES_DESTINOS_SECUNDARIOS (associativa N:M)
CREATE TABLE PACOTES_DESTINOS_SECUNDARIOS (
    pacote_id INTEGER REFERENCES PACOTES_TURISTICOS(id),
    destino_secundario_id INTEGER REFERENCES DESTINOS(id),
    PRIMARY KEY (pacote_id, destino_secundario_id)
    -- PK: (pacote_id, destino_secundario_id)
    -- FK: pacote_id → PACOTES_TURISTICOS(id)
    -- FK: destino_secundario_id → DESTINOS(id)
);

-- Tabela: PARTICIPANTES_RESERVA (associativa 1:N)
CREATE TABLE PARTICIPANTES_RESERVA (
    reserva_id INTEGER REFERENCES RESERVAS(id),
    nome_participante VARCHAR(255) NOT NULL,
    PRIMARY KEY (reserva_id, nome_participante)
    -- PK: (reserva_id, nome_participante)
    -- FK: reserva_id → RESERVAS(id)
);
```
