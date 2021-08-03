import 'package:cryptomoeda/database/db.dart';
import 'package:cryptomoeda/models/historico.dart';
import 'package:cryptomoeda/models/moeda.dart';
import 'package:cryptomoeda/models/posicao.dart';
import 'package:cryptomoeda/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContaRespository extends ChangeNotifier {
  late Database db;
  List<Posicao> _carteira = [];
  List<Historico> _historico = [];
  double _saldo = 0;

  get saldo => _saldo;

  List<Posicao> get carteira => _carteira;
  List<Historico> get historico => _historico;

  ContaRespository() {
    _initRespository();
  }

  _initRespository() async {
    await _getSaldo();
    await _getCarteira();
    await _getHistorico();
  }

  _getSaldo() async {
    db = await DB.instance.database;
    List conta = await db.query('conta', limit: 1);
    _saldo = conta.first['saldo'];
    notifyListeners();
  }

  setSaldo(double valor) async {
    db = await DB.instance.database;

    db.update('conta', {
      'saldo': valor,
    });
    _saldo = valor;
    notifyListeners();
  }

  comprar(Moeda moeda, double valor) async {
    db = await DB.instance.database;

    await db.transaction((txn) async {
      final posicaoMoeda = await txn.query(
        'carteira',
        where: 'sigla = ?',
        whereArgs: [moeda.sigla],
      );
      //verificar se nao tem a moerda
      if (posicaoMoeda.isEmpty) {
        await txn.insert('carteira', {
          'sigla': moeda.sigla,
          'moeda': moeda.nome,
          'quantidade': (valor / moeda.preco).toString()
        });
      } else {
        final atual = double.parse(posicaoMoeda.first['quantidade'].toString());
        await txn.update(
            'carteira',
            {
              'quantidade': (atual + (valor / moeda.preco)).toString(),
            },
            where: 'singla =?',
            whereArgs: [moeda.sigla]);
      }

      await txn.insert('historico', {
        'sigla': moeda.sigla,
        'moeda': moeda.nome,
        'quantidade': (valor / moeda.preco).toString(),
        'valor': valor,
        'tipo_operacao': 'comprar',
        'data_operacao': DateTime.now().microsecondsSinceEpoch
      });

      await txn.update('conta', {'saldo': saldo - valor});
    });

    await _initRespository();
    notifyListeners();
  }

  _getCarteira() async {
    _carteira = [];
    List posicaes = await db.query('carteira');
    posicaes.forEach((posicao) {
      Moeda moeda = MoedaRepository.tabela.firstWhere(
        (m) => m.sigla == posicao['sigla'],
      );
      _carteira.add(
        Posicao(
          moeda: moeda,
          quantidade: double.parse(posicao['quantidade']),
        ),
      );
    });

    notifyListeners();
  }

  _getHistorico() async {
    _historico = [];
    List operacoes = await db.query('historico');
    operacoes.forEach((operacao) {
      Moeda moeda = MoedaRepository.tabela.firstWhere(
        (m) => m.sigla == operacao['sigla'],
      );
      _historico.add(
        Historico(
          dataOperacao:
              DateTime.fromMicrosecondsSinceEpoch(operacao['data_operacao']),
          tipoOperacao: operacao['tipo_operacao'],
          moeda: moeda,
          valor: double.parse(
            operacao['valor'],
          ),
          quantidade: double.parse(
            operacao['quantidade'],
          ),
        ),
      );
    });
    notifyListeners();
  }
}
