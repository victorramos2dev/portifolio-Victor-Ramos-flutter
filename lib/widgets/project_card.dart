import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';
import '../state/likes_controller.dart';
import '../theme/app_theme.dart';
import 'glow_card.dart';

/// Card de um projeto: capa em fundo preto, contexto, pontos principais,
/// tecnologias e o botao de curtir.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final likes = LikesScope.of(context);
    final liked = likes.isLiked(project.id);

    return GlowCard(
      accent: AppColors.infection,
      active: liked,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            child: _Cover(project: project),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: AppType.display(size: 20, letterSpacing: 1.2),
                      ),
                    ),
                    Text(project.year, style: AppType.overline(size: 10)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  project.subtitle,
                  style: AppType.body(
                    size: 12.5,
                    color: AppColors.soul.withValues(alpha: 0.62),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  project.description,
                  style: AppType.body(size: 13, color: AppColors.ash, height: 1.7),
                ),
                if (project.highlights.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  for (final line in project.highlights) _Bullet(text: line),
                ],
                const SizedBox(height: 18),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [for (final tag in project.tags) Sigil(label: tag)],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    LikeButton(
                      liked: liked,
                      likeCount: project.baseLikes + (liked ? 1 : 0),
                      onPressed: () => likes.toggle(project.id),
                    ),
                    const Spacer(),
                    if (project.link != null)
                      TextButton.icon(
                        onPressed: () => _showLink(context, project.link!),
                        icon: const Icon(Icons.north_east, size: 14),
                        label: const Text('VER PROJETO'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLink(BuildContext context, String link) {
    // Sem dependencia externa: mostra o endereco para o usuario copiar.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(link)));
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.project});

  final Project project;

  /// Proporcao das capas em assets/images/projects/ (800x360). A area da capa
  /// acompanha essa medida, entao a arte aparece inteira, sem corte.
  static const coverAspect = 800 / 360;

  /// Altura da capa quando o projeto nao tem imagem — so o gradiente e o icone.
  static const plainHeight = 104.0;

  @override
  Widget build(BuildContext context) {
    final cover = project.cover;

    final content = Stack(
      fit: StackFit.expand,
      children: [
        _BlackCover(project: project, showIcon: cover == null),

        // Imagem em assets/images/projects/ quando existir.
        if (cover != null)
          Image.asset(
            cover,
            fit: BoxFit.contain,
            // Sem o arquivo, sobra o gradiente desenhado atras.
            errorBuilder: (context, error, stack) => const SizedBox.shrink(),
          ),

        // Escurece a base para separar a capa do titulo do card.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00000000), Color(0x99000000)],
              stops: [0.55, 1.0],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(14),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Sigil(label: project.context, color: AppColors.bone, selected: true),
          ),
        ),
      ],
    );

    return cover == null
        ? SizedBox(height: plainHeight, width: double.infinity, child: content)
        : AspectRatio(aspectRatio: coverAspect, child: content);
  }
}

/// Fundo da capa: preto puro, para que logos com transparencia apareçam
/// limpos. A cor do projeto sobrou apenas no icone de reserva, bem apagado.
class _BlackCover extends StatelessWidget {
  const _BlackCover({required this.project, this.showIcon = true});

  final Project project;

  /// O icone gigante do fundo so aparece quando nao ha logo na capa.
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.black),
      child: showIcon
          ? Opacity(
              opacity: 0.22,
              child: Align(
                alignment: const Alignment(1.15, 0.9),
                child: Icon(project.icon, size: 130, color: project.gradient.first),
              ),
            )
          : null,
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.soul.withValues(alpha: 0.7),
              boxShadow: AppGlow.focus(AppColors.soul, opacity: 0.35),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppType.body(size: 12.5, color: AppColors.ash, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Botao de curtir: em repouso e um contorno frio; ao ser ativado, acende em
/// laranja "infeccao" e pulsa uma vez.
class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.liked,
    required this.likeCount,
    required this.onPressed,
  });

  final bool liked;
  final int likeCount;
  final VoidCallback onPressed;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.medium,
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.45), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 1.45, end: 1.0), weight: 1.6),
  ]).animate(CurvedAnimation(parent: _controller, curve: AppMotion.springy));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.liked) _controller.forward(from: 0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.liked ? AppColors.infection : AppColors.ash;

    return Semantics(
      button: true,
      label: widget.liked ? 'Descurtir projeto' : 'Curtir projeto',
      child: Pressable(
        onTap: _handleTap,
        pressedScale: 0.94,
        child: AnimatedContainer(
          duration: AppMotion.medium,
          curve: AppMotion.organic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.liked
                ? AppColors.infection.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.liked
                  ? AppColors.infection.withValues(alpha: 0.6)
                  : AppColors.rim,
            ),
            boxShadow: widget.liked
                ? AppGlow.focus(AppColors.infection, opacity: 0.35)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scale,
                child: Icon(
                  widget.liked ? Icons.local_fire_department : Icons.local_fire_department_outlined,
                  size: 17,
                  color: color,
                  shadows: widget.liked
                      ? AppGlow.text(AppColors.infection, blur: 14, opacity: 0.7)
                      : null,
                ),
              ),
              const SizedBox(width: 9),
              AnimatedSwitcher(
                duration: AppMotion.fast,
                switchInCurve: AppMotion.organic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    axis: Axis.horizontal,
                    sizeFactor: animation,
                    child: child,
                  ),
                ),
                child: Text(
                  '${widget.likeCount}',
                  key: ValueKey(widget.likeCount),
                  style: AppType.body(size: 12.5, weight: FontWeight.w700, color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
