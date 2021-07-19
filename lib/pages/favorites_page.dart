import 'package:cryptomoeda/models/moeda.dart';
import 'package:cryptomoeda/provider/favorites_respository.dart';
import 'package:cryptomoeda/widgets/moeda_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moedas Favoritas'),
      ),
      body: Container(
        child:
            Consumer<FavoritasRepository>(builder: (context, favoritas, child) {
          return favoritas.lista.isEmpty
              ? ListTile(
                  title: Text(
                    'Ainda não há moeda como favorita',
                  ),
                  leading: Icon(Icons.star),
                )
              : ListView.builder(
                  itemCount: favoritas.lista.length,
                  itemBuilder: (context, i) {
                    return MoedaCard(moeda: favoritas.lista[i]);
                  },
                );
        }),
      ),
    );
  }
}
