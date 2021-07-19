import 'package:cryptomoeda/models/moeda.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MoedasDetalhesPage extends StatefulWidget {
  Moeda moeda;
  MoedasDetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  _MoedasDetalhesPageState createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _form = GlobalKey<FormState>();
  final _valor = TextEditingController();

  double quantidade = 0;

  compra() {
    if (_form.currentState!.validate()) {
      // salvar a compra
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compra realizada com sucesso')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moeda.nome),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          widget.moeda.icone,
                          height: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          real.format(widget.moeda.preco),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  (quantidade > 0)
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            child: Text(
                              '$quantidade ${widget.moeda.sigla}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.teal,
                              ),
                            ),
                            margin: EdgeInsets.only(bottom: 24),
                            alignment: Alignment.center,
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(bottom: 24),
                        ),
                  Form(
                    key: _form,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Valor',
                        prefixIcon: Icon(Icons.monetization_on_outlined),
                        suffix: Text(
                          'Reais',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      controller: _valor,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        setState(() {
                          quantidade = (value.isEmpty)
                              ? 0
                              : double.parse(value) / widget.moeda.preco;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe o valor da compra';
                        } else if (double.parse(value) < 50) {
                          return 'Compra minima é  R\$  50.00';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(top: 24),
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child:
                                Text('Comprar', style: TextStyle(fontSize: 20)),
                          )
                        ],
                      ),
                      onPressed: () => compra(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
