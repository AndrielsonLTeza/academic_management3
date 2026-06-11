import '../database/app_database.dart';
import '../models/student.dart';

class StudentRepository {
  // Instância correta do banco de dados para os métodos abaixo utilizarem
  final AppDatabase _appDatabase = AppDatabase();

  Future<int> inserir(Student s) async {
    final db = await _appDatabase.database;
    return await db.insert('students', s.toMap());
  }

  Future<int> atualizar(Student s) async {
    final db = await _appDatabase.database;
    return await db.update(
      'students',
      s.toMap(),
      where: 'studentId = ?',
      whereArgs: [s.studentId],
    );
  }

  Future<int> remover(int id) async {
    final db = await _appDatabase.database;
    return await db.delete('students', where: 'studentId = ?', whereArgs: [id]);
  }

  Future<List<Student>> listar() async {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query('students');
    return List.generate(maps.length, (i) => Student.fromMap(maps[i]));
  }
}
