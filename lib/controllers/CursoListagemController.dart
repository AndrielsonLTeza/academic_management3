import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart'; // Garanta que o caminho do repositório está correto

class CursoListagemController extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();

  // Lista estritamente tipada com os objetos do seu modelo Course
  final List<Course> listaDeItens = [];

  bool isLoading = false;
  String? errorMessage;
  bool hasMoreItems = true;

  int _currentPage =
      0; // SQLite trabalha bem com offset baseado em páginas começando em 0
  final int _pageSize = 10;

  /// Carga inicial (Primeira página)
  Future<void> loadFirstPage() async {
    if (isLoading) return;

    isLoading = true;
    errorMessage = null;
    listaDeItens.clear();
    _currentPage = 0;
    hasMoreItems = true;
    notifyListeners();

    try {
      // Offset 0 traz do item 1 ao 10
      final novosCursos = await _repository.listarPaginado(
        limit: _pageSize,
        offset: 0,
      );

      if (novosCursos.isEmpty) {
        hasMoreItems = false;
      } else {
        listaDeItens.addAll(novosCursos);
        // Se vier menos que o tamanho da página, significa que o banco acabou
        hasMoreItems = novosCursos.length == _pageSize;
      }
    } catch (e) {
      errorMessage = "Erro ao carregar os cursos iniciais.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Carga das próximas páginas (Acionada pelo Scroll da tela)
  Future<void> loadNextPage() async {
    if (isLoading || !hasMoreItems) return;

    isLoading = true;
    notifyListeners();

    try {
      // Simula um delay bem leve só para o indicador de progresso fluir bonito na tela
      await Future.delayed(const Duration(milliseconds: 300));

      _currentPage++;
      int calcularOffset = _currentPage * _pageSize;

      final novosCursos = await _repository.listarPaginado(
        limit: _pageSize,
        offset: calcularOffset,
      );

      if (novosCursos.isEmpty) {
        hasMoreItems = false;
      } else {
        listaDeItens.addAll(novosCursos);
        hasMoreItems = novosCursos.length == _pageSize;
      }
    } catch (e) {
      errorMessage = "Erro ao carregar mais cursos.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
