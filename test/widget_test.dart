import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portifolio_mobile_victor/data/portfolio_data.dart' as data;
import 'package:portifolio_mobile_victor/main.dart';
import 'package:portifolio_mobile_victor/widgets/project_card.dart';
import 'package:portifolio_mobile_victor/widgets/tech_group_card.dart';

/// Traz o widget para o meio do viewport. As barras do topo e do rodape sao
/// translucidas e ficam sobre a lista, entao um item so encostado na borda
/// nao recebe o toque.
Future<void> centerOn(WidgetTester tester, Finder finder) async {
  Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('apresentacao mostra perfil, tecnologias e trajetoria',
      (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(seconds: 1));

    // O nome aparece em caixa alta no retrato.
    expect(find.text(data.profile.name.toUpperCase()), findsOneWidget);

    // A tela tem varios Scrollables (filtros, carrossel); o primeiro e a lista.
    final pageScroll = find.byType(Scrollable).first;

    await tester.scrollUntilVisible(find.text('Sobre mim'), 250,
        scrollable: pageScroll);
    expect(find.text('Sobre mim'), findsOneWidget);

    await tester.scrollUntilVisible(find.byType(TechGroupCard), 250,
        scrollable: pageScroll);
    expect(find.text('Tecnologias'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Trajetoria'), 250,
        scrollable: pageScroll);
    expect(find.text('Robert Bosch Ltda.'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Curiosidades'), 250,
        scrollable: pageScroll);
    expect(find.text('Mestre de RPG'), findsOneWidget);
  });

  testWidgets('grupo de tecnologias abre e fecha ao toque', (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(seconds: 1));

    await tester.scrollUntilVisible(
      find.byType(TechGroupCard),
      250,
      scrollable: find.byType(Scrollable).first,
    );

    // O primeiro grupo ja vem aberto (Back-end).
    expect(find.text('Spring Boot'), findsWidgets);

    await centerOn(tester, find.text('Back-end'));
    await tester.tap(find.text('Back-end'));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Spring Boot'), findsNothing);
  });

  testWidgets('tela dinamica mostra frases e permite curtir um projeto',
      (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(seconds: 1));

    // Vai para a segunda aba pela barra inferior.
    await tester.tap(find.byIcon(Icons.grid_view_outlined));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Frases'), findsOneWidget);
    expect(find.text(data.quotes.first.text), findsOneWidget);
    expect(find.text('Nenhum projeto curtido ainda'), findsOneWidget);

    // Rola ate o primeiro card e curte.
    await tester.scrollUntilVisible(
      find.byType(LikeButton),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await centerOn(tester, find.byType(LikeButton).first);

    final before = tester.widget<LikeButton>(find.byType(LikeButton).first);
    expect(before.liked, isFalse);

    await tester.tap(find.byType(LikeButton).first);
    await tester.pump(const Duration(seconds: 1));

    final after = tester.widget<LikeButton>(find.byType(LikeButton).first);
    expect(after.liked, isTrue);
    expect(after.likeCount, before.likeCount + 1);
  });

  testWidgets('filtro "so curtidos" deixa apenas o projeto curtido',
      (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byIcon(Icons.grid_view_outlined));
    await tester.pump(const Duration(seconds: 1));

    final pageScroll = find.byType(Scrollable).first;

    // Curte o primeiro projeto da lista.
    await tester.scrollUntilVisible(find.byType(LikeButton), 250,
        scrollable: pageScroll);
    await centerOn(tester, find.byType(LikeButton).first);
    await tester.tap(find.byType(LikeButton).first);
    await tester.pump(const Duration(seconds: 1));

    // Volta para a barra de curtidas (esta acima) e liga o filtro.
    await tester.scrollUntilVisible(find.text('So curtidos'), -250,
        scrollable: pageScroll);
    await centerOn(tester, find.text('So curtidos'));
    await tester.tap(find.text('So curtidos'));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ProjectCard), findsOneWidget);
    expect(find.text('1 projeto curtido'), findsOneWidget);
  });
}
