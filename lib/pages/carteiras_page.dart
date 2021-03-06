import 'package:cryptomoeda/models/posicao.dart';
import 'package:cryptomoeda/provider/conta_respository.dart';
import 'package:cryptomoeda/settings/app_prefrerences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class CarteirasPage extends StatefulWidget {
  const CarteirasPage({Key? key}) : super(key: key);

  @override
  _CarteirasPageState createState() => _CarteirasPageState();
}

class _CarteirasPageState extends State<CarteirasPage> {
  int index = 0;
  double totalCarteira = 0;
  double saldo = 0;

  String graficoLabel = '';
  double graficoValor = 0;
  List<Posicao> carteira = [];

  late NumberFormat real;
  late ContaRespository conta;

  @override
  Widget build(BuildContext context) {
    conta = Provider.of<ContaRespository>(context);
    final loc = context.read<AppPrefrerences>().locale;
    real = NumberFormat.currency(locale: loc['locale '], name: loc['name']);
    saldo = conta.saldo;

    setAllWalley();
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 48, bottom: 8),
              child: Text(
                'Valor da carteira',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              real.format(
                totalCarteira,
              ),
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.5,
              ),
            ),
            loadGrafico(),
            loadHistorico(),
          ],
        ),
      ),
    );
  }

  setAllWalley() {
    final carteiraList = conta.carteira;
    setState(() {
      totalCarteira = conta.saldo;
      for (var posicao in carteiraList) {
        totalCarteira += posicao.moeda.preco * posicao.quantidade;
      }
    });
  }

  List<PieChartSectionData> loadCarteira() {
    setGraficoDados(index);
    carteira = conta.carteira;
    final tamanhoLista = carteira.length + 1;

    return List.generate(tamanhoLista, (i) {
      final isTouched = i == index;
      final isSaldo = i == tamanhoLista - 1;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];

      double porcentagem = 0;
      if (!isSaldo) {
        porcentagem =
            carteira[i].moeda.preco * carteira[i].quantidade / totalCarteira;
      } else {
        porcentagem = (conta.saldo > 0) ? conta.saldo / totalCarteira : 0;
      }
      porcentagem *= 100;

      return PieChartSectionData(
        color: color,
        value: porcentagem,
        title: '${porcentagem.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    });
  }

  void setGraficoDados(int index) {
    if (index < 0) return;
    if (index == carteira.length) {
      graficoLabel = 'Saldo';
      graficoValor = conta.saldo;
    } else {
      graficoLabel = carteira[index].moeda.nome;
      graficoValor = carteira[index].moeda.preco * carteira[index].quantidade;
    }
  }

  loadGrafico() {
    return (conta.saldo <= 0)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 5,
                    sections: loadCarteira(),
                    centerSpaceRadius: 110,
                    pieTouchData: PieTouchData(
                      touchCallback: (touch) => setState(
                        () {
                          index = touch.touchedSection!.touchedSectionIndex;
                          setGraficoDados(index);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    graficoLabel,
                    style: TextStyle(fontSize: 20, color: Colors.teal),
                  ),
                  Text(
                    real.format(graficoValor),
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ],
              )
            ],
          );
  }

  loadHistorico() {
    final historico = conta.historico;
    final date = DateFormat('dd/MM/yyyy - hh:mm');
    List<Widget> widgets = [];
    for (var operacao in historico) {
      widgets.add(ListTile(
        title: Text(operacao.moeda.nome),
        subtitle: Text(date.format(operacao.dataOperacao)),
        trailing: Text(real.format(
          (operacao.moeda.preco * operacao.quantidade),
        )),
      ));
      widgets.add(Divider());
    }
    return Column(
      children: widgets,
    );
  }
}
