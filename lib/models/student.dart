class Student {
  int? studentId;
  String name;
  String ra;
  String email;
  int? courseId; // Chave estrangeira para vincular ao curso

  Student({
    this.studentId,
    required this.name,
    required this.ra,
    required this.email,
    this.courseId,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'name': name,
      'ra': ra,
      'email': email,
      'courseId': courseId, // Salva o ID do curso no banco
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      studentId: map['studentId'] as int?,
      name: map['name'] as String,
      ra: map['ra'] as String,
      email: map['email'] as String,
      courseId: map['courseId'] as int?, // Recupera o ID do curso do banco
    );
  }
}
