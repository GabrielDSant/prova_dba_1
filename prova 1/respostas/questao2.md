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



