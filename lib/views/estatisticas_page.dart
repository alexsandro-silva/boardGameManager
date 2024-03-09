import 'package:flutter/material.dart';

class EstatisticaPage extends StatefulWidget {
  const EstatisticaPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EstatisticaPage();
  }
}

class _EstatisticaPage extends State<EstatisticaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
