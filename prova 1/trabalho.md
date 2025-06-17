# Prova de Banco de Dados

**Aluno:** Gabriel Lucas Dias de Sant' Anna
**Professor:** Fábio Cardozo
**Curso:** Pós graduação em Administração de Banco de Dados
**Matéria:** Projeto de Banco de Dados

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
# QUESTÃO 2 - MODELO ENTIDADE RELACIONAMENTO (Atualizada e Revisada)

## a) Diagrama ER completo (Legenda)

- PK sinalizado com simbolo de uma chave dourada
- FG's sinalizads com simbolo de 2 chavas cor prata
- Cardinalidade demarcada no contado de cada linha de conexão entre as entidades.
- Não possui atributos multivalorados e nem entidades fracas

 <!-- Imagem do DER -->
 
---

## b) Entidades Associativas

No modelo, identificamos duas entidades associativas essenciais para a normalização e correta representação dos relacionamentos N:M e atributos multivalorados:

*   **PACOTES_DESTINOS_SECUNDARIOS**
    *   **Por que foi necessária:** Resolve o relacionamento N:M entre PACOTES_TURISTICOS e DESTINOS para destinos secundários, já que um pacote pode ter vários destinos secundários e um destino pode ser secundário em vários pacotes.
    *   **Relacionamento transformado:** N:M entre PACOTES_TURISTICOS e DESTINOS.
    *   **Atributos:** Chave primária composta (pacote_id, destino_secundario_id), ambas FKs.

*   **PARTICIPANTES_RESERVA**
    *   **Por que foi necessária:** Resolve o atributo multivalorado lista_nomes_participantes da entidade RESERVAS, permitindo que cada participante seja um registro individual.
    *   **Relacionamento transformado:** 1:N entre RESERVAS e PARTICIPANTES_RESERVA (cada reserva pode ter vários participantes).
    *   **Atributos:** Chave primária composta (reserva_id, nome_participante), sendo reserva_id FK.

---

## c) Restrições de Integridade

### Restrições de Domínio

*   **CLIENTES.tipo_cliente**: Deve ser 'individual', 'corporativo' ou 'grupo'.
*   **CLIENTES.categoria_fidelidade_id**: Deve referenciar um id válido em CATEGORIAS_FIDELIDADE.
*   **CLIENTES.status_cliente**: Deve ser 'ativo' ou 'inativo'.
*   **DESTINOS.nivel_dificuldade**: Deve ser 'facil', 'moderado' ou 'dificil'.
*   **DESTINOS.categoria_turistica**: Deve ser 'praia', 'montanha', 'cidade historica', 'aventura', 'cultural' ou 'gastronomico'.
*   **DESTINOS.status_destino**: Deve ser 'ativo', 'inativo' ou 'sazonal'.
*   **PACOTES_TURISTICOS.categoria_pacote**: Deve ser 'economico', 'standard', 'premium' ou 'luxo'.
*   **PACOTES_TURISTICOS.tipo_viagem**: Deve ser 'individual', 'casal', 'familia' ou 'grupo'.
*   **PACOTES_TURISTICOS.inclui_alimentacao**: Deve ser 'cafe', 'meia pensao' ou 'pensao completa'.
*   **PACOTES_TURISTICOS.nivel_atividade_fisica**: Deve ser 'baixo', 'medio' ou 'alto'.
*   **PACOTES_TURISTICOS.status_pacote**: Deve ser 'ativo', 'inativo' ou 'sazonal'.
*   **RESERVAS.forma_pagamento**: Deve ser 'cartao', 'transferencia', 'dinheiro' ou 'parcelado'.
*   **RESERVAS.status_reserva**: Deve ser 'pendente', 'confirmada', 'paga', 'cancelada', 'em andamento' ou 'finalizada'.

### Restrições de Integridade Referencial

*   **RESERVAS.cliente_id** referencia **CLIENTES.id**: Garante que toda reserva esteja associada a um cliente existente.
*   **PACOTES_TURISTICOS.destino_principal_id** referencia **DESTINOS.id**: Garante que todo pacote turístico tenha um destino principal existente.
*   **RESERVAS.pacote_id** referencia **PACOTES_TURISTICOS.id**: Garante que toda reserva esteja associada a um pacote turístico existente.
*   **PACOTES_DESTINOS_SECUNDARIOS.pacote_id** referencia **PACOTES_TURISTICOS.id**: Garante que cada associação de destino secundário esteja ligada a um pacote turístico existente.
*   **PACOTES_DESTINOS_SECUNDARIOS.destino_secundario_id** referencia **DESTINOS.id**: Garante que cada associação de destino secundário esteja ligada a um destino existente.
*   **PARTICIPANTES_RESERVA.reserva_id** referencia **RESERVAS.id**: Garante que cada participante esteja associado a uma reserva existente.

### Restrições de Negócio Específicas do Sistema

*   **Descontos por Categoria de Fidelidade**: Implementar lógica para aplicar descontos (15% para Platinum, 10% para Ouro, 5% para Prata) no `valor_total_reserva` com base em `CLIENTES.categoria_fidelidade`.
*   **Desconto para Grupos**: Se `RESERVAS.numero_total_pessoas` > 10, aplicar um desconto adicional de 10%.
*   **Regras de Cancelamento**: Lógica para calcular `motivo_cancelamento` e o valor da multa com base na `data_reserva` e `data_inicio_viagem`:
    *   Cancelamento até 30 dias antes: sem multa.
    *   Cancelamento entre 15-30 dias antes: multa de 20% do `valor_total_reserva`.
    *   Cancelamento com menos de 15 dias antes: multa de 50% do `valor_total_reserva`.
*   **Destino Principal Obrigatório**: `PACOTES_TURISTICOS.destino_principal_id` não pode ser nulo.
*   **Pacotes Sazonais**: Lógica para verificar a disponibilidade de pacotes com `PACOTES_TURISTICOS.status_pacote = 'sazonal'` em períodos específicos do ano (não modelado diretamente nas tabelas, mas uma regra de aplicação).
*   **Valor de Entrada Mínimo**: `RESERVAS.valor_entrada_pago` deve ser no mínimo 30% de `RESERVAS.valor_total_reserva`.
*   **Prazo de Pagamento para Clientes Corporativos**: Se `CLIENTES.tipo_cliente = 'corporativo'`, o `RESERVAS.data_limite_pagamento_final` deve ser estendido para 45 dias após a `data_reserva` (ou outra data de referência).



# QUESTÃO 3 - FORMAS NORMAIS

## a) Primeira Forma Normal (1FN)

A Primeira Forma Normal (1FN) exige que todos os atributos em uma tabela sejam atômicos, ou seja, não divisíveis, e que não existam grupos repetitivos de atributos. Além disso, cada linha deve ser única, o que é garantido pela chave primária.

Analisando as tabelas propostas, incluindo as novas entidades:

*   **CLIENTES**: Todos os atributos são atômicos. O `id` garante a unicidade de cada registro. Portanto, a tabela CLIENTES está em 1FN.
*   **DESTINOS**: Todos os atributos são atômicos. O `id` garante a unicidade de cada registro. Portanto, a tabela DESTINOS está em 1FN.
*   **PACOTES_TURISTICOS**: Todos os atributos são atômicos. O `id` garante a unicidade. Portanto, a tabela PACOTES_TURISTICOS está em 1FN.
*   **RESERVAS**: Todos os atributos são atômicos. O `id` garante a unicidade. Portanto, a tabela RESERVAS está em 1FN.
*   **PACOTES_DESTINOS_SECUNDARIOS**: Esta é uma entidade associativa. Seus atributos (`pacote_id`, `destino_secundario_id`) são atômicos e a chave primária composta (`pacote_id`, `destino_secundario_id`) garante a unicidade. Portanto, a tabela PACOTES_DESTINOS_SECUNDARIOS está em 1FN.
*   **PARTICIPANTES_RESERVA**: Esta é uma entidade para resolver o atributo multivalorado de nomes de participantes. Seus atributos (`reserva_id`, `nome_participante`) são atômicos e a chave primária composta (`reserva_id`, `nome_participante`) garante a unicidade. Portanto, a tabela PARTICIPANTES_RESERVA está em 1FN.

**Conclusão sobre 1FN**: Todas as tabelas no modelo atualizado estão em Primeira Forma Normal, pois todos os atributos são atômicos e não há grupos repetitivos, e cada registro é único.

## b) Segunda Forma Normal (2FN)

A Segunda Forma Normal (2FN) exige que a tabela esteja em 1FN e que todos os atributos não-chave dependam funcionalmente da chave primária *completa*. Isso é relevante para tabelas com chaves primárias compostas.

Analisando as tabelas propostas:

*   **CLIENTES, DESTINOS, PACOTES_TURISTICOS, RESERVAS**: Estas tabelas possuem chaves primárias simples (`id`). Se uma tabela está em 1FN e possui uma chave primária simples, ela automaticamente satisfaz a 2FN, pois não há dependências funcionais parciais da chave primária.

*   **PACOTES_DESTINOS_SECUNDARIOS**: A chave primária é composta por (`pacote_id`, `destino_secundario_id`). Não há atributos não-chave nesta tabela, apenas as chaves primárias e estrangeiras que compõem a chave primária. Portanto, não há dependências funcionais parciais, e a tabela está em 2FN.

*   **PARTICIPANTES_RESERVA**: A chave primária é composta por (`reserva_id`, `nome_participante`). Não há atributos não-chave nesta tabela, apenas as chaves primárias e estrangeiras que compõem a chave primária. Portanto, não há dependências funcionais parciais, e a tabela está em 2FN.

**Conclusão sobre 2FN**: Todas as tabelas no modelo atualizado estão em Segunda Forma Normal.

## c) Terceira Forma Normal (3FN)

A Terceira Forma Normal (3FN) exige que a tabela esteja em 2FN e que não existam dependências transitivas de atributos não-chave em relação à chave primária. Uma dependência transitiva ocorre quando um atributo não-chave depende de outro atributo não-chave, que por sua vez depende da chave primária.

Analisando as tabelas propostas:

*   **CLIENTES**: A tabela CLIENTES, em sua forma original, possuía o atributo `desconto_aplicavel`. A regra de negócio indica que o `desconto_aplicavel` é determinado pela `categoria_fidelidade` (e não diretamente pelo `cpf_cnpj`). Isso configura uma dependência transitiva: `cpf_cnpj` -> `categoria_fidelidade` -> `desconto_aplicavel`. Para alcançar a 3FN, o `desconto_aplicavel` deve ser removido da tabela `CLIENTES` e inferido através de uma tabela separada.
    *   **Correção Implementada:**
        *   Foi criada uma nova tabela `CATEGORIAS_FIDELIDADE` com os atributos `nome_categoria` (PK) e `percentual_desconto`. A tabela `CLIENTES` agora referencia `CATEGORIAS_FIDELIDADE` através de `categoria_fidelidade` (que atua como FK para `nome_categoria`). O `desconto_aplicavel` é obtido por consulta à `CATEGORIAS_FIDELIDADE`.

*   **DESTINOS**: Não há dependências transitivas. Todos os atributos dependem diretamente do `codigo_destino`. Portanto, a tabela DESTINOS está em 3FN.

*   **PACOTES_TURISTICOS**: Não há dependências transitivas. Todos os atributos dependem diretamente do `codigo_pacote`. Portanto, a tabela PACOTES_TURISTICOS está em 3FN.

*   **RESERVAS**: O atributo `valor_restante_a_pagar` foi removido da tabela. Conforme discutido, ele é um atributo derivado (`valor_total_reserva - valor_entrada_pago`) e, portanto, não deve ser armazenado para evitar redundância e inconsistência. Ele pode ser calculado por uma função ou view no banco de dados. Com essa remoção, a tabela RESERVAS está em 3FN.

*   **PACOTES_DESTINOS_SECUNDARIOS**: Não há atributos não-chave. Portanto, está em 3FN.

*   **PARTICIPANTES_RESERVA**: Não há atributos não-chave. Portanto, está em 3FN.

**Benefícios da Normalização até a 3FN para este sistema:**

*   **Redução de Redundância de Dados**: Evita a duplicação de informações, como o percentual de desconto para cada cliente Platinum, que agora é armazenado apenas uma vez na tabela `CATEGORIAS_FIDELIDADE`.
*   **Melhoria da Integridade dos Dados**: Garante que as informações sejam consistentes. Se o percentual de desconto para uma categoria de fidelidade mudar, a alteração precisa ser feita em apenas um local (na tabela `CATEGORIAS_FIDELIDADE`), evitando inconsistências. A remoção de `valor_restante_a_pagar` elimina a possibilidade de inconsistência entre o valor calculado e o valor armazenado.
*   **Facilitação de Consultas e Manutenção**: O modelo se torna mais claro e fácil de entender, o que simplifica a escrita de consultas e a manutenção do banco de dados. Alterações na estrutura ou nas regras de negócio são mais fáceis de implementar.
*   **Otimização de Armazenamento**: A remoção de dados redundantes leva a um uso mais eficiente do espaço de armazenamento.

Em resumo, a normalização para 3FN ajuda a criar um esquema de banco de dados mais robusto, flexível e fácil de gerenciar, minimizando problemas de inserção, atualização e exclusão de dados (anomalias de atualização).


# QUESTÃO 4 - BANCO DE DADOS ORIENTADO A OBJETOS

## a) Modelagem de uma Entidade como "Classe" Orientada a Objetos no PostgreSQL

No contexto do PostgreSQL, que é um SGBD relacional com recursos objeto-relacionais, podemos simular conceitos de BDOO utilizando tipos compostos, herança de tabelas e funções. A seguir, a modelagem da entidade **Cliente** como se fosse uma classe orientada a objetos, adaptada para o PostgreSQL.

### Tipos Compostos (Simulando atributos complexos)

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
```

### Herança de Tabelas (Simulando hierarquia de classes)

```sql
-- Tabela "pessoa" como superclasse
CREATE TABLE pessoa (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    data_nascimento DATE,
    info_contato contato,
    endereco_residencial endereco
);

-- Tabela "cliente" herdando de "pessoa"
CREATE TABLE cliente (
    cpf_cnpj VARCHAR(14) UNIQUE NOT NULL,
    data_cadastro DATE DEFAULT CURRENT_DATE,
    status_cliente VARCHAR(20) CHECK (status_cliente IN ('ativo', 'inativo')) DEFAULT 'ativo'
) INHERITS (pessoa);
```

### Métodos (Funções) para Regras de Negócio

#### 1. Calcular idade do cliente

```sql
CREATE OR REPLACE FUNCTION calcular_idade_cliente(p_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    data_nasc DATE;
BEGIN
    SELECT data_nascimento INTO data_nasc FROM pessoa WHERE id = p_id;
    RETURN EXTRACT(YEAR FROM AGE(NOW(), data_nasc));
END;
$$ LANGUAGE plpgsql;
```

#### 2. Ativar cliente

```sql
CREATE OR REPLACE FUNCTION ativar_cliente(p_id INTEGER)
RETURNS VOID AS $$
BEGIN
    UPDATE cliente SET status_cliente = 'ativo' WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;
```

#### 3. Verificar se cliente está ativo

```sql
CREATE OR REPLACE FUNCTION cliente_esta_ativo(p_id INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    ativo BOOLEAN;
BEGIN
    SELECT status_cliente = 'ativo' INTO ativo FROM cliente WHERE id = p_id;
    RETURN ativo;
END;
$$ LANGUAGE plpgsql;
```

## b) Implementação de um Método Específico

A seguir, um exemplo de função que verifica se o cliente pode realizar uma nova reserva, considerando que ele deve estar ativo e não pode ter mais de 5 reservas em aberto.

```sql
-- Função que verifica se o cliente pode realizar uma nova reserva
CREATE OR REPLACE FUNCTION pode_realizar_reserva(p_id_cliente INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    ativo BOOLEAN;
    qtd_reservas INTEGER;
BEGIN
    SELECT status_cliente = 'ativo' INTO ativo FROM cliente WHERE id = p_id_cliente;
    SELECT COUNT(*) INTO qtd_reservas FROM reservas WHERE cliente_id = p_id_cliente AND status_reserva IN ('pendente', 'confirmada', 'em andamento');
    RETURN ativo AND qtd_reservas < 5;
END;
$$ LANGUAGE plpgsql;
```
*Esta função encapsula a lógica de negócio diretamente no banco, como um método de uma classe.*

## c) Comparação: BDOO (PostgreSQL Objeto-Relacional) vs Banco Relacional Tradicional

**Vantagens do uso de recursos objeto-relacionais no PostgreSQL:**
- Permite reutilização de estruturas (tipos compostos) e herança de tabelas, aproximando o modelo do banco ao modelo de objetos da aplicação.
- Encapsula regras de negócio em funções, facilitando manutenção e integridade.
- Facilita a modelagem de atributos complexos e hierarquias.

**Desvantagens:**
- Consultas podem ficar mais complexas, especialmente com herança de tabelas.
- Nem todos os recursos de BDOO são suportados plenamente (ex: polimorfismo de métodos).
- Ferramentas de mercado e ORMs nem sempre suportam bem herança e tipos compostos.
- Performance pode ser impactada em cenários de consultas complexas ou grandes volumes de dados.

**Resumo:**  
O PostgreSQL permite simular muitos conceitos de BDOO, trazendo flexibilidade e expressividade ao modelo de dados. Porém, para sistemas com grande volume de dados e necessidade de relatórios complexos, o modelo relacional tradicional ainda pode ser mais eficiente e amplamente suportado.
