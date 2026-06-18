import 'package:flutter/material.dart';
import '../controllers/CursoListagemController.dart';

class CursoListagemPage extends StatefulWidget {
  const CursoListagemPage({super.key});

  @override
  State<CursoListagemPage> createState() => _CursoListagemPageState();
}

class _CursoListagemPageState extends State<CursoListagemPage> {
  final CursoListagemController _controller = CursoListagemController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.loadFirstPage();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final position = _scrollController.position;
    final isNearBottom = position.pixels >= (position.maxScrollExtent - 200);

    if (isNearBottom) {
      _controller.loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // REMOVIDO: Scaffold e AppBar secundária para não achatar o layout das abas
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_controller.isLoading && _controller.listaDeItens.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage != null &&
            _controller.listaDeItens.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_controller.errorMessage!),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _controller.loadFirstPage,
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        if (_controller.listaDeItens.isEmpty) {
          return const Center(child: Text('Nenhum curso cadastrado.'));
        }

        return ListView.builder(
          controller: _scrollController,
          // Garante que a rolagem funcione perfeitamente mesmo integrada a abas
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _controller.listaDeItens.length + 1,
          itemBuilder: (context, index) {
            if (index < _controller.listaDeItens.length) {
              final curso = _controller.listaDeItens[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(
                      curso.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Coord: ${curso.coordinator} | ${curso.duration} semestres",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              if (_controller.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (_controller.errorMessage != null) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(_controller.errorMessage!),
                      ElevatedButton(
                        onPressed: _controller.loadNextPage,
                        child: const Text('Tentar carregar mais'),
                      ),
                    ],
                  ),
                );
              }

              if (!_controller.hasMoreItems) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Todos os cursos foram carregados.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
