import 'dart:typed_data';

class Book {
  final int? id;
  final int? shelfId;
  final String title;
  final Uint8List cover;
  final int authorId;
  final int nPages;
  final int releaseDateTimestamp;
  final String language;

  const Book({
    required this.id,
    this.shelfId,
    required this.title,
    required this.cover,
    required this.authorId,
    required this.nPages,
    required this.releaseDateTimestamp,
    required this.language,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shelf_id': shelfId,
      'title': title,
      'cover': cover,
      'author_id': authorId,
      'n_pages': nPages,
      'release_date': releaseDateTimestamp,
      'language': language,
    };
  }

  // Implement toString to make it easier to see information about
  // each shelve when using the print statement.
  @override
  String toString() {
    return 'Book{id: $id, shelf_id: $shelfId, title: $title, n_pages: $nPages, release_date: $releaseDateTimestamp, language: $language}';
  }
}
