import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import 'glow_card.dart';

/// Card grande da curiosidade principal: uma ficha de personagem, com selo de
/// d20 girando devagar e atributos com modificador.
class HighlightCuriosityCard extends StatelessWidget {
  const HighlightCuriosityCard({
    super.key,
    required this.curiosity,
    required this.attributes,
  });

  final Curiosity curiosity;
  final List<Attribute> attributes;

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      accent: AppColors.ember,
      active: true,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _DieSigil(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ficha do jogador', style: AppType.overline(size: 9, color: AppColors.ember)),
                    const SizedBox(height: 5),
                    Text(
                      curiosity.title,
                      style: AppType.display(
                        size: 21,
                        letterSpacing: 1.2,
                        shadows: AppGlow.text(AppColors.ember, blur: 20, opacity: 0.25),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(curiosity.description, style: AppType.body(size: 13.5, height: 1.7)),
          const SizedBox(height: 22),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.ember.withValues(alpha: 0.45),
                  AppColors.ember.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final attribute in attributes) _AttributeBlock(attribute: attribute),
            ],
          ),
        ],
      ),
    );
  }
}

/// Selo hexagonal que gira lentamente, evocando um d20 em repouso.
class _DieSigil extends StatefulWidget {
  const _DieSigil();

  @override
  State<_DieSigil> createState() => _DieSigilState();
}

class _DieSigilState extends State<_DieSigil> with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _spin,
            builder: (context, _) => CustomPaint(
              size: const Size.square(52),
              painter: _HexPainter(rotation: _spin.value * 2 * math.pi),
            ),
          ),
          Icon(
            Icons.casino_outlined,
            size: 21,
            color: AppColors.ember,
            shadows: AppGlow.text(AppColors.ember, blur: 14, opacity: 0.6),
          ),
        ],
      ),
    );
  }
}

class _HexPainter extends CustomPainter {
  _HexPainter({required this.rotation});

  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 1;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.ember.withValues(alpha: 0.45);

    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = rotation + i * math.pi / 3;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      i == 0 ? path.moveTo(point.dx, point.dy) : path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HexPainter oldDelegate) =>
      oldDelegate.rotation != rotation;
}

/// Atributo com valor e modificador, como numa ficha de personagem.
class _AttributeBlock extends StatelessWidget {
  const _AttributeBlock({required this.attribute});

  final Attribute attribute;

  @override
  Widget build(BuildContext context) {
    final modifier = ((attribute.value - 10) / 2).floor();
    final sign = modifier >= 0 ? '+' : '';

    return Container(
      width: 104,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ember.withValues(alpha: 0.22)),
      ),
      child: Column(
        children: [
          Text(
            attribute.name.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppType.overline(size: 8.5),
          ),
          const SizedBox(height: 7),
          Text(
            '${attribute.value}',
            style: AppType.display(
              size: 22,
              color: AppColors.ember,
              letterSpacing: 0,
              shadows: AppGlow.text(AppColors.ember, blur: 16, opacity: 0.4),
            ),
          ),
          Text('$sign$modifier', style: AppType.overline(size: 9)),
        ],
      ),
    );
  }
}

/// Card compacto para as demais curiosidades.
class CuriosityTile extends StatelessWidget {
  const CuriosityTile({super.key, required this.curiosity});

  final Curiosity curiosity;

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            curiosity.icon,
            size: 20,
            color: AppColors.soul.withValues(alpha: 0.8),
            shadows: AppGlow.text(AppColors.soul, blur: 12, opacity: 0.35),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(curiosity.title, style: AppType.display(size: 14, letterSpacing: 0.8)),
                const SizedBox(height: 6),
                Text(
                  curiosity.description,
                  style: AppType.body(size: 12.5, color: AppColors.ash, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
