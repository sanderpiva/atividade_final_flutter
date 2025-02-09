import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Radar do Combustível',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CombustivelApp(),
    );
  }
}

class CombustivelApp extends StatefulWidget {
  const CombustivelApp({Key? key}) : super(key: key);

  @override
  State<CombustivelApp> createState() => _CombustivelAppState();
}

class _CombustivelAppState extends State<CombustivelApp> {
  final _formKey = GlobalKey<FormState>();
  double etanol = 0.0;
  double gasolina = 0.0;
  String veiculo = 'Carro';
  String nomePosto = '';
  String resultado = '';
  bool enviarDados = false;

  
  Map<String, double> fatoresCorrecao = {
    'Carro': 0.9,
    'Moto': 0.85,
  };

  void calcular() {
    if (_formKey.currentState!.validate()) {
      double razao = etanol / gasolina;
      double fator = fatoresCorrecao[veiculo] ??
          1.0; // Valor padrão se o veículo não estiver na lista
      double regraVezesFator = 0.7 * fator;
      if (razao <= regraVezesFator) {
        setState(() {
          resultado = 'Abasteça com etanol! É mais vantajoso.\n'
              'Etanol/Gasolina = $razao\n'
              '$razao <= $regraVezesFator (Regra [0.7] * Fator [$fator])';
        });
      } else {
        setState(() {
          resultado = 'Abasteça com gasolina! É mais vantajoso.\n'
              'Etanol/Gasolina = $razao\n'
              '$razao > $regraVezesFator (Regra [0.7] * Fator [$fator])';
        });
      }

      String mensagemCompartilhar = 'Resultado do comparativo de combustíveis:\n'
          'Nome do Posto: $nomePosto\n'
          'Preço do Etanol: R\$ $etanol\n'
          'Preço da Gasolina: R\$ $gasolina\n'
          'Veículo: $veiculo\n'
          'Conclusão: $resultado';

      if (enviarDados) {
        Share.share(
          mensagemCompartilhar,
          subject: 'Resultado do Comparativo de Combustíveis',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Radar do Combustível'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome do Posto'),
                onChanged: (value) {
                  nomePosto = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do posto';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  etanol = double.tryParse(value) ?? 0.0;
                },
                decoration: InputDecoration(labelText: 'Preço do Etanol'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço do etanol';
                  }if(value.contains(',')){
                    return 'Por favor, insira o valor com pontos: Ex: 3.80';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  gasolina = double.tryParse(value) ?? 0.0;
                },
                decoration: InputDecoration(labelText: 'Preço da Gasolina'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço da gasolina';
                  }if(value.contains(',')){
                    return 'Por favor, insira o valor com pontos: Ex: 3.80';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: veiculo,
                items: ['Carro', 'Moto'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    veiculo = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Tipo de Veículo'),
              ),
              CheckboxListTile(
                title: Text('Compartilhar dados'),
                value: enviarDados,
                onChanged: (bool? value) {
                  setState(() {
                    enviarDados = value ?? false;
                  });
                },
              ),
              ElevatedButton(
                onPressed: calcular,
                child: Text('Calcular'),
              ),
              SizedBox(height: 20),
              Text(resultado),
            ],
          ),
        ),
      ),
    );
  }
}
