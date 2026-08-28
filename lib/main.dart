import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_shell.dart';
import 'state/likes_controller.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Barra de status transparente: o cenario sobe ate o topo da tela.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.void_,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  final _likes = LikesController();

  @override
  void dispose() {
    _likes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // O LikesScope fica acima do MaterialApp para que as curtidas valham
    // para as duas telas.
    return LikesScope(
      controller: _likes,
      child: MaterialApp(
        title: 'Victor Hugo — Portfolio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        home: const HomeShell(),
      ),
    );
  }
}
