import 'package:flutter/material.dart';
import 'package:bookshelf/model/book.dart';
import 'package:flutter/services.dart';

import '../db/bookshelf_database.dart';

class EditBook extends StatefulWidget {
  final int bookId;
  final String bookTitle;
  final int bookPages;
  const EditBook(this.bookId, this.bookTitle, this.bookPages, {super.key});

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final _formKey = GlobalKey<FormState>();

  late final int bookId;
  late final String bookTitle;
  late final int bookPages;

  @override
  Widget build(BuildContext context) {
    int bookId = widget.bookId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book'),
        actions: [
          TextButton(
            onPressed: () {
              var form = _formKey.currentState!;
              if (form.validate()) {
                form.save();

                if (bookId == 0) {
                  BookShelfDatabase.instance.createBook(
                    Book(
                      id: null,
                      title: bookTitle,
                      nPages: bookPages,
                    ),
                  );
                } else {
                  BookShelfDatabase.instance.updateBook(
                    Book(
                      id: bookId,
                      title: bookTitle,
                      nPages: bookPages,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.only(
                top: 16,
              ),
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
                  Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: const Text("Author information"),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          // initialValue: bookId == 0 ? null : widget.bookTitle,
                          decoration: const InputDecoration(
                            // filled: true,
                            // fillColor: Theme.of(context).colorScheme.surfaceVariant,
                            labelText: 'First name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 8)),
                      Flexible(
                        child: TextFormField(
                          // initialValue: bookId == 0 ? null : widget.bookTitle,
                          decoration: const InputDecoration(
                            // filled: true,
                            // fillColor: Theme.of(context).colorScheme.surfaceVariant,
                            labelText: 'Last name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                  ),
                  TextFormField(
                    initialValue: bookId == 0 ? null : widget.bookPages.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter> [
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
