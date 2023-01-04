import 'package:flutter/material.dart';

const List<Widget> fruits = <Widget>[
  Text('Finished'),
  Text('Reading'),
  Text('Not started')
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'ToggleButtons Sample';

  @override
  Widget build(BuildContext context) {
    return const ToggleButtonsSample(title: _title);
  }
}

class ToggleButtonsSample extends StatefulWidget {
  const ToggleButtonsSample({super.key, required this.title});

  final String title;

  @override
  State<ToggleButtonsSample> createState() => _ToggleButtonsSampleState();
}

class _ToggleButtonsSampleState extends State<ToggleButtonsSample> {
  final List<bool> _selectedFruits = <bool>[true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ToggleButtons(
          direction: Axis.horizontal,
          onPressed: (int index) {
            setState(() {
              // The button that is tapped is set to true, and the others to false.
              for (int i = 0; i < _selectedFruits.length; i++) {
                _selectedFruits[i] = i == index;
              }
            });
          },
          textStyle: Theme.of(context).textTheme.labelLarge,
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          borderColor: Theme.of(context).colorScheme.outline,
          selectedBorderColor: Theme.of(context).colorScheme.outline,
          selectedColor: Theme.of(context).colorScheme.onSecondaryContainer,
          fillColor: Theme.of(context).colorScheme.secondaryContainer,
          color: Theme.of(context).colorScheme.onSurface,
          constraints: BoxConstraints.expand(
            height: 40.0,
            width: (MediaQuery.of(context).size.width-36)/3.0,
          ),
          isSelected: _selectedFruits,
          children: fruits,
        ),
      ),
    );
  }
}
