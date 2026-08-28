import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Cabecalho de secao: rotulo em caixa alta, titulo serifado com leve brilho
/// e um fio luminoso que se dissolve na escuridao.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.overline,
    required this.title,
    this.icon,
  });

  final String overline;
  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: AppColors.soul.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
            ],
            Text(overline.toUpperCase(), style: AppType.overline()),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppType.display(
            size: 26,
            shadows: AppGlow.text(AppColors.soul, blur: 18, opacity: 0.22),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.soul, Color(0x00E0F2FE)],
              stops: [0.0, 0.65],
            ),
          ),
        ),
      ],
    );
  }
}
