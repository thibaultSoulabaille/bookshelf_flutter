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
  final int? startedReadingDateTimestamp;
  final int? endedReadingDateTimestamp;
  final int readingStatus;

  const Book({
    required this.id,
    this.shelfId,
    required this.title,
    required this.cover,
    required this.authorId,
    required this.nPages,
    required this.releaseDateTimestamp,
    required this.language,
    required this.readingStatus,
    this.startedReadingDateTimestamp,
    this.endedReadingDateTimestamp,
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
      'reading_status': readingStatus,
      'started_reading_date': startedReadingDateTimestamp,
      'ended_reading_date': endedReadingDateTimestamp,
    };
  }

  // Implement toString to make it easier to see information about
  // each shelve when using the print statement.
  @override
  String toString() {
    return 'Book{id: $id, shelf_id: $shelfId, title: $title, n_pages: $nPages, release_date: $releaseDateTimestamp, language: $language}';
  }
}
