import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:finalexemplo/app/core/colors_extension.dart';
import 'package:finalexemplo/app/core/text_style_extension.dart';

class CombustivelApp extends StatefulWidget {
  const CombustivelApp({super.key});

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
      double fator = fatoresCorrecao[veiculo] ?? 1.0;
      double regraVezesFator = 0.7 * fator;

      setState(() {
        resultado = razao <= regraVezesFator ? '✅ Abasteça com Etanol! Mais vantajoso.\n Etanol/Gasolina = $razao\n $razao <= $regraVezesFator (Regra [0.7] * Fator [$fator])' :
        '⛽ Abasteça com Gasolina! Mais vantajoso.\n Etanol/Gasolina = $razao\n $razao > $regraVezesFator (Regra [0.7] * Fator [$fator])';
      });
      
      String mensagemCompartilhar = '''
        📌 Resultado do comparativo de combustíveis:
        🏪 Posto: $nomePosto
        ⛽ Etanol: R\$ $etanol
        🛢 Gasolina: R\$ $gasolina
        🚗 Veículo: $veiculo
        📊 Conclusão: $resultado
      ''';

      if (enviarDados) {
        Share.share(mensagemCompartilhar, subject: 'Comparativo de Combustíveis');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'Radar do Combustível',
              style: context.textStyles.textTitle.copyWith(color: context.colors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              'Compare preços e escolha a melhor opção para abastecer!',
              textAlign: TextAlign.center,
              style: context.textStyles.textRegular.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField('Nome do Posto', Icons.store, (value) => nomePosto = value),
                  const SizedBox(height: 12),
                  _buildTextField('Preço do Etanol', Icons.local_gas_station, (value) => etanol = double.tryParse(value) ?? 0.0, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  _buildTextField('Preço da Gasolina', Icons.local_gas_station_outlined, (value) => gasolina = double.tryParse(value) ?? 0.0, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  _buildDropdown(),
                  CheckboxListTile(
                    title: Text('Compartilhar resultado após o cálculo?', style: context.textStyles.textRegular),
                    value: enviarDados,
                    onChanged: (value) => setState(() => enviarDados = value!),
                  ),
                  const SizedBox(height: 12),
                  _buildCalculateButton(),
                  const SizedBox(height: 20),
                  _buildResultCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, Function(String) onChanged, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: context.colors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Por favor, insira $label';
        if (keyboardType == TextInputType.number && value.contains(',')) return 'Use ponto para valores decimais (Ex: 3.80)';
        return null;
      },
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: veiculo,
      items: ['Carro', 'Moto'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: context.textStyles.textRegular),
        );
      }).toList(),
      onChanged: (newValue) => setState(() => veiculo = newValue!),
      decoration: InputDecoration(
        labelText: 'Tipo de Veículo',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.secondary,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: calcular,
        child: Text('Calcular', style: context.textStyles.textBold.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildResultCard() {
    return resultado.isNotEmpty
        ? Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(resultado, textAlign: TextAlign.center, style: context.textStyles.textMedium.copyWith(fontSize: 18)),
            ),
          )
        : const SizedBox.shrink();
  }
}
