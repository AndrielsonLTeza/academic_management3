import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/student.dart';
import '../controllers/course_controller.dart';
import '../controllers/student_controller.dart';
import 'CursoListagemPage.dart'; // Import da sua nova página paginada

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final CourseController _courseController = CourseController();
  final StudentController _studentController = StudentController();

  final _studentFormKey = GlobalKey<FormState>();

  // Controllers dos Inputs de Aluno
  final _studentNameController = TextEditingController();
  final _studentRaController = TextEditingController();
  final _studentEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carrega os dados necessários para a aba de alunos
    _courseController.carregarCursos();
    _studentController.carregarAlunos();
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    _studentRaController.dispose();
    _studentEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sistema Acadêmico'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.book), text: 'Cursos'),
              Tab(icon: Icon(Icons.person), text: 'Alunos'),
            ],
          ),
        ),
        body: TabBarView(children: [_buildCourseTab(), _buildStudentTab()]),
      ),
    );
  }

  // ==================== ABA DE CURSOS ATUALIZADA ====================
  Widget _buildCourseTab() {
    // Agora chama diretamente a tela com rolagem infinita e paginação
    return const CursoListagemPage();
  }

  // ==================== ABA DE ALUNOS ====================
  Widget _buildStudentTab() {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _studentController,
        builder: (context, _) {
          if (_studentController.students.isEmpty) {
            return const Center(child: Text('Nenhum aluno cadastrado.'));
          }
          return ListView.builder(
            itemCount: _studentController.students.length,
            itemBuilder: (context, index) {
              final aluno = _studentController.students[index];

              final cursoVinculado = _courseController.courses.firstWhere(
                (c) => c.courseId == aluno.courseId,
                orElse: () => Course(
                  name: 'Nenhum curso associado',
                  duration: 0,
                  coordinator: '',
                  description: '',
                ),
              );

              return ListTile(
                title: Text(aluno.name),
                subtitle: Text(
                  'RA: ${aluno.ra} | Email: ${aluno.email}\nCurso: ${cursoVinculado.name}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _mostrarFormularioAluno(student: aluno),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmarRemocaoAluno(aluno.studentId!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioAluno(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarFormularioAluno({Student? student}) {
    final ValueNotifier<int?> cursoSelecionadoNotifier = ValueNotifier<int?>(
      student?.courseId ??
          (_courseController.courses.isNotEmpty
              ? _courseController.courses.first.courseId
              : null),
    );

    if (student != null) {
      _studentNameController.text = student.name;
      _studentRaController.text = student.ra;
      _studentEmailController.text = student.email;
    } else {
      _studentNameController.clear();
      _studentRaController.clear();
      _studentEmailController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Form(
          key: _studentFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                student == null ? 'Cadastrar Aluno' : 'Editar Aluno',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _studentNameController,
                decoration: const InputDecoration(labelText: 'Nome do Aluno'),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _studentRaController,
                decoration: const InputDecoration(
                  labelText: 'Registro Acadêmico (RA)',
                ),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _studentEmailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 15),
              ListenableBuilder(
                listenable: cursoSelecionadoNotifier,
                builder: (context, _) {
                  return _courseController.courses.isEmpty
                      ? const Text(
                          'Cadastre um curso na aba Cursos antes de adicionar alunos!',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : DropdownButtonFormField<int>(
                          value: cursoSelecionadoNotifier.value,
                          decoration: const InputDecoration(
                            labelText: 'Curso Vinculado',
                          ),
                          items: _courseController.courses.map((curso) {
                            return DropdownMenuItem<int>(
                              value: curso.courseId,
                              child: Text(curso.name),
                            );
                          }).toList(),
                          onChanged: (novoId) {
                            cursoSelecionadoNotifier.value = novoId;
                          },
                        );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_studentFormKey.currentState!.validate()) {
                    final novoAluno = Student(
                      studentId: student?.studentId,
                      name: _studentNameController.text,
                      ra: _studentRaController.text,
                      email: _studentEmailController.text,
                      courseId: cursoSelecionadoNotifier.value,
                    );
                    if (student == null) {
                      await _studentController.adicionarAluno(novoAluno);
                    } else {
                      await _studentController.atualizarAluno(novoAluno);
                    }
                    if (context.mounted) Navigator.pop(context);
                    _exibirSnackBar('Operação realizada no aluno!');
                  }
                },
                child: Text(student == null ? 'Salvar' : 'Atualizar'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmarRemocaoAluno(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Remoção'),
        content: const Text('Deseja realmente excluir este aluno?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await _studentController.removerAluno(id);
              if (context.mounted) Navigator.pop(context);
              _exibirSnackBar('Aluno removido!');
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _exibirSnackBar(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }
}
