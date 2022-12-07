class Shelf {
  final int? id;
  final String name;

  const Shelf({
    required this.id,
    required this.name,
  });

  // Convert a Shelve into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Implement toString to make it easier to see information about
  // each shelve when using the print statement.
  @override
  String toString() {
    return 'Shelf{id: $id, name: $name}';
  }
}
