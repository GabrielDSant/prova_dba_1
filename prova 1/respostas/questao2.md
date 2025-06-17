# QUESTÃO 2 - MODELO ENTIDADE RELACIONAMENTO (Atualizada e Revisada)

## a) Diagrama ER completo (Descrição)

O Diagrama Entidade-Relacionamento (DER) para o sistema "Mundo Aventura" foi projetado para representar visualmente as entidades, seus atributos e os relacionamentos entre elas, incorporando os conceitos de tipos compostos do PostgreSQL para uma modelagem mais orientada a objetos. Uma imagem do diagrama foi gerada separadamente para melhor visualização.

### Entidades e Atributo*   **CLIENTES**
    *   id (PK): SERIAL
    *   cpf_cnpj: VARCHAR(14) **UNIQUE**
    *   nome_razao_social: VARCHAR(255)
    *   endereco_cliente: `endereco` (Tipo Composto: rua, numero, bairro, cidade, estado, cep)
    *   info_contato: `contato` (Tipo Composto: email, telefone_principal, telefone_secundario)
    *   data_nascimento_fundacao: DATE
    *   tipo_cliente: VARCHAR(20) (Domínio: 'individual', 'corporativo', 'grupo')
    *   categoria_fidelidade_id: INTEGER (FK para CATEGORIAS_FIDELIDADE.id)
    *   data_cadastro: DATE
    *   status_cliente: VARCHAR(20) (Domínio: 'ativo', 'inativo')

*   **CATEGORIAS_FIDELIDADE**
    *   <u>id</u> (PK): SERIAL
    *   nome_categoria: VARCHAR(20) **UNIQUE**
    *   percentual_desconto: DECIMAL(5,2)

*   **DESTINOS**
    *   <u>id</u> (PK): SERIAL
    *   codigo_destino: VARCHAR(10) **UNIQUE**
    *   nome_destino: VARCHAR(255)
    *   pais: VARCHAR(100)
    *   estado_provincia: VARCHAR(100)
    *   cidade_principal: VARCHAR(100)
    *   descricao_detalhada: TEXT
    *   clima_predominante: VARCHAR(50)
    *   melhor_epoca_visitar: VARCHAR(100)
    *   nivel_dificuldade: VARCHAR(20) (Domínio: 'facil', 'moderado', 'dificil')
    *   categoria_turistica: VARCHAR(50) (Domínio: 'praia', 'montanha', 'cidade historica', 'aventura', 'cultural', 'gastronomico')
    *   custo_medio_diario: DECIMAL(10,2)
    *   idioma_local: VARCHAR(50)
    *   moeda_local: VARCHAR(10)
    *   documentacao_necessaria: TEXT
    *   status_destino: VARCHAR(20) (Domínio: 'ativo', 'inativo', 'sazonal')

*   **PACOTES_TURISTICOS**
    *   <u>id</u> (PK): SERIAL
    *   codigo_pacote: VARCHAR(10) **UNIQUE**
    *   nome_pacote: VARCHAR(255)
    *   destino_principal_id: INTEGER (FK para DESTINOS.id)
    *   duracao_dias: INTEGER
    *   preco_base_por_pessoa: DECIMAL(10,2)
    *   categoria_pacote: VARCHAR(20) (Domínio: 'economico', 'standard', 'premium', 'luxo')
    *   tipo_viagem: VARCHAR(20) (Domínio: 'individual', 'casal', 'familia', 'grupo')
    *   inclui_transporte: BOOLEAN
    *   inclui_hospedagem: BOOLEAN
    *   inclui_alimentacao: VARCHAR(20) (Domínio: 'cafe', 'meia pensao', 'pensao completa')
    *   nivel_atividade_fisica: VARCHAR(20) (Domínio: 'baixo', 'medio', 'alto')
    *   idade_minima_recomendada: INTEGER
    *   idade_maxima_recomendada: INTEGER
    *   numero_maximo_participantes: INTEGER
    *   status_pacote: VARCHAR(20) (Domínio: 'ativo', 'inativo', 'sazonal')

*   **RESERVAS**
    *   <u>id</u> (PK): SERIAL
    *   cliente_id: INTEGER (FK para CLIENTES.id)
    *   pacote_id: INTEGER (FK para PACOTES_TURISTICOS.id)
    *   data_reserva: DATE
    *   data_inicio_viagem: DATE
    *   data_retorno: DATE
    *   numero_total_pessoas: INTEGER
    *   valor_total_reserva: DECIMAL(10,2)
    *   valor_entrada_pago: DECIMAL(10,2)
    *   forma_pagamento: VARCHAR(50) (Domínio: 'cartao', 'transferencia', 'dinheiro', 'parcelado')
    *   numero_parcelas: INTEGER (Opcional)
    *   data_limite_pagamento_final: DATE
    *   vendedor_responsavel: VARCHAR(255)
    *   observacoes_especiais: TEXT (Opcional)
    *   status_reserva: VARCHAR(20) (Domínio: 'pendente', 'confirmada', 'paga', 'cancelada', 'em andamento', 'finalizada')
    *   motivo_cancelamento: TEXT (Opcional)

*   **PACOTES_DESTINOS_SECUNDARIOS** (Entidade Associativa)
    *   <u>pacote_id</u> (PK, FK para PACOTES_TURISTICOS.id)
    *   <u>destino_secundario_id</u> (PK, FK para DESTINOS.id)
    *   **Chave Primária Composta**: (pacote_id, destino_secundario_id)

*   **PARTICIPANTES_RESERVA** (Entidade Associativa)
    *   <u>reserva_id</u> (PK, FK para RESERVAS.id)
    *   <u>nome_participante</u> (PK): VARCHAR(255)
    *   **Chave Primária Composta**: (reserva_id, nome_participante)

### Relacionamentos e Cardinalidades:

*   **CLIENTES** ---1:N--- **RESERVAS**
    *   Um CLIENTE pode fazer N RESERVAS.
    *   Uma RESERVA é feita por 1 CLIENTE.
    *   Justificativa: A chave primária de CLIENTES (id) aparece como chave estrangeira em RESERVAS (cliente_id).

*   **DESTINOS** ---1:N--- **PACOTES_TURISTICOS**
    *   Um DESTINO pode ser o destino principal de N PACOTES_TURISTICOS.
    *   Um PACOTE_TURISTICO tem 1 DESTINO principal.
    *   Justificativa: A chave primária de DESTINOS (id) aparece como chave estrangeira em PACOTES_TURISTICOS (destino_principal_id).

*   **PACOTES_TURISTICOS** ---1:N--- **RESERVAS**
    *   Um PACOTE_TURISTICO pode estar em N RESERVAS.
    *   Uma RESERVA é para 1 PACOTE_TURISTICO.
    *   Justificativa: A chave primária de PACOTES_TURISTICOS (id) aparece como chave estrangeira em RESERVAS (pacote_id).

*   **PACOTES_TURISTICOS** ---N:M--- **DESTINOS** (via PACOTES_DESTINOS_SECUNDARIOS)
    *   Um PACOTE_TURISTICO pode ter N DESTINOS secundários.
    *   Um DESTINO pode ser secundário em N PACOTES_TURISTICOS.
    *   Justificativa: A entidade associativa `PACOTES_DESTINOS_SECUNDARIOS` resolve o relacionamento N:M entre `PACOTES_TURISTICOS` e `DESTINOS` para os destinos secundários, permitindo a flexibilidade de múltiplos destinos secundários por pacote e um destino ser secundário em vários pacotes. A chave primária composta (`pacote_id`, `destino_secundario_id`) garante a unicidade de cada par pacote-destino secundário.

*   **RESERVAS** ---1:N--- **PARTICIPANTES_RESERVA**
    *   Uma RESERVA pode ter N PARTICIPANTES.
    *   Um PARTICIPANTE pertence a 1 RESERVA.
    *   Justificativa: A entidade `PARTICIPANTES_RESERVA` foi criada para lidar com o atributo multivalorado `lista_nomes_participantes` da entidade `RESERVAS`, garantindo que cada participante seja um registro individual e associado à sua reserva. A chave primária composta (`reserva_id`, `nome_participante`) garante a unicidade de cada participante dentro de uma reserva.

## c) Restrições de Integridade

### Restrições de Domínio:

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

### Restrições de Integridade Referencial:

*   **RESERVAS.cliente_id** referencia **CLIENTES.id**: Garante que toda reserva esteja associada a um cliente existente.
*   **PACOTES_TURISTICOS.destino_principal_id** referencia **DESTINOS.id**: Garante que todo pacote turístico tenha um destino principal existente.
*   **RESERVAS.pacote_id** referencia **PACOTES_TURISTICOS.id**: Garante que toda reserva esteja associada a um pacote turístico existente.
*   **PACOTES_DESTINOS_SECUNDARIOS.pacote_id** referencia **PACOTES_TURISTICOS.id**: Garante que cada associação de destino secundário esteja ligada a um pacote turístico existente.
*   **PACOTES_DESTINOS_SECUNDARIOS.destino_secundario_id** referencia **DESTINOS.id**: Garante que cada associação de destino secundário esteja ligada a um destino existente.
*   **PARTICIPANTES_RESERVA.reserva_id** referencia **RESERVAS.id**: Garante que cada participante esteja associado a uma reserva existente.

### Restrições de Negócio Específicas do Sistema:

*   **Descontos por Categoria de Fidelidade**: Implementar lógica para aplicar descontos (15% para Platinum, 10% para Ouro, 5% para Prata) no `valor_total_reserva` com base em `CLIENTES.categoria_fidelidade`.
*   **Desconto para Grupos**: Se `RESERVAS.numero_total_pessoas` > 10, aplicar um desconto adicional de 10%.
*   **Regras de Cancelamento**: Lógica para calcular `motivo_cancelamento` e o valor da multa com base na `data_reserva` e `data_inicio_viagem`:
    *   Cancelamento até 30 dias antes: sem multa.
    *   Cancelamento entre 15-30 dias antes: multa de 20% do `valor_total_reserva`.
    *   Cancelamento com menos de 15 dias antes: multa de 50% do `valor_total_reserva`.
*   **Destino Principal Obrigatório**: `PACOTES_TURISTICOS.destino_principal_id` não pode ser nulo.
*   **Pacotes Sazonais**: Lógica para verificar a disponibilidade de pacotes com `PACOTES_TURISTICOS.status_pacote = \'sazonal\'` em períodos específicos do ano (não modelado diretamente nas tabelas, mas uma regra de aplicação).
*   **Valor de Entrada Mínimo**: `RESERVAS.valor_entrada_pago` deve ser no mínimo 30% de `RESERVAS.valor_total_reserva`.
*   **Prazo de Pagamento para Clientes Corporativos**: Se `CLIENTES.tipo_cliente = \'corporativo\'`, o `RESERVAS.data_limite_pagamento_final` deve ser estendido para 45 dias após a `data_reserva` (ou outra data de referência).



