import 'package:flutter/material.dart';
import 'package:bookshelf/model/shelf.dart';

import '../db/shelves_database.dart';

class EditShelf extends StatefulWidget {
  const EditShelf({super.key});

  @override
  State<EditShelf> createState() => _EditShelfState();
}

class _EditShelfState extends State<EditShelf> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shelf'),
        actions: [
          TextButton(
            onPressed: () {
              var form = _formKey.currentState!;
              if (form.validate()) {
                form.save();
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
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      // filled: true,
                      // fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      labelText: 'Shelf name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the shelf name.';
                      }
                      return null;
                    },
                    onSaved: (val) => setState(() {
                      ShelvesDatabase.instance.createShelf(Shelf(
                        id: null,
                        name: val!,
                      ));
                    }),
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
