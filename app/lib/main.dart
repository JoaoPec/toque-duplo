import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'game/game_state.dart';
import 'theme.dart';
import 'ui/root.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Jogo de celular: retrato apenas.
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const ToqueDuploApp());
}

class ToqueDuploApp extends StatelessWidget {
  const ToqueDuploApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: 'Toque Duplo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(),
        home: const RootScreen(),
      ),
    );
  }
}
