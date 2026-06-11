import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart'; // Garanta que o caminho do seu repositório está correto aqui

class CourseController extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();
  List<Course> courses = [];

  // Carrega a lista de cursos do banco e avisa os ouvintes (UI)
  Future<void> carregarCursos() async {
    courses = await _repository.listar();
    notifyListeners(); // O segredo para eliminar o setState está aqui!
  }

  // Adiciona um curso e atualiza a lista de forma reativa
  Future<void> adicionarCurso(Course course) async {
    await _repository.inserir(course);
    await carregarCursos(); // O carregarCursos já vai disparar o notifyListeners()
  }

  // Atualiza um curso existente e notifica a árvore de widgets
  Future<void> atualizarCurso(Course course) async {
    await _repository.atualizar(course);
    await carregarCursos();
  }

  // Remove um curso pelo ID e recarrega os dados limpamente
  Future<void> removerCurso(int id) async {
    await _repository.remover(id);
    await carregarCursos();
  }
}
