import 'package:flutter/material.dart';

/// Paleta do app — atmosfera subterranea: fundo frio e escuro, texto claro,
/// acento luminescente para foco e laranja/dourado para acao.
class AppColors {
  const AppColors._();

  /// Vastidao subterranea — o fundo mais profundo da cena.
  static const void_ = Color(0xFF0B0C10);

  /// Camada intermediaria do cenario e fundo dos cards.
  static const abyss = Color(0xFF141824);

  /// Superficie elevada (cards sobre cards, chips selecionados).
  static const crypt = Color(0xFF1B2030);

  /// Texto principal — branco gelo.
  static const bone = Color(0xFFF8F9FA);

  /// Texto secundario — cinza frio.
  static const ash = Color(0xFF98A2B8);

  /// Energia "soul": foco, hover e brilho suave.
  static const soul = Color(0xFFE0F2FE);

  /// "Infeccao": chamada para acao, curtidas, urgencia.
  static const infection = Color(0xFFF97316);

  /// Dourado vibrante — destaques e valores.
  static const ember = Color(0xFFFFB800);

  /// Borda sutil dos containers.
  static const rim = Color(0x1FE0F2FE);
}

/// Curvas e duracoes. Nada de movimento linear: tudo desacelera de forma
/// organica, como animacao desenhada quadro a quadro.
class AppMotion {
  const AppMotion._();

  /// Equivalente a cubic-bezier(0.25, 1, 0.5, 1).
  static const organic = Cubic(0.25, 1, 0.5, 1);

  /// Saida com leve elasticidade, para toques e curtidas.
  static const springy = Cubic(0.34, 1.56, 0.64, 1);

  static const fast = Duration(milliseconds: 220);
  static const medium = Duration(milliseconds: 420);
  static const slow = Duration(milliseconds: 800);
}

/// Brilhos difusos usados no lugar de sombras duras.
class AppGlow {
  const AppGlow._();

  /// Halo frio ao redor de um container em repouso.
  static List<BoxShadow> ambient({double opacity = 0.05, double blur = 28}) => [
        BoxShadow(
          color: AppColors.soul.withValues(alpha: opacity),
          blurRadius: blur,
          spreadRadius: -6,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.55),
          blurRadius: blur * 0.8,
          offset: const Offset(0, 10),
        ),
      ];

  /// Halo colorido para o estado ativo/focado.
  static List<BoxShadow> focus(Color color, {double opacity = 0.30}) => [
        BoxShadow(
          color: color.withValues(alpha: opacity),
          blurRadius: 26,
          spreadRadius: -2,
        ),
      ];

  /// Brilho aplicado a textos luminescentes.
  static List<Shadow> text(Color color, {double blur = 14, double opacity = 0.55}) => [
        Shadow(color: color.withValues(alpha: opacity), blurRadius: blur),
      ];
}

/// Tipografia: Cinzel (serifada, gotica) nos titulos, Inter no corpo.
/// Ambas sao fontes variaveis, entao o peso vai tambem em [FontVariation].
class AppType {
  const AppType._();

  static TextStyle display({
    double size = 34,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.bone,
    double letterSpacing = 1.4,
    double height = 1.15,
    List<Shadow>? shadows,
  }) =>
      TextStyle(
        fontFamily: 'Cinzel',
        fontSize: size,
        color: color,
        fontWeight: weight,
        fontVariations: [FontVariation('wght', weight.value.toDouble())],
        letterSpacing: letterSpacing,
        height: height,
        shadows: shadows,
      );

  static TextStyle body({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.bone,
    double letterSpacing = 0.1,
    double height = 1.6,
    FontStyle? fontStyle,
  }) =>
      TextStyle(
        fontFamily: 'Inter',
        fontSize: size,
        color: color,
        fontWeight: weight,
        fontVariations: [FontVariation('wght', weight.value.toDouble())],
        letterSpacing: letterSpacing,
        height: height,
        fontStyle: fontStyle,
      );

  /// Rotulo pequeno em caixa alta, muito espacado — usado em selos e secoes.
  static TextStyle overline({
    double size = 10,
    Color color = AppColors.ash,
    FontWeight weight = FontWeight.w600,
  }) =>
      body(
        size: size,
        weight: weight,
        color: color,
        letterSpacing: 2.2,
        height: 1.2,
      );
}

class AppTheme {
  const AppTheme._();

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: AppColors.soul,
      onPrimary: AppColors.void_,
      secondary: AppColors.infection,
      onSecondary: AppColors.void_,
      tertiary: AppColors.ember,
      onTertiary: AppColors.void_,
      surface: AppColors.abyss,
      onSurface: AppColors.bone,
      onSurfaceVariant: AppColors.ash,
      outline: AppColors.rim,
      outlineVariant: AppColors.rim,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      // O fundo real vem do cenario com parallax; o Scaffold fica transparente.
      scaffoldBackgroundColor: AppColors.void_,
      splashFactory: InkSparkle.splashFactory,
      textTheme: TextTheme(
        displayLarge: AppType.display(size: 40),
        displayMedium: AppType.display(size: 34),
        headlineLarge: AppType.display(size: 28),
        headlineMedium: AppType.display(size: 24),
        headlineSmall: AppType.display(size: 21),
        titleLarge: AppType.display(size: 18, letterSpacing: 1.1),
        titleMedium: AppType.display(size: 16, letterSpacing: 0.9),
        titleSmall: AppType.body(size: 14, weight: FontWeight.w600),
        bodyLarge: AppType.body(size: 15),
        bodyMedium: AppType.body(size: 14),
        bodySmall: AppType.body(size: 13, color: AppColors.ash),
        labelLarge: AppType.body(size: 13, weight: FontWeight.w600),
        labelMedium: AppType.body(size: 12, weight: FontWeight.w500),
        labelSmall: AppType.overline(),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.rim,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.soul, size: 20),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.crypt,
        contentTextStyle: AppType.body(size: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.rim),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.soul,
          textStyle: AppType.body(size: 12, weight: FontWeight.w600, letterSpacing: 0.6),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.crypt,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.rim),
        ),
        textStyle: AppType.body(size: 11, color: AppColors.bone),
      ),
    );
  }
}
