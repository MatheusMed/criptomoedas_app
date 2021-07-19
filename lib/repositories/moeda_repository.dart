import 'package:cryptomoeda/models/moeda.dart';

class MoedaRepository {
  static List<Moeda> tabela = [
    Moeda(
        icone: 'images/bitcoin.png',
        nome: 'Bitcoin',
        sigla: 'BTC',
        preco: 34202.9),
    Moeda(
        icone: 'images/dogecoin.png',
        nome: 'Dogecoin',
        sigla: 'DOGE',
        preco: 0.24412),
    Moeda(
        icone: 'images/binancecoin.png',
        nome: 'Binancecoin',
        sigla: 'BNB',
        preco: 307.85),
    Moeda(
        icone: 'images/ethereum.png',
        nome: 'Ethereum',
        sigla: 'ETH',
        preco: 1980.2),
    Moeda(
        icone: 'images/tether.png',
        nome: 'Tether',
        sigla: 'USDT',
        preco: 1.0002),
  ];
}
