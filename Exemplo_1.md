A empresa AgroMais S.A. atua na compra, produção e distribuição de insumos agrícolas em todo o território nacional. O negócio envolve fornecedores diversos, produção em centros agroindustriais, estoques regionais e uma ampla carteira de clientes, que incluem cooperativas, fazendas e grandes redes varejistas.

Com o crescimento da operação, a empresa deseja informatizar e centralizar suas operações em um novo sistema, que será construído sobre um banco de dados **PostgreSQL**. A equipe de desenvolvimento solicitou sua atuação como especialista em banco de dados para:

- Projetar toda a estrutura de dados, incluindo modelagens em seus níveis adequados;
- Garantir que o modelo suporte operações de controle de estoque, pedidos, rastreamento de produtos e gestão de fornecedores;
- Prever escalabilidade e consultas eficientes;
- Considerar questões de integridade dos dados e possíveis regras de negócio específicas do setor agroindustrial.

# Modelo Conceitual

## Entidades

- **Insumo**
- **Fornecedor**
- **CentroAgroIndustrial**
- **EstoqueRegional**
- **Cliente**

## Relacionamentos

- Um **Fornecedor** fornece um ou mais **Insumos** (1:N)
- Um **Insumo** pode ser produzido em um ou mais **CentrosAgroIndustriais** (1:N)
- Um **CentroAgroIndustrial** abastece um ou mais **EstoquesRegionais** (1:N)
- Um **EstoqueRegional** armazena diferentes **Insumos** (1:N)
- Um **Cliente** realiza **Pedidos** de **Insumos** que são atendidos a partir dos **EstoquesRegionais**
- O rastreamento de **Insumos** ocorre desde o **Fornecedor** até o **Cliente**, passando por produção, armazenamento e distribuição

# Modelo Lógico (PostgreSQL)

```sql
CREATE TABLE fornecedor (
    fornecedor_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(20) UNIQUE NOT NULL,
    contato VARCHAR(100)
);

CREATE TABLE insumo (
    insumo_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    unidade_medida VARCHAR(20)
);

CREATE TABLE centro_agroindustrial (
    centro_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    localizacao VARCHAR(200)
);

CREATE TABLE estoque_regional (
    estoque_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    regiao VARCHAR(100),
    centro_id INTEGER REFERENCES centro_agroindustrial(centro_id)
);

CREATE TABLE cliente (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50), -- Cooperativa, Fazenda, Varejista
    contato VARCHAR(100)
);

CREATE TABLE pedido (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES cliente(cliente_id),
    data_pedido DATE NOT NULL,
    status VARCHAR(50)
);

-- Relacionamentos

CREATE TABLE fornecedor_insumo (
    fornecedor_id INTEGER REFERENCES fornecedor(fornecedor_id),
    insumo_id INTEGER REFERENCES insumo(insumo_id),
    PRIMARY KEY (fornecedor_id, insumo_id)
);

CREATE TABLE insumo_centro (
    insumo_id INTEGER REFERENCES insumo(insumo_id),
    centro_id INTEGER REFERENCES centro_agroindustrial(centro_id),
    PRIMARY KEY (insumo_id, centro_id)
);

CREATE TABLE estoque_insumo (
    estoque_id INTEGER REFERENCES estoque_regional(estoque_id),
    insumo_id INTEGER REFERENCES insumo(insumo_id),
    quantidade NUMERIC(15,2) NOT NULL,
    PRIMARY KEY (estoque_id, insumo_id)
);

CREATE TABLE pedido_item (
    pedido_id INTEGER REFERENCES pedido(pedido_id),
    insumo_id INTEGER REFERENCES insumo(insumo_id),
    estoque_id INTEGER REFERENCES estoque_regional(estoque_id),
    quantidade NUMERIC(15,2) NOT NULL,
    PRIMARY KEY (pedido_id, insumo_id, estoque_id)
);

-- Tabela para rastreamento de insumos
CREATE TABLE rastreio_insumo (
    rastreio_id SERIAL PRIMARY KEY,
    insumo_id INTEGER REFERENCES insumo(insumo_id),
    fornecedor_id INTEGER REFERENCES fornecedor(fornecedor_id),
    centro_id INTEGER REFERENCES centro_agroindustrial(centro_id),
    estoque_id INTEGER REFERENCES estoque_regional(estoque_id),
    cliente_id INTEGER REFERENCES cliente(cliente_id),
    data_evento TIMESTAMP NOT NULL,
    evento VARCHAR(100) -- Ex: Produzido, Transferido, Vendido
);
```
# Modelo Fisico

### Considerações Gerais

- Utilização de tipos de dados adequados para cada campo.
- Definição de índices para otimizar consultas frequentes.
- Criação de constraints para garantir integridade referencial e regras de negócio.
- Uso de sequences automáticas para chaves primárias (SERIAL).
- Comentários para documentação dos objetos.

### Script de Criação

```sql
-- Tabela: fornecedor
CREATE TABLE fornecedor (
    fornecedor_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(20) UNIQUE NOT NULL,
    contato VARCHAR(100)
);

COMMENT ON TABLE fornecedor IS 'Cadastro de fornecedores de insumos';
COMMENT ON COLUMN fornecedor.cnpj IS 'Cadastro Nacional da Pessoa Jurídica';

-- Tabela: insumo
CREATE TABLE insumo (
    insumo_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    unidade_medida VARCHAR(20)
);

COMMENT ON TABLE insumo IS 'Insumos agrícolas comercializados';

-- Tabela: centro_agroindustrial
CREATE TABLE centro_agroindustrial (
    centro_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    localizacao VARCHAR(200)
);

COMMENT ON TABLE centro_agroindustrial IS 'Centros de produção agroindustrial';

-- Tabela: estoque_regional
CREATE TABLE estoque_regional (
    estoque_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    regiao VARCHAR(100),
    centro_id INTEGER NOT NULL REFERENCES centro_agroindustrial(centro_id)
);

CREATE INDEX idx_estoque_regional_centro ON estoque_regional(centro_id);

-- Tabela: cliente
CREATE TABLE cliente (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50),
    contato VARCHAR(100)
);

-- Tabela: pedido
CREATE TABLE pedido (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES cliente(cliente_id),
    data_pedido DATE NOT NULL,
    status VARCHAR(50)
);

CREATE INDEX idx_pedido_cliente ON pedido(cliente_id);

-- Relacionamento: fornecedor_insumo
CREATE TABLE fornecedor_insumo (
    fornecedor_id INTEGER NOT NULL REFERENCES fornecedor(fornecedor_id),
    insumo_id INTEGER NOT NULL REFERENCES insumo(insumo_id),
    PRIMARY KEY (fornecedor_id, insumo_id)
);

CREATE INDEX idx_fornecedor_insumo_insumo ON fornecedor_insumo(insumo_id);

-- Relacionamento: insumo_centro
CREATE TABLE insumo_centro (
    insumo_id INTEGER NOT NULL REFERENCES insumo(insumo_id),
    centro_id INTEGER NOT NULL REFERENCES centro_agroindustrial(centro_id),
    PRIMARY KEY (insumo_id, centro_id)
);

CREATE INDEX idx_insumo_centro_centro ON insumo_centro(centro_id);

-- Relacionamento: estoque_insumo
CREATE TABLE estoque_insumo (
    estoque_id INTEGER NOT NULL REFERENCES estoque_regional(estoque_id),
    insumo_id INTEGER NOT NULL REFERENCES insumo(insumo_id),
    quantidade NUMERIC(15,2) NOT NULL CHECK (quantidade >= 0),
    PRIMARY KEY (estoque_id, insumo_id)
);

CREATE INDEX idx_estoque_insumo_insumo ON estoque_insumo(insumo_id);

-- Relacionamento: pedido_item
CREATE TABLE pedido_item (
    pedido_id INTEGER NOT NULL REFERENCES pedido(pedido_id),
    insumo_id INTEGER NOT NULL REFERENCES insumo(insumo_id),
    estoque_id INTEGER NOT NULL REFERENCES estoque_regional(estoque_id),
    quantidade NUMERIC(15,2) NOT NULL CHECK (quantidade > 0),
    PRIMARY KEY (pedido_id, insumo_id, estoque_id)
);

CREATE INDEX idx_pedido_item_estoque ON pedido_item(estoque_id);

-- Tabela: rastreio_insumo
CREATE TABLE rastreio_insumo (
    rastreio_id SERIAL PRIMARY KEY,
    insumo_id INTEGER NOT NULL REFERENCES insumo(insumo_id),
    fornecedor_id INTEGER REFERENCES fornecedor(fornecedor_id),
    centro_id INTEGER REFERENCES centro_agroindustrial(centro_id),
    estoque_id INTEGER REFERENCES estoque_regional(estoque_id),
    cliente_id INTEGER REFERENCES cliente(cliente_id),
    data_evento TIMESTAMP NOT NULL,
    evento VARCHAR(100)
);

CREATE INDEX idx_rastreio_insumo_insumo ON rastreio_insumo(insumo_id);
CREATE INDEX idx_rastreio_insumo_evento ON rastreio_insumo(evento);

-- Exemplo de trigger para atualização de estoque após pedido (opcional)
-- CREATE OR REPLACE FUNCTION atualizar_estoque() RETURNS TRIGGER AS $$
-- BEGIN
--   UPDATE estoque_insumo
--   SET quantidade = quantidade - NEW.quantidade
--   WHERE estoque_id = NEW.estoque_id AND insumo_id = NEW.insumo_id;
--   RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- CREATE TRIGGER trg_atualizar_estoque
-- AFTER INSERT ON pedido_item
-- FOR EACH ROW EXECUTE FUNCTION atualizar_estoque();
```

## Normalização e Desnormalização dos Dados

### Casos de Normalização

A modelagem apresentada segue princípios de normalização, especialmente até a 3ª Forma Normal (3FN):

- **Separação de entidades**: Cada tabela representa uma entidade ou relacionamento específico (ex: `fornecedor`, `insumo`, `cliente`, etc.), evitando redundância de dados.
- **Relacionamentos por chaves estrangeiras**: As ligações entre entidades são feitas por meio de chaves estrangeiras, garantindo integridade referencial e evitando duplicidade de informações.
- **Atributos atômicos**: Os campos armazenam apenas um valor por célula, facilitando consultas e atualizações.
- **Tabelas de associação**: Relacionamentos muitos-para-muitos (ex: `fornecedor_insumo`, `insumo_centro`) são tratados por tabelas intermediárias, evitando repetição de dados.

Essas práticas facilitam a manutenção, atualização e integridade dos dados, além de evitar anomalias de inserção, atualização e exclusão.

### Casos de Desnormalização

Apesar da normalização ser importante, em alguns cenários pode-se optar por desnormalizar para melhorar a performance de consultas:

- **Tabela de rastreamento (`rastreio_insumo`)**: Centraliza informações de rastreabilidade, agregando dados de várias entidades em uma única tabela para facilitar auditorias e consultas rápidas de histórico.
- **Inclusão de índices**: Embora não seja desnormalização estrutural, a criação de índices em campos de busca frequente é uma otimização que pode ser considerada uma forma de desnormalização lógica para acelerar consultas.
- **Possível replicação de dados em relatórios**: Em sistemas de BI ou relatórios, pode-se criar visões ou tabelas materializadas com dados já agregados ou juntados, reduzindo a necessidade de múltiplos JOINs em tempo real.

A desnormalização deve ser usada com cautela, apenas quando comprovadamente necessária para atender requisitos de desempenho, sempre considerando o impacto na integridade e manutenção dos dados.

