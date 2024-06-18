import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta de CEP',
      home: ConsultaCepPage(),
    );
  }
}

class ConsultaCepPage extends StatefulWidget {
  @override
  _ConsultaCepPageState createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  final TextEditingController _cepController = TextEditingController();
  Map<String, dynamic>? _resultado;

  Future<void> _consultarCep() async {
    final cep = _cepController.text;
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _resultado = data;
      });
    } else {
      setState(() {
        _resultado = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de CEP - Nome do Aluno - 12/06/2024'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _cepController,
              decoration: InputDecoration(
                labelText: 'Digite o CEP',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _consultarCep,
              child: Text('Consultar'),
            ),
            SizedBox(height: 16.0),
            _resultado != null
                ? Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange[200],
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CEP Consultado: ${_resultado!['cep']}'),
                        SizedBox(height: 8.0),
                        Text('Logradouro: ${_resultado!['logradouro']}'),
                        SizedBox(height: 8.0),
                        Text('Bairro: ${_resultado!['bairro']}'),
                        SizedBox(height: 8.0),
                        Text('Cidade: ${_resultado!['localidade']} - ${_resultado!['uf']}'),
                      ],
                    ),
                  )
                : Text('Digite um CEP válido!'),
          ],
        ),
      ),
    );
  }
}