import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';
import '../theme/app_theme.dart';
import 'glow_card.dart';

/// Carrossel de frases que troca sozinho a cada [interval], aceita arraste e
/// tem um botao de sorteio. A transicao usa curva organica: os cards vizinhos
/// encolhem e escurecem, como se estivessem mais fundo na caverna.
class QuoteCarousel extends StatefulWidget {
  const QuoteCarousel({
    super.key,
    required this.quotes,
    this.interval = const Duration(seconds: 7),
  });

  final List<Quote> quotes;
  final Duration interval;

  @override
  State<QuoteCarousel> createState() => _QuoteCarouselState();
}

class _QuoteCarouselState extends State<QuoteCarousel> {
  late final PageController _controller;
  final _random = Random();
  Timer? _timer;
  int _index = 0;

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

  void _shuffle() {
    if (widget.quotes.length < 2) return;
    var next = _random.nextInt(widget.quotes.length);
    if (next == _index) next = (next + 1) % widget.quotes.length;
    _goTo(next);
    _startTimer(); // reinicia a contagem apos interacao do usuario
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

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: NotificationListener<ScrollNotification>(
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
            const SizedBox(width: 14),
            Pressable(
              onTap: _shuffle,
              pressedScale: 0.88,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.rim),
                  color: Colors.white.withValues(alpha: 0.03),
                ),
                child: const Icon(Icons.shuffle, size: 15, color: AppColors.ash),
              ),
            ),
          ],
        ),
      ],
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
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '“',
                style: AppType.display(
                  size: 40,
                  height: 0.9,
                  color: AppColors.soul.withValues(alpha: 0.55),
                  shadows: AppGlow.text(AppColors.soul, blur: 18, opacity: 0.35),
                ),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  quote.text,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.body(size: 14.5, height: 1.65, weight: FontWeight.w500),
                ),
              ),
              if (quote.author.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text('— ${quote.author}'.toUpperCase(), style: AppType.overline(size: 9)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
