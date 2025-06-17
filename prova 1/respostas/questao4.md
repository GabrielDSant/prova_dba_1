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
