class Book {
  final int? id;
  final String title;
  // final Author author;
  final int nPages;

  const Book({
    required this.id,
    required this.title,
    // required this.author,
    required this.nPages,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      // 'author': author
      'n_pages': nPages,
    };
  }

  // Implement toString to make it easier to see information about
  // each shelve when using the print statement.
  @override
  String toString() {
    return 'Shelf{id: $id, title: $title, n_pages: $nPages}';
  }
}
