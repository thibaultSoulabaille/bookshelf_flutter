import 'package:flutter/material.dart';
import 'package:bookshelf/model/book.dart';
import 'package:bookshelf/model/language.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../db/bookshelf_database.dart';
import '../model/author.dart';

import 'package:image_picker/image_picker.dart';

import 'dart:io';

class EditBook extends StatefulWidget {
  final int bookId;
  final String bookTitle;
  final Uint8List bookCover;
  final String authorFirstName;
  final String authorLastName;
  final int bookPages;
  final int bookReleaseDate;
  final String bookLanguage;

  const EditBook(
      this.bookId,
      this.bookTitle,
      this.bookCover,
      this.authorFirstName,
      this.authorLastName,
      this.bookPages,
      this.bookReleaseDate,
      this.bookLanguage,
      {super.key});

  @override
  State<EditBook> createState() => _EditBookState(bookId, bookReleaseDate);
}

class _EditBookState extends State<EditBook> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _releaseDateController = TextEditingController();

  late final int bookId;
  late String bookTitle;
  late Uint8List bookCover;
  late String authorFirstName;
  late String authorLastName;
  late int bookPages;
  late int bookReleaseDate;
  late String bookLanguage;

  _EditBookState(this.bookId, this.bookReleaseDate);

  @override
  void initState() {
    _releaseDateController.text = bookId == 0
        ? ""
        : DateFormat.yMd()
            .format(DateTime.fromMillisecondsSinceEpoch(bookReleaseDate));
    super.initState();
  }

  Future<int?> getAuthorId(
      String authorFirstName, String authorLastName) async {
    List<Author> authors = await BookShelfDatabase.instance.loadAllAuthors();

    for (int i = 0; i < authors.length; i++) {
      if (authors[i].firstName == authorFirstName &&
          authors[i].lastName == authorLastName) {
        return authors[i].id;
      }
    }

    return await BookShelfDatabase.instance.createAuthor(Author(
      id: null,
      firstName: authorFirstName,
      lastName: authorLastName,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Edit Book'),
        actions: [
          TextButton(
            onPressed: () async {
              var form = _formKey.currentState!;
              if (form.validate()) {
                form.save();

                int? authorId =
                    await getAuthorId(authorFirstName, authorLastName);

                if (bookId == 0) {
                  BookShelfDatabase.instance.createBook(
                    Book(
                      id: null,
                      shelfId: 0,
                      title: bookTitle,
                      cover: bookCover,
                      authorId: authorId!,
                      nPages: bookPages,
                      releaseDateTimestamp: bookReleaseDate,
                      language: bookLanguage,
                      readingStatus: 0,
                    ),
                  );
                } else {
                  BookShelfDatabase.instance.updateBook(
                    Book(
                      id: bookId,
                      shelfId: 0,
                      title: bookTitle,
                      cover: bookCover,
                      authorId: authorId!,
                      nPages: bookPages,
                      releaseDateTimestamp: bookReleaseDate,
                      language: bookLanguage,
                      readingStatus: 2,
                    ),
                  );
                }
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: bookId == 0 ? null : widget.bookTitle,
                    decoration: const InputDecoration(
                      // filled: true,
                      // fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      labelText: 'Book title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the book title.';
                      }
                      return null;
                    },
                    onSaved: (val) => setState(
                      () {
                        bookTitle = val!;
                      },
                    ),
                  ),
                  const Divider(
                    height: 48,
                    indent: 2,
                    endIndent: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ), // Image border
                              child: SizedBox(
                                // width: 200,
                                height: 208,
                                // Image radius
                                child: bookId == 0 ? const Text("Book cover") : Image.memory(
                                  widget.bookCover,
                                  gaplessPlayback: true,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.image_rounded, size: 18),
                              label: const Text("Edit cover"),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer),
                                padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                    const EdgeInsets.only(left: 16, right: 24)),
                                fixedSize: MaterialStateProperty.all<Size>(
                                    const Size.fromHeight(40)),
                              ),
                              onPressed: () async {
                                XFile? pickedFile =
                                    await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                  maxWidth: 500,
                                  maxHeight: 800,
                                );
                                if (pickedFile != null) {
                                  setState(() {
                                    File? imageFile = File(pickedFile.path);
                                    bookCover = imageFile.readAsBytesSync();
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: bookId == 0
                                  ? null
                                  : widget.bookPages.toString(),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Pages',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the number of pages.';
                                }
                                return null;
                              },
                              onSaved: (val) => setState(
                                () {
                                  bookPages = int.parse(val!);
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 16,
                              ),
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: _releaseDateController,
                              // initialValue: bookId == 0 ? null : DateFormat.yMd().format(DateTime.now()),
                              decoration: const InputDecoration(
                                labelText: 'Release date',
                                helperText: 'MM/DD/YYYY',
                                suffixIcon: Icon(Icons.calendar_today_rounded),
                                border: OutlineInputBorder(),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.utc(2000),
                                  lastDate: DateTime.utc(2025),
                                );

                                if (pickedDate != null) {
                                  bookReleaseDate =
                                      pickedDate.millisecondsSinceEpoch;
                                  setState(() {
                                    _releaseDateController.text =
                                        DateFormat.yMd().format(pickedDate);
                                  });
                                }
                              },

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select the release date.';
                                }
                                return null;
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 16,
                              ),
                            ),
                            DropdownButtonFormField<String>(
                              elevation: 2,
                              dropdownColor: ElevationOverlay.applySurfaceTint(
                                  Theme.of(context).colorScheme.surface,
                                  Theme.of(context).colorScheme.surfaceTint,
                                  2),
                              value: bookId == 0 ? null : widget.bookLanguage,
                              items: languages.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the language';
                                }
                                return null;
                              },
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  bookLanguage = value!;
                                });
                              },
                              onSaved: (val) => setState(
                                () {
                                  bookLanguage = val!;
                                },
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Language',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 48,
                    indent: 2,
                    endIndent: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 8, left: 2),
                    child: Text(
                      "Author information",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  TextFormField(
                    initialValue: bookId == 0 ? null : widget.authorFirstName,
                    // initialValue: bookId == 0 ? null : widget.bookTitle,
                    decoration: const InputDecoration(
                      // filled: true,
                      // fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      labelText: 'First name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the author's first name.";
                      }
                      return null;
                    },
                    onSaved: (val) => setState(
                      () {
                        authorFirstName = val!.trim();
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                    ),
                  ),
                  TextFormField(
                    initialValue: bookId == 0 ? null : widget.authorLastName,
                    // initialValue: bookId == 0 ? null : widget.bookTitle,
                    decoration: const InputDecoration(
                      // filled: true,
                      // fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      labelText: 'Last name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the author's last name.";
                      }
                      return null;
                    },
                    onSaved: (val) => setState(
                      () {
                        authorLastName = val!.trim();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
