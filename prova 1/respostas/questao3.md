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
