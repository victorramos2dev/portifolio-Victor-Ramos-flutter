import 'package:flutter/material.dart';

import '../data/portfolio_data.dart' as data;
import '../models/portfolio_models.dart';
import '../state/likes_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/glow_card.dart';
import '../widgets/project_card.dart';
import '../widgets/quote_carousel.dart';
import '../widgets/scenery_page.dart';
import '../widgets/section_title.dart';

/// Como a lista de projetos aparece na tela.
enum ProjectSort { recentes, curtidos, alfabetica }

extension on ProjectSort {
  String get label => switch (this) {
        ProjectSort.recentes => 'Recentes',
        ProjectSort.curtidos => 'Curtidos',
        ProjectSort.alfabetica => 'A-Z',
      };
}

/// Tela 2 — Dinamica: carrossel de frases + catalogo de projetos curtiveis.
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String? _activeTag;
  bool _onlyLiked = false;
  ProjectSort _sort = ProjectSort.recentes;

  /// Todas as tags que aparecem em algum projeto, sem repetir.
  List<String> get _allTags {
    final tags = <String>{};
    for (final project in data.projects) {
      tags.addAll(project.tags);
    }
    return tags.toList()..sort();
  }

  List<Project> _visibleProjects(LikesController likes) {
    final list = data.projects.where((project) {
      final matchesTag = _activeTag == null || project.tags.contains(_activeTag);
      final matchesLiked = !_onlyLiked || likes.isLiked(project.id);
      return matchesTag && matchesLiked;
    }).toList();

    int likesOf(Project p) => p.baseLikes + (likes.isLiked(p.id) ? 1 : 0);

    switch (_sort) {
      case ProjectSort.recentes:
        list.sort((a, b) => b.year.compareTo(a.year));
      case ProjectSort.curtidos:
        list.sort((a, b) => likesOf(b).compareTo(likesOf(a)));
      case ProjectSort.alfabetica:
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final likes = LikesScope.of(context);
    final visible = _visibleProjects(likes);

    return SceneryPage(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
      children: [
        // ---------- Frases ----------
        const SectionTitle(
          overline: 'O que me move',
          title: 'Frases',
          icon: Icons.format_quote,
        ),
        const SizedBox(height: 22),
        QuoteCarousel(quotes: data.quotes),
        const SizedBox(height: 48),

        // ---------- Catalogo ----------
        const SectionTitle(
          overline: 'O que ja construi',
          title: 'Projetos',
          icon: Icons.folder_special_outlined,
        ),
        const SizedBox(height: 20),
        _LikesBar(
          liked: likes.total,
          onlyLiked: _onlyLiked,
          onToggleFilter: () => setState(() => _onlyLiked = !_onlyLiked),
          onClear: likes.total == 0 ? null : likes.clear,
        ),
        const SizedBox(height: 16),

        // Filtro por tecnologia.
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Pressable(
                  onTap: () => setState(() => _activeTag = null),
                  child: Sigil(label: 'Todos', selected: _activeTag == null),
                ),
              ),
              for (final tag in _allTags)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Pressable(
                    onTap: () => setState(
                      () => _activeTag = _activeTag == tag ? null : tag,
                    ),
                    child: Sigil(label: tag, selected: _activeTag == tag),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Ordenacao.
        Row(
          children: [
            Text('ORDENAR', style: AppType.overline(size: 9)),
            const SizedBox(width: 12),
            for (final sort in ProjectSort.values)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Pressable(
                  onTap: () => setState(() => _sort = sort),
                  child: Sigil(
                    label: sort.label,
                    color: AppColors.ember,
                    selected: _sort == sort,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),

        if (visible.isEmpty)
          _EmptyState(onlyLiked: _onlyLiked)
        else
          for (final project in visible) ...[
            ProjectCard(key: ValueKey(project.id), project: project),
            const SizedBox(height: 18),
          ],
      ],
    );
  }
}

/// Faixa com o total de curtidas e os atalhos de filtrar / limpar.
class _LikesBar extends StatelessWidget {
  const _LikesBar({
    required this.liked,
    required this.onlyLiked,
    required this.onToggleFilter,
    required this.onClear,
  });

  final int liked;
  final bool onlyLiked;
  final VoidCallback onToggleFilter;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final hasLikes = liked > 0;

    return GlowCard(
      padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
      accent: AppColors.infection,
      active: hasLikes,
      borderRadius: 16,
      child: Row(
        children: [
          Icon(
            hasLikes ? Icons.local_fire_department : Icons.local_fire_department_outlined,
            size: 17,
            color: hasLikes ? AppColors.infection : AppColors.ash,
            shadows: hasLikes
                ? AppGlow.text(AppColors.infection, blur: 14, opacity: 0.6)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasLikes
                  ? '$liked projeto${liked > 1 ? 's' : ''} curtido${liked > 1 ? 's' : ''}'
                  : 'Nenhum projeto curtido ainda',
              style: AppType.body(
                size: 12,
                weight: FontWeight.w600,
                color: hasLikes ? AppColors.bone : AppColors.ash,
              ),
            ),
          ),
          Pressable(
            onTap: onToggleFilter,
            child: Sigil(
              label: onlyLiked ? 'Ver todos' : 'So curtidos',
              color: AppColors.infection,
              selected: onlyLiked,
            ),
          ),
          if (onClear != null)
            IconButton(
              onPressed: onClear,
              tooltip: 'Limpar curtidas',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.backspace_outlined, size: 15, color: AppColors.ash),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onlyLiked});

  final bool onlyLiked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            onlyLiked ? Icons.local_fire_department_outlined : Icons.search_off,
            size: 34,
            color: AppColors.ash.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(
            onlyLiked
                ? 'Nenhum projeto curtido nesse filtro.'
                : 'Nenhum projeto com essa tecnologia.',
            textAlign: TextAlign.center,
            style: AppType.body(size: 12.5, color: AppColors.ash),
          ),
        ],
      ),
    );
  }
}
