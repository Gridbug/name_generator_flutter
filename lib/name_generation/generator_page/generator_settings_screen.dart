import 'package:flutter/material.dart';

class GeneratorSettingsScreen extends StatefulWidget {
  static const name = 'Generator settings';
  static const routeName = 'settings';
  static const icon = Icons.cyclone;

  const GeneratorSettingsScreen({super.key});

  @override
  State<GeneratorSettingsScreen> createState() =>
      _GeneratorSettingsScreenState();
}

class _GeneratorSettingsScreenState extends State<GeneratorSettingsScreen> {
  bool firstSetting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(GeneratorSettingsScreen.name),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'First setting',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Switch(
                    value: firstSetting,
                    onChanged: (bool newValue) {
                      setState(() {
                        firstSetting = newValue;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
