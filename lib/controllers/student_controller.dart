import 'package:flutter/material.dart';
import '../models/student.dart';
import '../repositories/student_repository.dart';

class StudentController extends ChangeNotifier {
  final StudentRepository _repository = StudentRepository();
  List<Student> students = [];

  Future<void> carregarAlunos() async {
    students = await _repository.listar();
    notifyListeners(); // Avisa a tela para atualizar a lista
  }

  Future<void> adicionarAluno(Student s) async {
    await _repository.inserir(s);
    await carregarAlunos(); // Já chama o notifyListeners dentro do carregar
  }

  Future<void> atualizarAluno(Student s) async {
    await _repository.atualizar(s);
    await carregarAlunos();
  }

  Future<void> removerAluno(int id) async {
    await _repository.remover(id);
    await carregarAlunos();
  }
}
