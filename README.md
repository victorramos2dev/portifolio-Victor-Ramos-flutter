# Portfólio Mobile — Victor Hugo da Silva Ramos

Aplicativo de portfólio pessoal feito em Flutter, com duas telas.

**Apresentação** reúne foto, contatos, um resumo sobre mim, as tecnologias que
uso agrupadas por área, a trajetória profissional e acadêmica, os cursos e
algumas curiosidades — entre elas a ficha de Mestre de RPG.

**Projetos** traz um carrossel de frases e o catálogo do que já construí
(E-Learn, KinDraw, Sistema de Agendamento e este próprio app), com botão de
curtir, filtro por tecnologia e ordenação.

A interface tem tema escuro, fundo com camadas em parallax que se movem
conforme a rolagem e transições animadas.

## Requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) 3.47 ou superior
- Um emulador Android/iOS, um dispositivo conectado ou o Chrome

## Como rodar

```bash
flutter pub get
flutter run
```

Para escolher onde executar:

```bash
flutter devices            # lista os dispositivos disponíveis
flutter run -d chrome      # no navegador
flutter run -d windows     # como app de desktop
```

## Testes

```bash
flutter test
```

## Build de release

```bash
flutter build apk        # Android
flutter build web        # Web
```

O resultado fica em `build/`.
