import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import 'glow_card.dart';

/// Grupo de tecnologias que se abre ao toque, revelando cada ferramenta com
/// sua barra de proficiencia.
class TechGroupCard extends StatefulWidget {
  const TechGroupCard({
    super.key,
    required this.group,
    this.initiallyExpanded = false,
  });

  final TechGroup group;
  final bool initiallyExpanded;

  @override
  State<TechGroupCard> createState() => _TechGroupCardState();
}

class _TechGroupCardState extends State<TechGroupCard> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final group = widget.group;

    return Pressable(
      onTap: () => setState(() => _expanded = !_expanded),
      child: GlowCard(
        active: _expanded,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.soul.withValues(alpha: _expanded ? 0.12 : 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.rim),
                  ),
                  child: Icon(group.icon, size: 18, color: AppColors.soul),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: AppType.display(size: 16, letterSpacing: 0.9),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${group.techs.length} tecnologias',
                        style: AppType.overline(size: 9),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: AppMotion.medium,
                  curve: AppMotion.organic,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColors.ash,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _Meter(value: group.level, thick: true),
            AnimatedSize(
              duration: AppMotion.medium,
              curve: AppMotion.organic,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          for (final tech in group.techs) _TechRow(tech: tech),
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechRow extends StatelessWidget {
  const _TechRow({required this.tech});

  final Tech tech;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  tech.name,
                  style: AppType.body(size: 13, weight: FontWeight.w600),
                ),
              ),
              Text(tech.levelLabel.toUpperCase(), style: AppType.overline(size: 9)),
            ],
          ),
          if (tech.note.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(tech.note, style: AppType.body(size: 11.5, color: AppColors.ash, height: 1.4)),
          ],
          const SizedBox(height: 8),
          _Meter(value: tech.level),
        ],
      ),
    );
  }
}

/// Barra de proficiencia: um fio escuro que se enche de luz.
class _Meter extends StatelessWidget {
  const _Meter({required this.value, this.thick = false});

  final double value;
  final bool thick;

  @override
  Widget build(BuildContext context) {
    final height = thick ? 5.0 : 3.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: AppMotion.slow,
      curve: AppMotion.organic,
      builder: (context, animated, _) => Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(height),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: animated,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height),
              gradient: LinearGradient(
                colors: [
                  AppColors.soul.withValues(alpha: 0.35),
                  AppColors.soul,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.soul.withValues(alpha: 0.45),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
