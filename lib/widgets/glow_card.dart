import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Container escuro com borda sutil e brilho difuso, em vez de fundo solido
/// e sombra dura. O conteudo respira com padding generoso e a forma "salta"
/// do cenario.
class GlowCard extends StatelessWidget {
  const GlowCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.accent,
    this.active = false,
    this.frosted = false,
    this.borderRadius = 20,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Cor do brilho quando o card esta ativo/selecionado.
  final Color? accent;

  final bool active;

  /// Desfoca o cenario atras do card (efeito de camera). Use com moderacao —
  /// custa mais para renderizar.
  final bool frosted;

  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final glowColor = accent ?? AppColors.soul;
    final radius = BorderRadius.circular(borderRadius);

    final decorated = AnimatedContainer(
      duration: AppMotion.medium,
      curve: AppMotion.organic,
      padding: padding,
      decoration: BoxDecoration(
        color: active
            ? AppColors.crypt.withValues(alpha: 0.92)
            : AppColors.abyss.withValues(alpha: frosted ? 0.55 : 0.78),
        borderRadius: radius,
        border: Border.all(
          color: active
              ? glowColor.withValues(alpha: 0.55)
              : AppColors.rim,
          width: 1,
        ),
        boxShadow: active
            ? AppGlow.focus(glowColor)
            : AppGlow.ambient(),
      ),
      child: child,
    );

    if (!frosted) return decorated;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: decorated,
      ),
    );
  }
}

/// Envolve qualquer conteudo com uma resposta tatil suave: encolhe levemente
/// ao ser pressionado e volta com curva organica — o equivalente tatil do
/// hover luminescente.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.975,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool value) {
    if (_down == value) return;
    setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.pressedScale : 1.0,
        duration: AppMotion.fast,
        curve: AppMotion.organic,
        child: widget.child,
      ),
    );
  }
}

/// Selo pequeno em caixa alta — usado para contexto, ano e tags.
class Sigil extends StatelessWidget {
  const Sigil({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.selected = false,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? AppColors.soul;

    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.organic,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: selected
            ? tint.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: selected ? tint.withValues(alpha: 0.5) : AppColors.rim,
        ),
        boxShadow: selected ? AppGlow.focus(tint, opacity: 0.18) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: selected ? tint : AppColors.ash),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppType.overline(
              size: 10,
              color: selected ? tint : AppColors.ash,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
