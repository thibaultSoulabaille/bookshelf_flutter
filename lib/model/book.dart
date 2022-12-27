import 'author.dart';

class Book {
  final int? id;
  final String title;
  final Author author;
  final int nPages;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.nPages,
  });
}
