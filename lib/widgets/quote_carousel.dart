import 'dart:async';

import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import 'glow_card.dart';

/// Carrossel de frases que troca sozinho a cada [interval], aceita arraste e
/// tem setas nas laterais para avancar e voltar. A transicao usa curva
/// organica: os cards vizinhos encolhem e escurecem, como se estivessem mais
/// fundo na caverna.
class QuoteCarousel extends StatefulWidget {
  const QuoteCarousel({
    super.key,
    required this.quotes,
    this.interval = const Duration(seconds: 9),
  });

  final List<Quote> quotes;
  final Duration interval;

  @override
  State<QuoteCarousel> createState() => _QuoteCarouselState();
}

class _QuoteCarouselState extends State<QuoteCarousel> {
  late final PageController _controller;
  Timer? _timer;
  int _index = 0;

  /// Altura fixa do palco. As frases longas (Monte Cristo, Fullmetal) sao a
  /// medida — as curtas apenas centralizam dentro do mesmo espaco.
  static const _stageHeight = 268.0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.86);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.quotes.length < 2) return;
    _timer = Timer.periodic(widget.interval, (_) => _goTo(_index + 1));
  }

  void _goTo(int page) {
    if (!mounted || !_controller.hasClients || widget.quotes.isEmpty) return;
    _controller.animateToPage(
      page % widget.quotes.length,
      duration: AppMotion.slow,
      curve: AppMotion.organic,
    );
  }

  /// Passo manual: anda uma frase e reinicia a contagem do autoplay.
  void _step(int delta) {
    if (widget.quotes.length < 2) return;
    _goTo(_index + delta);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quotes.isEmpty) return const SizedBox.shrink();

    final multiple = widget.quotes.length > 1;

    return Column(
      children: [
        SizedBox(
          height: _stageHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              NotificationListener<ScrollNotification>(
                // Ao arrastar manualmente, reinicia o tempo do autoplay.
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) _startTimer();
                  return false;
                },
                child: PageView.builder(
                  controller: _controller,
                  itemCount: widget.quotes.length,
                  onPageChanged: (page) => setState(() => _index = page),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _QuoteCard(
                      quote: widget.quotes[index],
                      active: index == _index,
                    ),
                  ),
                ),
              ),

              // Setas sobre as bordas do palco, na faixa que o card vizinho
              // deixa livre.
              if (multiple) ...[
                Positioned(
                  left: 0,
                  child: _Arrow(
                    icon: Icons.chevron_left,
                    label: 'Frase anterior',
                    onTap: () => _step(-1),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: _Arrow(
                    icon: Icons.chevron_right,
                    label: 'Proxima frase',
                    onTap: () => _step(1),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.quotes.length; i++)
              AnimatedContainer(
                duration: AppMotion.medium,
                curve: AppMotion.organic,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _index ? 20 : 5,
                height: 5,
                decoration: BoxDecoration(
                  color: i == _index
                      ? AppColors.soul
                      : AppColors.soul.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: i == _index
                      ? AppGlow.focus(AppColors.soul, opacity: 0.5)
                      : null,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Seta lateral: circulo translucido que acende de leve sobre o cenario.
class _Arrow extends StatelessWidget {
  const _Arrow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Pressable(
        onTap: onTap,
        pressedScale: 0.86,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.void_.withValues(alpha: 0.72),
            border: Border.all(color: AppColors.rim),
            boxShadow: AppGlow.focus(AppColors.soul, opacity: 0.14),
          ),
          child: Icon(icon, size: 20, color: AppColors.soul),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote, required this.active});

  final Quote quote;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: active ? 1 : 0.90,
      duration: AppMotion.medium,
      curve: AppMotion.organic,
      child: AnimatedOpacity(
        opacity: active ? 1 : 0.45,
        duration: AppMotion.medium,
        curve: AppMotion.organic,
        child: GlowCard(
          accent: AppColors.soul,
          active: active,
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '“',
                style: AppType.display(
                  size: 34,
                  height: 0.9,
                  color: AppColors.soul.withValues(alpha: 0.55),
                  shadows: AppGlow.text(AppColors.soul, blur: 18, opacity: 0.35),
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  quote.text,
                  maxLines: 9,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.body(size: 13.5, height: 1.6, weight: FontWeight.w500),
                ),
              ),
              if (quote.author.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  '— ${quote.author}'.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.overline(size: 8.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
