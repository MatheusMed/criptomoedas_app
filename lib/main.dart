import 'package:cryptomoeda/provider/favorites_respository.dart';
import 'package:cryptomoeda/settings/app_prefrerences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_widget.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppPrefrerences()),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
      ],
      child: App(),
    ),
  );
}
