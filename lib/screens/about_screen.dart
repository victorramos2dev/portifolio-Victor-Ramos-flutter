import 'package:flutter/material.dart';

import '../data/portfolio_data.dart' as data;
import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import '../widgets/curiosity_cards.dart';
import '../widgets/profile_header.dart';
import '../widgets/scenery_page.dart';
import '../widgets/section_title.dart';
import '../widgets/tech_group_card.dart';
import '../widgets/timeline_tile.dart';

/// Tela 1 — Apresentacao: retrato e informacoes, tecnologias, trajetoria e
/// curiosidades.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final others = data.curiosities.where((c) => !c.highlight).toList();
    final highlights = data.curiosities.where((c) => c.highlight).toList();
    final Curiosity? highlight = highlights.isEmpty ? null : highlights.first;

    return SceneryPage(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
      children: [
        ProfileHeader(profile: data.profile),
        const SizedBox(height: 44),

        // ---------- Sobre ----------
        const SectionTitle(
          overline: 'Quem esta do outro lado',
          title: 'Sobre mim',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 20),
        Text(data.profile.bio, style: AppType.body(size: 13.5, height: 1.8)),
        const SizedBox(height: 48),

        // ---------- Tecnologias ----------
        const SectionTitle(
          overline: 'Arsenal',
          title: 'Tecnologias',
          icon: Icons.code,
        ),
        const SizedBox(height: 12),
        Text(
          'Toque em um grupo para abrir as ferramentas.',
          style: AppType.body(size: 12, color: AppColors.ash),
        ),
        const SizedBox(height: 18),
        for (var i = 0; i < data.techGroups.length; i++) ...[
          TechGroupCard(
            group: data.techGroups[i],
            initiallyExpanded: i == 0,
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 36),

        // ---------- Trajetoria ----------
        const SectionTitle(
          overline: 'O caminho ate aqui',
          title: 'Trajetoria',
          icon: Icons.timeline,
        ),
        const SizedBox(height: 22),
        for (var i = 0; i < data.timeline.length; i++)
          TrailTile(
            entry: data.timeline[i],
            isLast: i == data.timeline.length - 1,
          ),
        const SizedBox(height: 44),

        // ---------- Certificacoes ----------
        const SectionTitle(
          overline: 'Estudo continuo',
          title: 'Cursos',
          icon: Icons.verified_outlined,
        ),
        const SizedBox(height: 22),
        for (var i = 0; i < data.certifications.length; i++)
          TrailTile(
            entry: data.certifications[i],
            isLast: i == data.certifications.length - 1,
            compact: true,
          ),
        const SizedBox(height: 44),

        // ---------- Curiosidades ----------
        const SectionTitle(
          overline: 'Longe do editor de codigo',
          title: 'Curiosidades',
          icon: Icons.auto_awesome,
        ),
        const SizedBox(height: 22),
        if (highlight != null) ...[
          HighlightCuriosityCard(
            curiosity: highlight,
            attributes: data.attributes,
          ),
          const SizedBox(height: 14),
        ],
        for (final curiosity in others) ...[
          CuriosityTile(curiosity: curiosity),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 32),
        Center(
          child: Text(
            'Siga para os projetos',
            style: AppType.overline(size: 9),
          ),
        ),
        const SizedBox(height: 10),
        const Center(
          child: Icon(Icons.keyboard_double_arrow_right, size: 18, color: AppColors.ash),
        ),
      ],
    );
  }
}
