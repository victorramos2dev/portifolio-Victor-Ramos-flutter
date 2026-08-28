import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import 'glow_card.dart';

/// Abertura da tela: retrato com halo pulsante, nome serifado, funcao,
/// numeros de impacto e contatos.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Portrait(profile: profile),
        const SizedBox(height: 26),
        Text(
          profile.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppType.display(
            size: 27,
            letterSpacing: 3.0,
            height: 1.3,
            shadows: AppGlow.text(AppColors.soul, blur: 26, opacity: 0.30),
          ),
        ),
        const SizedBox(height: 12),
        Text(profile.role.toUpperCase(), style: AppType.overline(size: 11)),
        const SizedBox(height: 18),
        Text(
          profile.tagline,
          textAlign: TextAlign.center,
          style: AppType.body(
            size: 14,
            color: AppColors.soul.withValues(alpha: 0.72),
            fontStyle: FontStyle.italic,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 22),
        if (profile.highlights.isNotEmpty) ...[
          _HighlightRow(highlights: profile.highlights),
          const SizedBox(height: 22),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.place_outlined, size: 13, color: AppColors.ash),
            const SizedBox(width: 6),
            Text(profile.location, style: AppType.body(size: 12, color: AppColors.ash)),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final link in profile.links)
              Sigil(label: link.value, icon: link.icon),
          ],
        ),
      ],
    );
  }
}

/// Retrato circular com halo que pulsa devagar, como uma fonte de luz.
class _Portrait extends StatefulWidget {
  const _Portrait({required this.profile});

  final Profile profile;

  @override
  State<_Portrait> createState() => _PortraitState();
}

class _PortraitState extends State<_Portrait> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_pulse.value);
        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.soul.withValues(alpha: 0.20 + 0.22 * t),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.soul.withValues(alpha: 0.08 + 0.10 * t),
                blurRadius: 40 + 20 * t,
                spreadRadius: 2,
              ),
              const BoxShadow(color: Colors.black54, blurRadius: 30, offset: Offset(0, 14)),
            ],
          ),
          child: child,
        );
      },
      child: ClipOval(
        child: Image.asset(
          widget.profile.photoAsset,
          width: 126,
          height: 126,
          fit: BoxFit.cover,
          // Sem a foto em assets/images/profile.png, mostra as iniciais.
          errorBuilder: (context, error, stack) => _Initials(profile: widget.profile),
        ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 126,
      height: 126,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [AppColors.crypt, AppColors.void_],
        ),
      ),
      child: Text(
        profile.initials,
        style: AppType.display(
          size: 44,
          letterSpacing: 2,
          shadows: AppGlow.text(AppColors.soul, blur: 20, opacity: 0.4),
        ),
      ),
    );
  }
}

/// Numeros de impacto separados por fios verticais.
class _HighlightRow extends StatelessWidget {
  const _HighlightRow({required this.highlights});

  final List<Highlight> highlights;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < highlights.length; i++) ...[
          if (i > 0)
            Container(
              width: 1,
              height: 26,
              margin: const EdgeInsets.symmetric(horizontal: 18),
              color: AppColors.rim,
            ),
          Column(
            children: [
              Text(
                highlights[i].value,
                style: AppType.display(size: 17, letterSpacing: 0.8),
              ),
              const SizedBox(height: 4),
              Text(highlights[i].label.toUpperCase(), style: AppType.overline(size: 9)),
            ],
          ),
        ],
      ],
    );
  }
}
