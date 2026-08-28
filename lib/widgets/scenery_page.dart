import 'package:flutter/material.dart';

import 'scenery_background.dart';

/// Pagina rolavel sobre o cenario com parallax.
///
/// Mede a rolagem e entrega o deslocamento ao [SceneryBackground], que move
/// cada camada em uma velocidade diferente — dai a sensacao de profundidade.
class SceneryPage extends StatefulWidget {
  const SceneryPage({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 40),
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  State<SceneryPage> createState() => _SceneryPageState();
}

class _SceneryPageState extends State<SceneryPage> {
  final _controller = ScrollController();
  final _offset = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_sync);
  }

  void _sync() {
    if (_controller.hasClients) _offset.value = _controller.offset;
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_sync)
      ..dispose();
    _offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // O corpo passa por tras das barras translucidas, entao o Scaffold soma a
    // altura delas ao padding do MediaQuery. Respeitar isso evita que o
    // primeiro e o ultimo item fiquem escondidos sob o desfoque.
    final barInsets = MediaQuery.paddingOf(context);

    return SceneryBackground(
      scrollOffset: _offset,
      child: ListView(
        controller: _controller,
        padding: widget.padding.add(
          EdgeInsets.only(top: barInsets.top, bottom: barInsets.bottom),
        ),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: widget.children,
      ),
    );
  }
}
