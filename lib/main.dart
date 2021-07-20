import 'package:cryptomoeda/provider/conta_respository.dart';
import 'package:cryptomoeda/provider/favorites_respository.dart';
import 'package:cryptomoeda/settings/app_prefrerences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configs/hive_configs.dart';
import 'core/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContaRespository()),
        ChangeNotifierProvider(create: (context) => AppPrefrerences()),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
      ],
      child: App(),
    ),
  );
}
