import 'package:flutter/material.dart';

/// Guarda quais projetos o usuario curtiu durante a sessao.
///
/// E um [ChangeNotifier] exposto pela arvore via [LikesScope], entao qualquer
/// card consegue curtir/descurtir e o resto da tela (contador do topo, lista
/// de favoritos, ordenacao) se atualiza sozinho.
class LikesController extends ChangeNotifier {
  final Set<String> _liked = <String>{};

  Set<String> get liked => Set.unmodifiable(_liked);
  int get total => _liked.length;

  bool isLiked(String projectId) => _liked.contains(projectId);

  void toggle(String projectId) {
    if (!_liked.remove(projectId)) {
      _liked.add(projectId);
    }
    notifyListeners();
  }

  void clear() {
    if (_liked.isEmpty) return;
    _liked.clear();
    notifyListeners();
  }
}

/// Disponibiliza o [LikesController] para a arvore de widgets abaixo.
class LikesScope extends InheritedNotifier<LikesController> {
  const LikesScope({
    super.key,
    required LikesController controller,
    required super.child,
  }) : super(notifier: controller);

  static LikesController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LikesScope>();
    assert(scope != null, 'Nenhum LikesScope encontrado acima deste widget.');
    return scope!.notifier!;
  }
}
