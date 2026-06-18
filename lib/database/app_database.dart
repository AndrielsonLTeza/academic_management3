import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/course.dart';

class AppDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'academic_management.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de Cursos
    await db.execute('''
    CREATE TABLE courses (
      courseId INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      duration INTEGER NOT NULL,
      coordinator TEXT NOT NULL,
      description TEXT NOT NULL
    )
  ''');

    // TABELA DE ALUNOS ATUALIZADA (Com interligação)
    await db.execute('''
    CREATE TABLE students (
      studentId INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      ra TEXT NOT NULL,
      email TEXT NOT NULL,
      courseId INTEGER,
      FOREIGN KEY (courseId) REFERENCES courses (courseId) ON DELETE SET NULL
    )
  ''');

    // Executa a carga inicial mantendo os teus dados e adicionando os de teste
    await _seedDatabase(db);
  }

  // FUNÇÃO AUXILIAR ATUALIZADA (Contém os teus 5 cursos iniciais + os novos)
  Future<void> _seedDatabase(Database db) async {
    List<Course> cursosParaPopular = [
      // --- OS TEUS 5 CURSOS ORIGINAIS PRESERVADOS ---
      Course(
        courseId: 1,
        name: "Informatica",
        duration: 4,
        coordinator: "Alna",
        description: "Curso técnico básico e avançado de informática.",
      ),
      Course(
        courseId: 2,
        name: "Engenharia eletrica",
        duration: 8,
        coordinator: "Mario",
        description: "Fundamentos de eletricidade e sistemas de potência.",
      ),
      Course(
        courseId: 3,
        name: "Culinaria",
        duration: 8,
        coordinator: "Jacan",
        description: "Técnicas de alta gastronomia e cozinha internacional.",
      ),
      Course(
        courseId: 4,
        name: "Eletrica 2",
        duration: 5,
        coordinator: "Eletrolico",
        description: "Aprofundamento em circuitos elétricos.",
      ),
      Course(
        courseId: 5,
        name: "Matematica",
        duration: 4,
        coordinator: "Albert",
        description: "Cálculo, álgebra e lógica matemática.",
      ),

      // --- CURSOS ADICIONAIS PARA TESTAR A PAGINAÇÃO DE 10 EM 10 ---
      Course(
        courseId: 6,
        name: "Sistemas de Informação",
        duration: 8,
        coordinator: "Linus",
        description: "Foco em desenvolvimento e infraestrutura.",
      ),
      Course(
        courseId: 7,
        name: "Administração",
        duration: 8,
        coordinator: "Chiavener",
        description: "Teorias gerais da administração.",
      ),
      Course(
        courseId: 8,
        name: "Direito",
        duration: 10,
        coordinator: "Rui Barbosa",
        description: "Estudos jurídicos e constitucionais.",
      ),
      Course(
        courseId: 9,
        name: "Medicina",
        duration: 12,
        coordinator: "Oswaldo",
        description: "Formação médica integral.",
      ),
      Course(
        courseId: 10,
        name: "Arquitetura",
        duration: 10,
        coordinator: "Niemeyer",
        description: "Urbanismo e projetos de estruturas.",
      ),
      Course(
        courseId: 11,
        name: "Enfermagem",
        duration: 8,
        coordinator: "Florence",
        description: "Cuidados de saúde e primeiros socorros.",
      ),
      Course(
        courseId: 12,
        name: "Psicologia",
        duration: 10,
        coordinator: "Freud",
        description: "Análise comportamental e clínica.",
      ),
      Course(
        courseId: 13,
        name: "Educação Física",
        duration: 8,
        coordinator: "Paulo",
        description: "Anatomia e dinâmicas desportivas.",
      ),
      Course(
        courseId: 14,
        name: "Biologia",
        duration: 8,
        coordinator: "Darwin",
        description: "Estudo da evolução e ecossistemas.",
      ),
      Course(
        courseId: 15,
        name: "História",
        duration: 8,
        coordinator: "Heródoto",
        description: "Análise cronológica de civilizações.",
      ),
      Course(
        courseId: 16,
        name: "Geografia",
        duration: 8,
        coordinator: "Mercator",
        description: "Cartografia e análise geopolítica.",
      ),
      Course(
        courseId: 17,
        name: "Física",
        duration: 8,
        coordinator: "Newton",
        description: "Mecânica clássica e termodinâmica.",
      ),
      Course(
        courseId: 18,
        name: "Química",
        duration: 8,
        coordinator: "Lavoisier",
        description: "Laboratório e transformações orgânicas.",
      ),
      Course(
        courseId: 19,
        name: "Filosofia",
        duration: 8,
        coordinator: "Sócrates",
        description: "Ética, política e lógica clássica.",
      ),
      Course(
        courseId: 20,
        name: "Artes Visuais",
        duration: 8,
        coordinator: "Da Vinci",
        description: "História da arte e técnicas de pintura.",
      ),
      Course(
        courseId: 21,
        name: "Agronomia",
        duration: 10,
        coordinator: "Embrapa",
        description: "Produção agrícola sustentável.",
      ),
      Course(
        courseId: 22,
        name: "Design Gráfico",
        duration: 4,
        coordinator: "Donis",
        description: "Composição visual e mídias digitais.",
      ),
      Course(
        courseId: 23,
        name: "Gastronomia Avançada",
        duration: 4,
        coordinator: "Fogaça",
        description: "Técnicas culinárias internacionais.",
      ),
      Course(
        courseId: 24,
        name: "Engenharia de Software",
        duration: 8,
        coordinator: "Margaret",
        description: "Ciclo de vida e qualidade de software.",
      ),
      Course(
        courseId: 25,
        name: "Inteligência Artificial",
        duration: 6,
        coordinator: "Turing",
        description: "Redes neurais e deep learning.",
      ),
      Course(
        courseId: 26,
        name: "Ciência da Computação",
        duration: 8,
        coordinator: "Lovelace",
        description: "Complexidade de algoritmos.",
      ),
      Course(
        courseId: 27,
        name: "Pedagogia",
        duration: 8,
        coordinator: "Paulo Freire",
        description: "Métodos de ensino e inclusão.",
      ),
      Course(
        courseId: 28,
        name: "Medicina Veterinária",
        duration: 10,
        coordinator: "São Francisco",
        description: "Clínica e cirurgia animal.",
      ),
      Course(
        courseId: 29,
        name: "Nutrição",
        duration: 8,
        coordinator: "Carl",
        description: "Bioquímica dos alimentos.",
      ),
      Course(
        courseId: 30,
        name: "Jornalismo",
        duration: 8,
        coordinator: "Erick",
        description: "Redação, rádio e TV.",
      ),
    ];

    for (var curso in cursosParaPopular) {
      await db.insert(
        'courses',
        curso.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
