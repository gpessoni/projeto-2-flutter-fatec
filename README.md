# MedControl — Controle de Medicamentos

## Identificação do projeto

```
Nome da temática do aplicativo: Controle de medicamentos
Integrante 1: Gabriel da Silveira Pessoni
Integrante 2: Lívia Portela Ferreira
```

---

## Linguagem e Framework

- **Linguagem:** Dart
- **Framework:** Flutter

---

## Sobre o projeto

Aplicativo mobile para controle de medicamentos tomados.
Permite cadastrar remédios com nome, dosagem, horário e observações, marcar como tomado e excluir registros.

Os dados podem ser persistidos **localmente (SQLite)** ou na **nuvem (API + PostgreSQL)**, com troca de fonte via switch na tela principal e botão de sincronização local → API.

---

## Estrutura do projeto

```
lib/
├── components/       # Componentes reutilizáveis (Editor)
├── data/             # Configurações globais (AppSettings, switch local/API)
├── db/               # Persistência local com SQLite
├── models/           # Modelo de dados (Medicamento)
├── repository/       # Camada repository (abstração + implementações local e API)
├── screens/          # Telas do aplicativo (Dashboard, Lista, Formulário)
└── services/         # Camada de serviço para comunicação com a API
```

---

## Funcionalidades

- Cadastrar medicamento (nome, dosagem, horário, observações)
- Listar medicamentos com ID sequencial
- Marcar medicamento como tomado / não tomado
- Excluir medicamento
- Alternar entre persistência local (SQLite) e remota (API)
- Sincronizar dados locais com a API

---

## API — Rotas disponíveis

**URL base:** `https://projeto-flutter-fatec-api.onrender.com`

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/medicamentos` | Lista todos os medicamentos |
| GET | `/medicamentos/:id` | Busca um medicamento por ID |
| POST | `/medicamentos` | Cadastra um novo medicamento |
| POST | `/medicamentos/sincronizar` | Sincroniza múltiplos medicamentos |
| PUT | `/medicamentos/:id` | Atualiza um medicamento |
| DELETE | `/medicamentos/:id` | Remove um medicamento |

### Campos do registro

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `nome` | string | Sim | Nome do medicamento (2–100 chars) |
| `dosagem` | string | Sim | Ex: "500mg", "1 comprimido" |
| `horario` | string | Sim | Ex: "08:00", "após almoço" |
| `tomado` | boolean | Não | Se foi tomado (padrão: false) |
| `observacoes` | string | Não | Anotações livres (até 1000 chars) |

### Exemplos de uso

**POST /medicamentos**
```json
{
  "nome": "Dipirona",
  "dosagem": "500mg",
  "horario": "08:00",
  "observacoes": "Tomar com água"
}
```

**PUT /medicamentos/1**
```json
{
  "nome": "Dipirona",
  "dosagem": "500mg",
  "horario": "08:00",
  "tomado": true
}
```

**DELETE /medicamentos/1**
```
Sem body. Retorna 200 em caso de sucesso.
```

---

## Como executar

```bash
# Instalar dependências
flutter pub get

# Executar o app
flutter run
```
