# Sistema Acadêmico 🚀

Aplicativo móvel desenvolvido em Flutter para gerenciamento de **Cursos** e **Alunos**. O projeto foi atualizado para seguir padrões rígidos de arquitetura reativa, gerência de estado moderna e persistência em banco de dados relacional local com SQLite.

---

## 🛠️ Novas Atualizações e Melhorias do Projeto

2.1 O sistema passou por uma refatoração completa para se adequar às boas práticas de desenvolvimento e exigências acadêmicas. Abaixo estão as principais implementações desta versão:

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

3.1 Este repositório foi atualizado para implementar a funcionalidade de **Rolagem Infinita (Infinite Scroll) com Paginação Real** na listagem principal de cursos, seguindo todos os requisitos solicitados na atividade bônus

### 🛠️ O que foi alterado e implementado:
1. **Camada de Dados Paginada (`CourseRepository`):** O método de listagem foi evoluído para `listarPaginado(limit, offset)`, aplicando de forma nativa as cláusulas `LIMIT` e `OFFSET` do SQLite, além de uma ordenação explícita por `courseId ASC` para evitar duplicidade de registros entre páginas.
2. **Gerenciamento de Estado por Controller (`CursoListagemController`):** Centralização de toda a lógica de paginação estendendo `ChangeNotifier`. A controller gerencia os estados obrigatórios de `listaDeItens`, `isLoading`, `hasMoreItems`, `errorMessage` e `currentPage`, garantindo travas de segurança para impedir requisições duplicadas simultâneas.
3. **Interface Reativa (`CursosListagemScreen`):** A interface foi totalmente desacoplada de múltiplos `setState` locais, passando a reagir estritamente às mudanças do controller através do componente `ListenableBuilder`.
4. **Controle de Fluxo do Scroll (`ScrollController`):** Implementação de um detector ativo de rolagem conectado ao `ListView.builder`. O app calcula se o usuário se aproximou a menos de 200 pixels do final da lista para disparar automaticamente a busca da próxima página.
5. **Tratamento Completo de Estados de Tela:**
   * **Carregamento Inicial:** Feedback visual centralizado (`CircularProgressIndicator`) enquanto a lista está vazia.
   * **Carregamento Adicional:** Indicador de progresso posicionado discretamente no rodapé (fim da lista), mantendo os cursos anteriores visíveis na tela.
   * **Tratamento de Lista Vazia:** Mensagem customizada caso o banco não possua registros ("Nenhum curso cadastrado.").
   * **Fim da Lista:** Bloqueio de novas requisições e exibição da mensagem de conclusão ("Todos os cursos foram carregados.").
   * **Tratamento de Erros:** Exibição de mensagem amigável e botão de "Tentar Novamente" tanto na primeira carga quanto nas paginações seguintes, sem apagar o que já estava renderizado.

---

## 📂 Estrutura de Pastas do Recurso

A implementação foi organizada seguindo a arquitetura padrão do projeto[cite: 197]:

```text
lib/
├── controllers/
│   ├── course_controller.dart
│   ├── CursoListagemController.dart  # Máquina de estados da paginação
│   └── student_controller.dart
├── database/
│   └── app_database.dart             # Inicialização do banco SQLite
├── models/
│   ├── course.dart                   # Modelo da entidade Course
│   └── student.dart
├── pages/
│   ├── course_page.dart
│   └── CursoListagemPage.dart        # Interface com ScrollController e ListenableBuilder
├── repositories/
│   ├── course_repository.dart        # Queries com LIMIT e OFFSET
│   └── student_repository.dart
└── main.dart
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
