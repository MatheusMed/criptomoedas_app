import 'dart:collection';
import 'package:cryptomoeda/adpters/moeda_hiver_adapter.dart';
import 'package:cryptomoeda/models/moeda.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritasRepository extends ChangeNotifier {
  List<Moeda> _lista = [];

  late LazyBox box;

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  FavoritasRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await _readFavoritas();
  }

  _openBox() async {
    Hive.registerAdapter(MoedaHiverAdapter());

    box = await Hive.openLazyBox<Moeda>('moedas_favoritas');
  }

  _readFavoritas() {
    box.keys.forEach((moeda) async {
      Moeda m = await box.get(moeda);
      _lista.add(m);
    });
    notifyListeners();
  }

  saveAll(List<Moeda> moedas) {
    moedas.forEach((moeda) {
      if (!_lista.any((atual) => atual.sigla == moeda.sigla)) {
        _lista.add(moeda);
        box.put(moeda.sigla, moeda);
      }
    });
    notifyListeners();
  }

  remove(Moeda moeda) {
    _lista.remove(moeda);
    box.delete(moeda.sigla);
    notifyListeners();
  }
}
