# 🧽 SiriCascudo — Sistema de Gestão de Banco de Dados Relacional ⚓


<p align="center">
  <img src="https://github.com/user-attachments/assets/0fa345c1-40ae-4087-b41b-1d18652b620e" width="300" />
</p>


> *"Estou pronto! Estou pronto! Estou pronto!"* — Bob Esponja.

---

### 1️⃣ Descrição do Projeto

Este projeto consiste na modelagem, implementação e automação do banco de dados relacional **SiriCascudoDB**, desenvolvido em **SGBD MySQL**. O objetivo principal é estruturar o ecossistema operacional do estabelecimento comercial *Siri Cascudo*, aplicando conceitos fundamentais e avançados de Arquitetura de Dados, Integridade Referencial e Programação em Banco de Dados (Procedural SQL).

A arquitetura do sistema foi projetada para resolver problemas operacionais e de inteligência de negócios da Fenda do Pijama, tais como:
- **Gestão de Recursos Humanos:** Mapeamento de colaboradores, cargos, salários e estrutura hierárquica corporativa.
- **Relacionamento com Clientes & Vendas:** Mapeamento do histórico de transações, políticas de fidelização por indicação e controle de pagamentos.
- **Automação de Regras de Negócio:** Aplicação de *Triggers* e *Stored Procedures* para cálculo automatizado de custos operacionais e atualização da folha de pagamento.


---

### 2️⃣ Modelagem de Dados e Estrutura do Sistema

O sistema é composto por 5 entidades principais implementadas no script `script_siricascudo.sql`:

1. **`funcionarios`**: Armazena os dados cadastrais da equipe (Sr. Sirigueijo, Lula Molusco, Bob Esponja, Patrick, Sandy e Gary), incluindo controle de remuneração por hora, cargos e vínculo hierárquico.
2. **`produtos`**: Catálogo de produtos do restaurante (Hambúrguer de Siri, Batata Frita Marinha, Refrigerante de Alga, etc.) e insumos operacionais.
3. **`clientes`**: Mapeamento dos consumidores locais e rastreamento de rede de indicações.
4. **`transacoes`**: Registro de vendas vinculando clientes aos valores movimentados.
5. **`despesas`**: Mapeamento do fluxo financeiro e custos operacionais da empresa.


---

### 3️⃣ Metodologia de Implementação (SQL)

A construção do banco de dados seguiu as boas práticas de Engenharia de Software e SQL ANSI:

#### 3.1. DDL (Data Definition Language) & Integridade
- **Políticas de Reset:** Uso do comando `DROP DATABASE IF EXISTS` para garantir a reprodutibilidade e execução limpa do script em qualquer ambiente.
- **Chaves & Restrições:** Definição de `PRIMARY KEY` (com e sem `AUTO_INCREMENT`), `FOREIGN KEY` com integridade referencial, além de restrições `UNIQUE`, `NOT NULL` e valores padrão (`DEFAULT`).

#### 3.2. DML (Data Manipulation Language) & Normalização
- Povoamento das entidades e atualização dinâmica de registros via `UPDATE`.
- Tratamento de exceções e remoção pontual de duplicações via `DELETE`.

#### 3.3. Recursos Avançados & Automação
- **Self Joins (Autorrelacionamento):** Modelagem de dados hierárquicos para mapear a relação supervisor/subordinado na equipe e a árvore de indicações de clientes.
- **Otimização & Segurança (Views e Índices):**
  - Criação da *View* `emails_clientes` para abstração e camada de segurança do acesso aos e-mails.
  - Implementação de *Índice B-Tree* composto (`idx_ultimo_primeiro_nome`) na tabela de clientes para otimização de consultas `SELECT`.
- **Análise Agregada (OLAP Básico):** Emprego da cláusula `GROUP BY ... WITH ROLLUP` para sumarização e geração de totais gerais de vendas e custos por hora.
- **Programação Procedural (Procedures & Triggers):**
  - *Stored Procedures* encapsuladas com delimitadores (`DELIMITER $$`) e parâmetros de entrada (`IN`) para busca otimizada de clientes.
  - *Trigger* `BEFORE UPDATE` para automação do cálculo do salário anual do funcionário (`salario_por_hora * 2080 horas/ano`), propagando o impacto financeiro diretamente na tabela de `despesas`.


---

### 4️⃣ Tecnologias & Ferramentas

- **SGBD:** MySQL (Servidor Local - `localhost:3306`)
- **Ferramentas de Desenvolvimento:** MySQL Workbench & Visual Studio Code
- **Controle de Versão:** Git & GitHub


---

### 5️⃣ Instruções para Execução do Script

Para executar a suíte de testes do **SiriCascudoDB**:

1. Certifique-se de que o serviço do **MySQL Server** esteja ativo na porta `3306`.
2. Abra a ferramenta de sua preferência (**MySQL Workbench**, **DBeaver** ou **VS Code** via extensão MySQL).
3. Conecte-se à instância local (`127.0.0.1` / `localhost`) utilizando suas credenciais administrativas (`root`).
4. Abra o arquivo `script_siricascudo.sql` e execute o script na íntegra.
5. O script irá recriar a base `SiriCascudoDB`, estruturar o esquema, povoar os dados e disparar os testes de Procedures e Triggers automaticamente.

---

### 6️⃣ Diagrama Entidade Relacionamento (DER)

<p align="center">
  <img src="https://github.com/user-attachments/assets/f6376e16-8d5b-4aea-9461-6192feae3053" width="800" alt="Diagrama ER do Siri Cascudo" />
</p>

---


<p align="center">
  <img src="https://github.com/user-attachments/assets/b3296801-3342-4a55-8c21-3891475de105" alt="Execução no MySQL Workbench" width="650">
</p>
