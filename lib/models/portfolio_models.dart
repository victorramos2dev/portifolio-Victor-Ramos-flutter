import 'package:flutter/material.dart';

/// Dados pessoais exibidos no topo da tela de apresentacao.
class Profile {
  const Profile({
    required this.name,
    required this.role,
    required this.tagline,
    required this.bio,
    required this.location,
    required this.photoAsset,
    this.highlights = const [],
    this.links = const [],
  });

  final String name;
  final String role;
  final String tagline;
  final String bio;
  final String location;

  /// Caminho do asset da foto. Se o arquivo nao existir, o app mostra as
  /// iniciais do nome no lugar (sem quebrar).
  final String photoAsset;

  /// Numeros de impacto mostrados logo abaixo da foto.
  final List<Highlight> highlights;

  final List<SocialLink> links;

  /// Iniciais usadas como fallback da foto (ex.: "Victor Ramos" -> "VR").
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

/// Metrica curta do tipo "2+ anos / experiencia".
class Highlight {
  const Highlight({required this.value, required this.label});

  final String value;
  final String label;
}

class SocialLink {
  const SocialLink({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

/// Grupo de tecnologias (ex.: Back-end, Front-end, DevOps).
class TechGroup {
  const TechGroup({
    required this.name,
    required this.icon,
    required this.techs,
  });

  final String name;
  final IconData icon;
  final List<Tech> techs;

  /// Media dos niveis do grupo — usada na barra do cabecalho.
  double get level {
    if (techs.isEmpty) return 0;
    final sum = techs.fold<double>(0, (total, tech) => total + tech.level);
    return sum / techs.length;
  }
}

/// Uma tecnologia que voce domina, com nivel de 0.0 a 1.0.
class Tech {
  const Tech({
    required this.name,
    required this.level,
    this.note = '',
  });

  final String name;

  /// 0.0 a 1.0 — vira a barra de proficiencia animada.
  final double level;

  final String note;

  String get levelLabel {
    if (level >= 0.85) return 'Avancado';
    if (level >= 0.65) return 'Solido';
    if (level >= 0.45) return 'Praticando';
    return 'Explorando';
  }
}

/// Item da linha do tempo profissional / academica.
class TimelineEntry {
  const TimelineEntry({
    required this.title,
    required this.subtitle,
    required this.period,
    required this.description,
    required this.icon,
    this.tags = const [],
  });

  final String title;
  final String subtitle;
  final String period;
  final String description;
  final IconData icon;
  final List<String> tags;
}

/// Curiosidade pessoal (ex.: mestre de RPG).
class Curiosity {
  const Curiosity({
    required this.title,
    required this.description,
    required this.icon,
    this.highlight = false,
  });

  final String title;
  final String description;
  final IconData icon;

  /// Marca o card em destaque (usado na curiosidade principal).
  final bool highlight;
}

/// Atributo no estilo ficha de RPG, exibido no card de destaque.
class Attribute {
  const Attribute({required this.name, required this.value});

  final String name;

  /// Valor de 1 a 20, como em um d20.
  final int value;
}

/// Frase exibida no carrossel da tela dinamica.
class Quote {
  const Quote({required this.text, this.author = ''});

  final String text;
  final String author;
}

/// Projeto do catalogo.
class Project {
  const Project({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.year,
    required this.context,
    required this.tags,
    required this.icon,
    required this.gradient,
    this.highlights = const [],
    this.baseLikes = 0,
    this.cover,
    this.link,
  });

  /// Identificador estavel — e a chave usada para guardar as curtidas.
  final String id;

  final String title;

  /// Linha curta abaixo do titulo (ex.: "Plataforma de ensino corporativo").
  final String subtitle;

  final String description;
  final String year;

  /// Onde o projeto aconteceu (ex.: "Robert Bosch", "Hackathon").
  final String context;

  final List<String> tags;
  final IconData icon;

  /// Duas cores usadas na capa quando nao ha imagem.
  final List<Color> gradient;

  /// Pontos principais listados no card.
  final List<String> highlights;

  /// Curtidas iniciais mostradas antes de o usuario curtir.
  final int baseLikes;

  /// Capa opcional em assets/images/projects/. Null usa o gradiente.
  final String? cover;

  final String? link;
}

/// Caminhos opcionais das camadas do cenario com parallax.
/// Deixe em null para usar o cenario desenhado por codigo.
class SceneryLayers {
  const SceneryLayers({this.far, this.mid, this.near});

  /// Camada mais distante — rola devagar.
  final String? far;

  /// Camada intermediaria.
  final String? mid;

  /// Primeiro plano — rola mais rapido.
  final String? near;
}
