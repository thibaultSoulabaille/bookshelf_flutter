class Author {
  final int? id;
  final String firstName;
  final String lastName;

  const Author({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
