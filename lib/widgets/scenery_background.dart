import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';

import '../data/portfolio_data.dart' as data;
import '../theme/app_theme.dart';

/// Cenario de fundo com profundidade: tres camadas que rolam em velocidades
/// diferentes, poeira flutuante e vinheta.
///
/// Cada camada usa a imagem indicada em [data.scenery] quando existe; se o
/// caminho for null (padrao), o cenario e desenhado por codigo.
class SceneryBackground extends StatefulWidget {
  const SceneryBackground({
    super.key,
    required this.scrollOffset,
    required this.child,
  });

  /// Deslocamento vertical da rolagem, em pixels.
  final ValueListenable<double> scrollOffset;

  final Widget child;

  @override
  State<SceneryBackground> createState() => _SceneryBackgroundState();
}

class _SceneryBackgroundState extends State<SceneryBackground>
    with SingleTickerProviderStateMixin {
  /// Ciclo lento e continuo que move a poeira, independente da rolagem.
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 40),
  )..repeat();

  @override
  void dispose() {
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Camada 0 — o vazio: gradiente frio que nunca se move.
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.45),
                radius: 1.25,
                colors: [AppColors.abyss, AppColors.void_],
                stops: [0.0, 0.95],
              ),
            ),
          ),
        ),

        // Camadas 1 a 3 — parallax preso a rolagem.
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: Listenable.merge([widget.scrollOffset, _drift]),
              builder: (context, _) {
                final offset = widget.scrollOffset.value;
                return Stack(
                  children: [
                    _Layer(
                      offset: offset,
                      speed: 0.06,
                      image: data.scenery.far,
                      painter: _FarRidgePainter(),
                    ),
                    _Layer(
                      offset: offset,
                      speed: 0.14,
                      image: data.scenery.mid,
                      painter: _MistPainter(progress: _drift.value),
                    ),
                    _Layer(
                      offset: offset,
                      speed: 0.26,
                      image: data.scenery.near,
                      painter: _NearPillarPainter(),
                    ),
                    // Poeira: mistura rolagem e tempo.
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _DustPainter(
                          progress: _drift.value,
                          scrollOffset: offset,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Camada 4 — vinheta: fecha as bordas e isola o conteudo.
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [Color(0x00000000), Color(0x99000000)],
                  stops: [0.55, 1.0],
                ),
              ),
            ),
          ),
        ),

        Positioned.fill(child: widget.child),
      ],
    );
  }
}

/// Uma camada do parallax: usa a imagem se houver, senao o painter.
class _Layer extends StatelessWidget {
  const _Layer({
    required this.offset,
    required this.speed,
    required this.image,
    required this.painter,
  });

  final double offset;

  /// Fracao da rolagem aplicada a camada. Quanto maior, mais "perto".
  final double speed;

  final String? image;
  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Transform.translate(
        offset: Offset(0, -offset * speed),
        child: IgnorePointer(
          child: image == null
              ? CustomPaint(painter: painter)
              : Image.asset(
                  image!,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  // Se o arquivo nao existir, volta para o cenario desenhado.
                  errorBuilder: (context, error, stack) =>
                      CustomPaint(painter: painter),
                ),
        ),
      ),
    );
  }
}

/// Silhuetas distantes — cristas irregulares no rodape da tela.
class _FarRidgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF10141F);
    final random = math.Random(7);
    final baseline = size.height * 0.72;

    final path = Path()..moveTo(0, size.height);
    path.lineTo(0, baseline);
    for (var x = 0.0; x <= size.width; x += size.width / 9) {
      final peak = baseline - random.nextDouble() * size.height * 0.16;
      path.lineTo(x + size.width / 18, peak);
      path.lineTo(x + size.width / 9, baseline - random.nextDouble() * 20);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FarRidgePainter oldDelegate) => false;
}

/// Nevoa: manchas difusas que respiram devagar.
class _MistPainter extends CustomPainter {
  _MistPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const ui.MaskFilter.blur(BlurStyle.normal, 60);
    final random = math.Random(23);

    for (var i = 0; i < 5; i++) {
      final phase = (progress + i / 5) % 1.0;
      final dx = size.width * (0.15 + random.nextDouble() * 0.7);
      final dy = size.height * (0.2 + random.nextDouble() * 0.7) +
          math.sin(phase * 2 * math.pi) * 18;
      final radius = size.width * (0.16 + random.nextDouble() * 0.14);

      paint.color = AppColors.soul.withValues(
        alpha: 0.012 + 0.010 * math.sin(phase * 2 * math.pi).abs(),
      );
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MistPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Primeiro plano: pilares escuros colados nas laterais, como no cenario de
/// uma caverna vista de dentro.
class _NearPillarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF070810);
    final w = size.width;
    final h = size.height;

    // Pilar esquerdo.
    final left = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.085, 0)
      ..quadraticBezierTo(w * 0.045, h * 0.30, w * 0.075, h * 0.55)
      ..quadraticBezierTo(w * 0.10, h * 0.80, w * 0.045, h)
      ..lineTo(0, h)
      ..close();

    // Pilar direito.
    final right = Path()
      ..moveTo(w, 0)
      ..lineTo(w * 0.90, 0)
      ..quadraticBezierTo(w * 0.955, h * 0.26, w * 0.915, h * 0.52)
      ..quadraticBezierTo(w * 0.88, h * 0.78, w * 0.95, h)
      ..lineTo(w, h)
      ..close();

    canvas.drawPath(left, paint);
    canvas.drawPath(right, paint);
  }

  @override
  bool shouldRepaint(covariant _NearPillarPainter oldDelegate) => false;
}

/// Poeira luminescente flutuando na frente do cenario.
class _DustPainter extends CustomPainter {
  _DustPainter({required this.progress, required this.scrollOffset});

  final double progress;
  final double scrollOffset;

  static const _count = 42;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(11);
    final paint = Paint()
      ..maskFilter = const ui.MaskFilter.blur(BlurStyle.normal, 2.5);

    for (var i = 0; i < _count; i++) {
      final seedX = random.nextDouble();
      final seedY = random.nextDouble();
      final speed = 0.4 + random.nextDouble() * 0.8;
      final radius = 0.7 + random.nextDouble() * 1.8;

      // Sobe devagar e volta ao rodape ao chegar no topo.
      final rise = (seedY - progress * speed) % 1.0;
      final sway = math.sin((progress * speed + seedX) * 2 * math.pi) * 12;

      final dx = seedX * size.width + sway;
      final dy = rise * size.height - scrollOffset * 0.35 % size.height;

      paint.color = AppColors.soul.withValues(
        alpha: 0.10 + 0.28 * math.sin(rise * math.pi),
      );
      canvas.drawCircle(Offset(dx, dy % size.height), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DustPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.scrollOffset != scrollOffset;
}
