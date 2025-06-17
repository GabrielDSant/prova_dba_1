# Caso de estudo
A empresa LogiTrans Brasil é especializada em operações logísticas para clientes do setor de e-commerce. Seu modelo de negócio envolve o recebimento de mercadorias, a armazenagem em centros logísticos, e a entrega por transportadoras parceiras até o consumidor final. A empresa também oferece serviços de rastreio de entregas, relatórios de desempenho logístico e gestão de ocorrências de transporte.

A direção da empresa decidiu implementar um novo sistema de gerenciamento operacional utilizando banco de dados PostgreSQL. Você foi contratado para modelar e criar toda a estrutura de dados necessária para que a operação seja informatizada com segurança, escalabilidade e rastreabilidade total dos processos.

# Modelo Conceitual

## Entidades

- **Cliente**: Pessoa ou empresa que contrata os serviços logísticos.
- **Mercadoria**: Produtos recebidos, armazenados e entregues.
- **Centro Logístico**: Local onde as mercadorias são armazenadas.
- **Transportadora Parceira**: Empresa responsável pela entrega ao consumidor final.
- **Entrega**: Processo de transporte da mercadoria até o cliente.
- **Rastreamento**: Informações sobre o status e localização das entregas.
- **Ocorrência de Transporte**: Eventos ou problemas registrados durante o transporte.
- **Relatório de Desempenho**: Dados consolidados sobre a operação logística.


## Relacionamentos

- **Cliente** realiza **Entrega**.
- **Mercadoria** pertence a um **Cliente** e é armazenada em um **Centro Logístico**.
- **Centro Logístico** armazena várias **Mercadorias**.
- **Entrega** transporta uma ou mais **Mercadorias** do **Centro Logístico** até o **Cliente**.
- **Transportadora Parceira** executa a **Entrega**.
- **Rastreamento** está associado a uma **Entrega** (pode registrar múltiplos status/localizações por entrega).
- **Ocorrência de Transporte** está vinculada a uma **Entrega** (pode haver várias ocorrências por entrega).
- **Relatório de Desempenho** consolida dados de **Entregas**, **Rastreamentos** e **Ocorrências de Transporte**.


# Modelo Lógico (PostgreSQL)

## Tabelas e Relacionamentos

- **cliente** (`id_cliente`, `nome`, `tipo`, `documento`, `email`, `telefone`)
- **mercadoria** (`id_mercadoria`, `descricao`, `peso`, `volume`, `id_cliente`, `id_centro_logistico`)
- **centro_logistico** (`id_centro_logistico`, `nome`, `endereco`)
- **transportadora_parceira** (`id_transportadora`, `nome`, `cnpj`, `contato`)
- **entrega** (`id_entrega`, `id_cliente`, `id_transportadora`, `data_saida`, `data_prevista`, `data_entrega`)
- **entrega_mercadoria** (`id_entrega`, `id_mercadoria`) <!-- tabela associativa para N:N -->
- **rastreamento** (`id_rastreamento`, `id_entrega`, `status`, `localizacao`, `data_hora`)
- **ocorrencia_transporte** (`id_ocorrencia`, `id_entrega`, `descricao`, `data_hora`)
- **relatorio_desempenho** (`id_relatorio`, `periodo_inicio`, `periodo_fim`, `dados_consolidados`)

# Modelo Físico

### Scripts de Criação

```sql
-- Criação dos TABLESPACES (ajuste os caminhos conforme necessário)
CREATE TABLESPACE ts_dados LOCATION '/var/lib/postgresql/tablespaces/dados';
CREATE TABLESPACE ts_indices LOCATION '/var/lib/postgresql/tablespaces/indices';

-- Tabelas com TABLESPACE especificado
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) NOT NULL, -- Pessoa Física/Jurídica
    documento VARCHAR(30) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20)
) TABLESPACE ts_dados;

CREATE TABLE centro_logistico (
    id_centro_logistico SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200) NOT NULL
) TABLESPACE ts_dados;

CREATE TABLE transportadora_parceira (
    id_transportadora SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(20) NOT NULL,
    contato VARCHAR(100)
) TABLESPACE ts_dados;

CREATE TABLE mercadoria (
    id_mercadoria SERIAL PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    peso NUMERIC(10,2),
    volume NUMERIC(10,2),
    id_cliente INTEGER NOT NULL REFERENCES cliente(id_cliente),
    id_centro_logistico INTEGER NOT NULL REFERENCES centro_logistico(id_centro_logistico)
) TABLESPACE ts_dados;

CREATE TABLE entrega (
    id_entrega SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES cliente(id_cliente),
    id_transportadora INTEGER NOT NULL REFERENCES transportadora_parceira(id_transportadora),
    data_saida DATE NOT NULL,
    data_prevista DATE,
    data_entrega DATE
) TABLESPACE ts_dados;

CREATE TABLE entrega_mercadoria (
    id_entrega INTEGER NOT NULL REFERENCES entrega(id_entrega),
    id_mercadoria INTEGER NOT NULL REFERENCES mercadoria(id_mercadoria),
    PRIMARY KEY (id_entrega, id_mercadoria)
) TABLESPACE ts_dados;

CREATE TABLE rastreamento (
    id_rastreamento SERIAL PRIMARY KEY,
    id_entrega INTEGER NOT NULL REFERENCES entrega(id_entrega),
    status VARCHAR(50) NOT NULL,
    localizacao VARCHAR(100),
    data_hora TIMESTAMP NOT NULL
) TABLESPACE ts_dados;

CREATE TABLE ocorrencia_transporte (
    id_ocorrencia SERIAL PRIMARY KEY,
    id_entrega INTEGER NOT NULL REFERENCES entrega(id_entrega),
    descricao TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL
) TABLESPACE ts_dados;

CREATE TABLE relatorio_desempenho (
    id_relatorio SERIAL PRIMARY KEY,
    periodo_inicio DATE NOT NULL,
    periodo_fim DATE NOT NULL,
    dados_consolidados JSONB
) TABLESPACE ts_dados;

-- Índices adicionais para performance (em TABLESPACE separado)
CREATE INDEX idx_mercadoria_id_cliente ON mercadoria(id_cliente) TABLESPACE ts_indices;
CREATE INDEX idx_mercadoria_id_centro_logistico ON mercadoria(id_centro_logistico) TABLESPACE ts_indices;
CREATE INDEX idx_entrega_id_cliente ON entrega(id_cliente) TABLESPACE ts_indices;
CREATE INDEX idx_entrega_id_transportadora ON entrega(id_transportadora) TABLESPACE ts_indices;
CREATE INDEX idx_entrega_mercadoria_id_mercadoria ON entrega_mercadoria(id_mercadoria) TABLESPACE ts_indices;
CREATE INDEX idx_rastreamento_id_entrega ON rastreamento(id_entrega) TABLESPACE ts_indices;
CREATE INDEX idx_ocorrencia_id_entrega ON ocorrencia_transporte(id_entrega) TABLESPACE ts_indices;
CREATE INDEX idx_relatorio_periodo ON relatorio_desempenho(periodo_inicio, periodo_fim) TABLESPACE ts_indices;
```

# Normalização e Desnormalização dos Dados

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

