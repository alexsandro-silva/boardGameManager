import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AddCampeonatoPage extends StatefulWidget {
  const AddCampeonatoPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddCampeonatoPage();
  }
}

class _AddCampeonatoPage extends State<AddCampeonatoPage> {
  final _nomeController = TextEditingController();
  double _currentSliderValue = 0;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Campeonato'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildNomeTextField(),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Quantidade de Jogadores'),
          ),
          _buildSlider(),
          _buildSaveButton()
        ],
      ),
    );
  }

  Widget _buildNomeTextField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        autofocus: true,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(labelText: 'Nome'),
        controller: _nomeController,
        enabled: true,
      ),
    );
  }

  Widget _buildSlider() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Slider(
          value: _currentSliderValue,
          max: 8,
          divisions: 2,
          label: _currentSliderValue.round().toString(),
          onChanged: (double value) =>
              {setState(() => _currentSliderValue = value)}),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FloatingActionButton(
        onPressed: addCampeonato,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: _loading ? _circularLoading() : const Text('Salvar'),
      ),
    );
  }

  void addCampeonato() async {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Nome do campeonato vazio"),
        duration: Duration(seconds: 3),
      ));
      return;
    }

    await _saveCampeonato(_nomeController.text, _currentSliderValue);
    setState(() {
      _nomeController.clear();
    });
  }

  void _saving(bool enable) {
    setState(() {
      _loading = enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: const CircularProgressIndicator(),
    );
  }

  Future<void> _saveCampeonato(String nome, double qtdJogadores) async {
    _saving(true);
    final campeonato = ParseObject('Campeonato')
      ..set('nome', nome)
      ..set('qtdJogadores', qtdJogadores);

    await campeonato.save();

    _saving(false);
  }
}
