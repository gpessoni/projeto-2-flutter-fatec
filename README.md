MedControl --- Controle de Medicamentos
=====================================

Aplicativo mobile desenvolvido em Flutter para gerenciamento e acompanhamento do uso de medicamentos.

O sistema permite cadastrar, visualizar, atualizar e excluir medicamentos, além de oferecer suporte para armazenamento local utilizando SQLite ou armazenamento remoto por meio de uma API REST integrada a um banco PostgreSQL.

* * * * *

Integrantes
-----------

-   Gabriel da Silveira Pessoni

-   Lívia Portela Ferreira

-   Maria Clara Cardoso Costa

* * * * *

Tecnologias Utilizadas
----------------------

### Front-end

-   Flutter

-   Dart

### Persistência Local

-   SQLite

### Persistência Remota

-   API REST

-   PostgreSQL

* * * * *

Funcionalidades
---------------

### Gerenciamento de Medicamentos

-   Cadastro de medicamentos

-   Listagem de medicamentos

-   Marcação de medicamento como tomado ou não tomado

-   Exclusão de medicamentos

-   Exibição de identificador sequencial

### Persistência de Dados

-   Armazenamento local utilizando SQLite

-   Armazenamento remoto utilizando API REST

-   Alternância entre persistência local e remota

### Sincronização

-   Envio de registros locais para a API

-   Sincronização de medicamentos cadastrados offline

* * * * *

Estrutura do Projeto
--------------------

```
lib/
├── components/
│   └── Componentes reutilizáveis da interface
│
├── data/
│   └── Configurações globais da aplicação
│
├── db/
│   └── Persistência local utilizando SQLite
│
├── models/
│   └── Modelos de dados
│
├── repository/
│   ├── Interface de acesso aos dados
│   ├── Implementação SQLite
│   └── Implementação API
│
├── screens/
│   └── Telas da aplicação
│
└── services/
    └── Comunicação com a API REST

```

* * * * *

Modelo de Dados
---------------

Cada medicamento possui os seguintes atributos:

| Campo | Tipo |
| --- | --- |
| id | int |
| nome | String |
| dosagem | String |
| horario | String |
| tomado | bool |
| observacoes | String |

### Exemplo

```
{
  "id": 1,
  "nome": "Dipirona",
  "dosagem": "500mg",
  "horario": "08:00",
  "tomado": false,
  "observacoes": "Tomar com água"
}

```

* * * * *

API REST
--------

### URL Base

```
https://projeto-flutter-fatec-api.onrender.com

```

### Endpoints Disponíveis

| Método | Endpoint | Descrição |
| --- | --- | --- |
| GET | /medicamentos | Lista todos os medicamentos |
| GET | /medicamentos/:id | Busca um medicamento por ID |
| POST | /medicamentos | Cadastra um novo medicamento |
| POST | /medicamentos/sincronizar | Sincroniza múltiplos medicamentos |
| PUT | /medicamentos/:id | Atualiza um medicamento |
| DELETE | /medicamentos/:id | Remove um medicamento |

* * * * *

Campos do Registro
------------------

| Campo | Tipo | Obrigatório | Descrição |
| --- | --- | --- | --- |
| nome | string | Sim | Nome do medicamento |
| dosagem | string | Sim | Exemplo: 500mg ou 1 comprimido |
| horario | string | Sim | Exemplo: 08:00 ou após almoço |
| tomado | boolean | Não | Indica se o medicamento foi tomado |
| observacoes | string | Não | Observações adicionais |

* * * * *

Exemplo de Cadastro
-------------------

### POST /medicamentos

```
{
  "nome": "Dipirona",
  "dosagem": "500mg",
  "horario": "08:00",
  "observacoes": "Tomar com água"
}

```

* * * * *

Exemplo de Atualização
----------------------

### PUT /medicamentos/1

```
{
  "nome": "Dipirona",
  "dosagem": "500mg",
  "horario": "08:00",
  "tomado": true
}

```

* * * * *

Exemplo de Exclusão
-------------------

### DELETE /medicamentos/1

Não é necessário enviar body na requisição.

* * * * *

Como Executar o Projeto
-----------------------

### Clonar o repositório

```
git clone <url-do-repositorio>

```

### Acessar a pasta do projeto

```
cd medcontrol

```

### Instalar as dependências

```
flutter pub get

```

### Executar a aplicação

```
flutter run

```

* * * * *

Fluxo de Utilização
-------------------

1.  Escolha a fonte de dados (SQLite ou API).

2.  Cadastre os medicamentos desejados.

3.  Marque os medicamentos conforme forem tomados.

4.  Utilize a sincronização para enviar registros locais à API.

5.  Gerencie os medicamentos por meio da aplicação.

