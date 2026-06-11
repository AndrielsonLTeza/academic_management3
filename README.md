# Sistema Acadêmico 🚀

Aplicativo móvel desenvolvido em Flutter para gerenciamento de **Cursos** e **Alunos**. O projeto foi atualizado para seguir padrões rígidos de arquitetura reativa, gerência de estado moderna e persistência em banco de dados relacional local com SQLite.

---

## 🛠️ Novas Atualizações e Melhorias do Projeto

O sistema passou por uma refatoração completa para se adequar às boas práticas de desenvolvimento e exigências acadêmicas. Abaixo estão as principais implementações desta versão:

### 1. Banco de Dados Relacional (SQLite)
* **Interligação de Tabelas:** A tabela `students` agora possui uma chave estrangeira (`courseId`) que faz referência direta à tabela `courses`.
* **Integridade Referencial:** Adicionada a cláusula `ON DELETE SET NULL` para garantir que, caso um curso seja excluído, os alunos vinculados a ele não quebrem o aplicativo, mantendo a consistência dos dados locais.

### 2. Arquitetura Reativa com `ChangeNotifier`
* **Camada de Controller Isolada:** Toda a lógica de estado e comunicação com os repositórios foi movida para as classes `CourseController` e `StudentController`.
* **Notificação Automatizada:** Os controllers estendem `ChangeNotifier` e utilizam o método `notifyListeners()` após qualquer operação de CRUD (inserir, listar, atualizar, remover), propagando as alterações de forma eficiente pela árvore de widgets.

### 3. Eliminação do `setState` (UI Limpa)
* **Gerência de Estado Declarativa:** O método `setState()` foi **100% removido** das páginas de visualização (`views/pages`).
* **Uso de `ListenableBuilder`:** A interface gráfica agora utiliza o componente reativo `ListenableBuilder` para escutar os controllers. A tela reconstrói apenas os componentes necessários quando há mudanças no banco de dados.
* **Componentes Isolados:** O formulário de cadastro de alunos utiliza um `ValueNotifier` local combinado com `ListenableBuilder` para gerenciar a seleção do *Dropdown* de cursos sem afetar o restante da página.

---

## 🏗️ Estrutura do Projeto (Padrão MVC/Repository)

```text
lib/
├── controllers/
│   ├── course_controller.dart     # Regras de negócio e ChangeNotifier de Cursos
│   └── student_controller.dart    # Regras de negócio e ChangeNotifier de Alunos
├── database/
│   └── app_database.dart          # Configuração do SQLite e criação das tabelas relacionais
├── models/
│   ├── course.dart                # Modelo de dados de Curso
│   └── student.dart               # Modelo de dados de Aluno (com ID do curso)
├── pages/
│   └── course_page.dart           # Interface visual unificada com ListenableBuilder (Sem setState)
├── repositories/
│   ├── course_repository.dart     # Comunicação direta com a tabela de cursos no SQLite
│   └── student_repository.dart    # Comunicação direta com a tabela de alunos no SQLite
└── main.dart                      # Inicialização limpa do aplicativo
```

💻 Como Executar o Projeto
Como o banco de dados sqflite é focado em armazenamento nativo mobile, o projeto deve ser executado obrigatoriamente em um Emulador Android/iOS ou Celular Físico conectado via USB.

Clone o repositório:
```
   git clone [https://github.com/AndrielsonLTeza/academic_management3.git](https://github.com/AndrielsonLTeza/academic_management3.git)
   cd academic_management
```
Instale as dependências do Flutter:

```
   flutter pub get
```
Inicie o seu emulador configurado (Ex: Pixel_8_Pro):

```
   flutter emulators --launch Pixel_8_Pro
```   
Execute o aplicativo no dispositivo móvel:

```
   flutter run
```
🤖 Uso de Inteligência Artificial (Atividade 2)
Este projeto contou com o auxílio de IA no processo de pareamento de código, refinamento da arquitetura local e diagnóstico de compatibilidade de plataformas (Web vs. Mobile).

Toda a documentação exigida contendo as diretrizes, prompts e reflexões críticas encontra-se organizada na pasta:

docs/ia/GUIDELINES.md

docs/ia/PROMPTS.md

docs/ia/REFLEXAO.md
