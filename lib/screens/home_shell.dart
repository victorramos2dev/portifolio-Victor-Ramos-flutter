import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/glow_card.dart';
import 'about_screen.dart';
import 'projects_screen.dart';

/// Casca do app. A barra do topo e a de baixo flutuam sobre o cenario com
/// desfoque, como se a camera focasse o conteudo e deixasse o fundo fora de
/// foco.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _sections = [
    (overline: 'Capitulo I', title: 'Apresentacao'),
    (overline: 'Capitulo II', title: 'Projetos'),
  ];

  @override
  Widget build(BuildContext context) {
    final section = _sections[_index];

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _FrostedBar(
          border: const Border(bottom: BorderSide(color: AppColors.rim)),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(section.overline.toUpperCase(), style: AppType.overline(size: 8.5)),
                        const SizedBox(height: 3),
                        // A troca de titulo desliza junto com a aba.
                        AnimatedSwitcher(
                          duration: AppMotion.medium,
                          switchInCurve: AppMotion.organic,
                          switchOutCurve: AppMotion.organic,
                          transitionBuilder: (child, animation) => FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween(
                                begin: const Offset(0, 0.4),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          ),
                          child: Text(
                            section.title,
                            key: ValueKey(section.title),
                            style: AppType.display(size: 17, letterSpacing: 1.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.change_history,
                    size: 16,
                    color: AppColors.soul.withValues(alpha: 0.5),
                    shadows: AppGlow.text(AppColors.soul, blur: 14, opacity: 0.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // IndexedStack preserva a rolagem e o estado de cada tela ao alternar.
      body: IndexedStack(
        index: _index,
        children: const [AboutScreen(), ProjectsScreen()],
      ),
      bottomNavigationBar: _BottomRunes(
        index: _index,
        onChanged: (value) => setState(() => _index = value),
      ),
    );
  }
}

/// Barra translucida com desfoque do cenario atras.
class _FrostedBar extends StatelessWidget {
  const _FrostedBar({required this.child, this.border});

  final Widget child;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.void_.withValues(alpha: 0.55),
            border: border,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Navegacao inferior: dois "runes" que acendem quando ativos.
class _BottomRunes extends StatelessWidget {
  const _BottomRunes({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FrostedBar(
      border: const Border(top: BorderSide(color: AppColors.rim)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: _Rune(
                  icon: Icons.person_outline,
                  label: 'Sobre mim',
                  active: index == 0,
                  onTap: () => onChanged(0),
                ),
              ),
              Expanded(
                child: _Rune(
                  icon: Icons.grid_view_outlined,
                  label: 'Projetos',
                  active: index == 1,
                  onTap: () => onChanged(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Rune extends StatelessWidget {
  const _Rune({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.soul : AppColors.ash;

    return Pressable(
      onTap: onTap,
      pressedScale: 0.93,
      child: AnimatedContainer(
        duration: AppMotion.medium,
        curve: AppMotion.organic,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: active ? AppColors.soul.withValues(alpha: 0.06) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 19,
              color: color,
              shadows: active ? AppGlow.text(AppColors.soul, blur: 16, opacity: 0.6) : null,
            ),
            const SizedBox(height: 7),
            Text(label.toUpperCase(), style: AppType.overline(size: 8.5, color: color)),
            const SizedBox(height: 7),
            // Fio que acende sob a aba ativa.
            AnimatedContainer(
              duration: AppMotion.medium,
              curve: AppMotion.organic,
              height: 2,
              width: active ? 28 : 0,
              decoration: BoxDecoration(
                color: AppColors.soul,
                borderRadius: BorderRadius.circular(2),
                boxShadow: active ? AppGlow.focus(AppColors.soul, opacity: 0.6) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
