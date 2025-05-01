# Gerenciamento de Inventário de Jogo

## Descrição
Este projeto implementa um sistema de gerenciamento de inventário para um jogo em SQL. Ele permite o cadastro de jogadores, itens e seus inventários, com funcionalidades como atualização automática do total de itens por jogador e consultas detalhadas.

## Estrutura do Banco de Dados
O banco de dados `inventario` contém três tabelas principais:
- **jogador**: Armazena informações dos jogadores (id, nome, nick, total de itens, data de registro).
- **item**: Registra os itens disponíveis (id, nome, tipo, preço, estoque).
- **inventario**: Registra os itens no inventário de cada jogador (id, id do jogador, id do item, quantidade, data de adição).

### Relacionamentos
- A tabela `inventario` possui chaves estrangeiras que referenciam `jogador` e `item`, com exclusão em cascata (`ON DELETE CASCADE`).
- Um *trigger* (`atualiza_total_itens`) atualiza automaticamente o campo `total_itens` na tabela `jogador` após inserções na tabela `inventario`.

## Pré-requisitos
- MySQL ou outro SGBD compatível com SQL.
- Permissões para criar e manipular bancos de dados e *triggers*.

## Instalação
1. Execute o script SQL fornecido (`db_inventario.sql`) para criar o banco de dados, tabelas, *trigger* e inserir os dados iniciais.
   ```bash
   mysql -u [usuário] -p < db_inventario.sql
   ```
2. Conecte-se ao banco de dados `inventario`:
   ```sql
   USE inventario;
   ```

## Estrutura do Script
O script contém:
1. **Criação do Banco de Dados**:
   - Cria o banco `inventario` e seleciona-o para uso.
2. **Criação das Tabelas**:
   - Tabelas `jogador`, `item` e `inventario` com seus respectivos atributos, restrições e um `CHECK` para garantir quantidade não negativa.
3. **Criação do Trigger**:
   - O *trigger* `atualiza_total_itens` atualiza o campo `total_itens` do jogador após cada inserção na tabela `inventario`.
4. **Inserção de Dados**:
   - Dados de exemplo para jogadores, itens e inventários.
5. **Consultas Analíticas**:
   - Verificação do total de itens por jogador.
   - Detalhamento do inventário com informações de jogadores e itens.

## Funcionalidades
- **Gestão de Jogadores**: Cadastro com nome, nick único e data de registro.
- **Gestão de Itens**: Itens categorizados como arma, armadura ou consumível, com preço e estoque.
- **Gestão de Inventário**: Registro de itens por jogador, com quantidade e data de adição.
- **Automação**: O *trigger* mantém o campo `total_itens` atualizado automaticamente.

## Consultas Disponíveis
1. **Total de Itens por Jogador**:
   - Exibe o nome do jogador e o total de itens em seu inventário.
   ```sql
   SELECT nome, total_itens
   FROM jogador;
   ```
2. **Detalhamento do Inventário**:
   - Lista os itens no inventário, incluindo o nome do jogador, nome do item, quantidade e data de adição.
   ```sql
   SELECT 
       j.nome AS jogador,
       i.nome AS item,
       inv.quantidade,
       inv.data_adicao
   FROM inventario inv
   INNER JOIN jogador j ON inv.id_jogador = j.id_jogador
   INNER JOIN item i ON inv.id_item = i.id_item;
   ```

## Exemplo de Uso
Para verificar o inventário detalhado:
```sql
SELECT 
    j.nome AS jogador,
    i.nome AS item,
    inv.quantidade,
    inv.data_adicao
FROM inventario inv
INNER JOIN jogador j ON inv.id_jogador = j.id_jogador
INNER JOIN item i ON inv.id_item = i.id_item;
```

## Observações
- O *trigger* atualiza `total_itens` apenas após inserções. Para suportar atualizações ou exclusões, *triggers* adicionais podem ser criados.
- O campo `tipo` em `item` usa `ENUM` para restringir os valores a 'arma', 'armadura' ou 'consumivel'.
- Os dados inseridos são exemplos e podem ser modificados conforme necessário.
