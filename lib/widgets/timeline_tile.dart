import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import 'glow_card.dart';

/// Item da trajetoria: um fio vertical com um no luminoso ligando as etapas.
class TrailTile extends StatelessWidget {
  const TrailTile({
    super.key,
    required this.entry,
    required this.isLast,
    this.compact = false,
  });

  final TimelineEntry entry;
  final bool isLast;

  /// Versao curta, usada em cursos e certificacoes.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Thread(isLast: isLast),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: GlowCard(
                padding: EdgeInsets.all(compact ? 16 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.period.toUpperCase(), style: AppType.overline(size: 9)),
                    const SizedBox(height: 8),
                    Text(
                      entry.title,
                      style: AppType.display(size: compact ? 14 : 16, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.subtitle,
                      style: AppType.body(
                        size: 12,
                        color: AppColors.soul.withValues(alpha: 0.65),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    if (entry.description.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        entry.description,
                        style: AppType.body(size: 12.5, color: AppColors.ash, height: 1.65),
                      ),
                    ],
                    if (entry.tags.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [for (final tag in entry.tags) Sigil(label: tag)],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fio vertical com o no da etapa.
class _Thread extends StatelessWidget {
  const _Thread({required this.isLast});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.soul,
              boxShadow: AppGlow.focus(AppColors.soul, opacity: 0.55),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: 1,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.soul.withValues(alpha: 0.35),
                      AppColors.soul.withValues(alpha: 0.04),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
