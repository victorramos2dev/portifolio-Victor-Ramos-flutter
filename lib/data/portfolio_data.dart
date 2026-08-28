import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';

/// ---------------------------------------------------------------------------
/// TODO O CONTEUDO DO APP SAI DAQUI.
/// Nenhuma tela precisa ser alterada para atualizar o portfolio.
///
/// IMAGENS (todas opcionais — sem o arquivo, o app usa um fallback):
///  - Foto:   assets/images/profile.png        512x512, quadrada.
///            Sem ela, aparecem as iniciais do nome.
///  - Capas:  `assets/images/projects/<nome>.png`  800x360, fundo transparente.
///            Aponte em `cover:` no Project. A capa do card usa essa mesma
///            proporcao, entao a arte aparece inteira. Logo com fundo branco
///            e texto preto some no tema escuro: remova o fundo e clareie o
///            texto antes (foi o que fizemos com elearn.png e kindraw.png).
///  - Fundo:  assets/images/parallax/far|mid|near.png  1080x1920, PNG com
///            transparencia. Aponte em `scenery` no fim deste arquivo.
/// ---------------------------------------------------------------------------

const profile = Profile(
  name: 'Victor Hugo da Silva Ramos',
  role: 'Desenvolvedor Full Stack',
  tagline: 'Da feature ao deploy — e a observabilidade em producao.',
  bio:
      'Desenvolvedor Full Stack em formacao (Engenharia da Computacao) com '
      'experiencia pratica em aplicacoes web corporativas ponta a ponta. '
      'Atuo em back-end com Java/Spring Boot, Python/FastAPI e Go, em front-end '
      'com Angular e React/Next.js, e em esteiras de entrega continua com Azure '
      'DevOps, Kubernetes e GitOps. Perfil analitico, com interesse em '
      'automacao de processos, arquitetura de sistemas e aplicacao de IA a '
      'problemas de negocio.',
  location: 'Campinas / Sumare, Sao Paulo',
  photoAsset: 'assets/images/profile.png',
  highlights: [
    Highlight(value: 'Bosch', label: 'Solucoes Digitais'),
    Highlight(value: '4º sem', label: 'Eng. Computacao'),
    Highlight(value: 'B2', label: 'Ingles'),
  ],
  links: [
    SocialLink(
      label: 'GitHub',
      value: 'github.com/victorhugoramos',
      icon: Icons.code,
    ),
    SocialLink(
      label: 'LinkedIn',
      value: 'linkedin.com/in/victorhugoramos',
      icon: Icons.hub_outlined,
    ),
    SocialLink(
      label: 'E-mail',
      value: 'hugo89334@gmail.com',
      icon: Icons.alternate_email,
    ),
  ],
);

/// Tecnologias agrupadas por area, como no curriculo.
const techGroups = <TechGroup>[
  TechGroup(
    name: 'Back-end',
    icon: Icons.dns_outlined,
    techs: [
      Tech(name: 'Java', level: 0.85, note: 'Spring Boot, APIs REST'),
      Tech(name: 'Spring Boot', level: 0.85, note: 'Regras de negocio e persistencia'),
      Tech(name: 'Python', level: 0.8, note: 'FastAPI e Flask'),
      Tech(name: 'FastAPI', level: 0.75, note: 'Servicos e integracoes'),
      Tech(name: 'Go', level: 0.6, note: 'APIs de alta performance'),
      Tech(name: 'Keycloak', level: 0.7, note: 'SSO com OAuth2 / OIDC'),
      Tech(name: 'Microsservicos', level: 0.7, note: 'Arquitetura distribuida'),
    ],
  ),
  TechGroup(
    name: 'Front-end',
    icon: Icons.web_asset_outlined,
    techs: [
      Tech(name: 'Angular', level: 0.8, note: 'SPA corporativa'),
      Tech(name: 'TypeScript', level: 0.8, note: 'Tipagem no front'),
      Tech(name: 'React', level: 0.75, note: 'Componentizacao'),
      Tech(name: 'Next.js', level: 0.7, note: 'App Router, SSR, basePath'),
      Tech(name: 'HTML / CSS', level: 0.8, note: 'Layout e responsividade'),
      Tech(name: 'Figma', level: 0.55, note: 'Prototipacao de telas'),
    ],
  ),
  TechGroup(
    name: 'DevOps e Cloud',
    icon: Icons.settings_ethernet,
    techs: [
      Tech(name: 'Azure DevOps', level: 0.8, note: 'Pipelines, Repos, Boards'),
      Tech(name: 'Docker', level: 0.8, note: 'Containers e builds'),
      Tech(name: 'Kubernetes', level: 0.7, note: 'Ingress e Traefik'),
      Tech(name: 'ArgoCD', level: 0.7, note: 'GitOps'),
      Tech(name: 'Google Cloud', level: 0.6, note: 'Foundations e Cloud AI'),
      Tech(name: 'Git', level: 0.85, note: 'Versionamento e branching'),
    ],
  ),
  TechGroup(
    name: 'Dados e IA',
    icon: Icons.blur_on,
    techs: [
      Tech(name: 'SQL / SQLite', level: 0.75, note: 'Modelagem relacional'),
      Tech(name: 'DINOv2', level: 0.65, note: 'Visao computacional'),
      Tech(name: 'K-Means', level: 0.65, note: 'Clusterizacao de imagens'),
      Tech(name: 'Observabilidade', level: 0.7, note: 'Logs, metricas, health checks'),
      Tech(name: 'Excel avancado', level: 0.7, note: 'Analise de dados'),
    ],
  ),
  TechGroup(
    name: 'Infra e Redes',
    icon: Icons.lan_outlined,
    techs: [
      Tech(name: 'Redes', level: 0.65, note: 'VLANs, DNS, roteamento, IPv6'),
      Tech(name: 'GLPI', level: 0.7, note: 'Chamados e controle de estoque'),
      Tech(name: 'Microsoft 365', level: 0.65, note: 'Admin Center'),
    ],
  ),
];

/// Experiencia profissional e formacao, em ordem cronologica inversa.
const timeline = <TimelineEntry>[
  TimelineEntry(
    title: 'Robert Bosch Ltda.',
    subtitle: 'Meio Oficial — Solucoes Digitais',
    period: '07/2025 — Atual',
    description:
        'Desenvolvo aplicacoes web corporativas ponta a ponta: plataforma de '
        'e-learning para a ETS e sistema de agendamento de salas e eventos. '
        'Mantenho pipelines de CI/CD no Azure DevOps, opero as aplicacoes em '
        'Kubernetes com GitOps (ArgoCD) e implantei praticas de observabilidade '
        'para diagnostico rapido de incidentes pos-deploy.',
    icon: Icons.apartment_outlined,
    tags: ['Java', 'Spring Boot', 'Angular', 'Next.js', 'Kubernetes', 'ArgoCD'],
  ),
  TimelineEntry(
    title: 'Cooperlink Brasil',
    subtitle: 'Estagiario de TI',
    period: '02/2024 — 02/2025',
    description:
        'Suporte e manutencao do parque de maquinas, administracao de sistemas '
        'corporativos (Microsoft Admin, PABX, dominios, e-mail) e atuacao em '
        'arquitetura de rede. Implantei o GLPI como sistema de chamados e '
        'controle de estoque, incluindo o treinamento dos usuarios.',
    icon: Icons.support_agent_outlined,
    tags: ['GLPI', 'Microsoft 365', 'Redes', 'Infraestrutura'],
  ),
  TimelineEntry(
    title: 'Universidade Sao Francisco (USF)',
    subtitle: 'Bacharelado em Engenharia da Computacao',
    period: 'Cursando — 4º semestre',
    description: 'Campinas, Sao Paulo.',
    icon: Icons.school_outlined,
  ),
  TimelineEntry(
    title: 'SENAI Roberto Mange',
    subtitle: 'Tecnico em Desenvolvimento de Sistemas',
    period: 'Cursando — 3º semestre',
    description: 'Campinas, Sao Paulo.',
    icon: Icons.menu_book_outlined,
  ),
  TimelineEntry(
    title: 'E. M. Dr. Leandro Franceschini',
    subtitle: 'Ensino Medio integrado ao Tecnico em Informatica',
    period: 'Concluido',
    description: 'Sumare, Sao Paulo.',
    icon: Icons.workspace_premium_outlined,
  ),
];

/// Cursos e certificacoes.
const certifications = <TimelineEntry>[
  TimelineEntry(
    title: 'Google Cloud Foundations & AI Foundations',
    subtitle: 'SENAI Sumare',
    period: '80h',
    description:
        'Fundamentos de cloud na Google Cloud e aplicacao de IA em projetos.',
    icon: Icons.cloud_outlined,
  ),
  TimelineEntry(
    title: 'Redes de Computadores, Excel e JavaScript',
    subtitle: 'Alura',
    period: '37h',
    description:
        'Analise de dados, programacao para web, VLANs, roteamento, DNS e IPv6.',
    icon: Icons.router_outlined,
  ),
  TimelineEntry(
    title: 'Ingles',
    subtitle: 'KNN Idiomas, Sumare',
    period: 'Concluido',
    description: 'Conversacao e escrita — nivel B2.',
    icon: Icons.translate_outlined,
  ),
];


const curiosities = <Curiosity>[
  Curiosity(
    title: 'Mestre de RPG',
    description:
        'Mestro mesas de RPG e levo isso para o codigo: preparar uma campanha e '
        'projetar um sistema sao a mesma coisa. Voce desenha as regras, deixa '
        'espaco para o imprevisto e aprende a improvisar quando os jogadores '
        'decidem fazer exatamente o que voce nao previu. Foi mestrando que '
        'aprendi a explicar arquitetura para quem nunca viu o codigo.',
    icon: Icons.casino_outlined,
    highlight: true,
  ),
  Curiosity(
    title: 'Hackathon Bosch',
    description:
        'Levei o KinDraw do zero ao demo em poucos dias, cuidando do modelo de '
        'IA e da arquitetura de servicos.',
    icon: Icons.bolt_outlined,
  ),
  Curiosity(
    title: 'Duas formacoes ao mesmo tempo',
    description:
        'Engenharia da Computacao na USF e Tecnico em Desenvolvimento de '
        'Sistemas no SENAI, em paralelo ao trabalho.',
    icon: Icons.auto_stories_outlined,
  ),
  Curiosity(
    title: 'Automatizar o repetitivo',
    description:
        'Se uma tarefa se repete tres vezes, ja estou escrevendo o script ou a '
        'pipeline que faz por mim.',
    icon: Icons.settings_suggest_outlined,
  ),
];

const attributes = <Attribute>[
  Attribute(name: 'Analise', value: 18),
  Attribute(name: 'Arquitetura', value: 16),
  Attribute(name: 'Improviso', value: 17),
  Attribute(name: 'Colaboracao', value: 17),
];


const quotes = <Quote>[
  Quote(
    text: 'Primeiro faca funcionar, depois faca certo, depois faca rapido.',
    author: 'Kent Beck',
  ),
  Quote(
    text:
        'Programar e a arte de contar a outro humano o que o computador deve fazer.',
    author: 'Donald Knuth',
  ),
  Quote(
    text: 'A melhor forma de prever o futuro e inventa-lo.',
    author: 'Alan Kay',
  ),
  Quote(
    text: 'Nenhum plano sobrevive ao contato com os jogadores — nem com producao.',
    author: '',
  ),
];


const projects = <Project>[
  Project(
    id: 'elearn',
    title: 'E-Learn',
    cover: 'assets/images/projects/elearn.png',
    subtitle: 'Plataforma de ensino corporativo (ETS)',
    description:
        'Plataforma de e-learning interna inspirada no Google Classroom, criada '
        'para a ETS centralizar turmas, conteudos e avaliacoes, substituindo o '
        'controle disperso de materiais de treinamento.',
    year: '2026',
    context: 'Robert Bosch',
    tags: ['Java', 'Spring Boot', 'Angular', 'Keycloak', 'Docker', 'Azure DevOps'],
    icon: Icons.school_outlined,
    gradient: [Color(0xFF1E3A8A), Color(0xFF0EA5E9)],
    highlights: [
      'Back-end em Spring Boot com APIs REST, regras de negocio e persistencia',
      'Front-end Angular com criacao de atividades e gestao de arquivos por turma',
      'SSO via Keycloak (OAuth2 / OIDC) com perfis de instrutor e aluno',
      'Integracao com sistemas internos, aderente aos padroes corporativos',
    ],
    baseLikes: 24,
  ),
  Project(
    id: 'kindraw',
    title: 'KinDraw',
    cover: 'assets/images/projects/kindraw.png',
    subtitle: 'Agrupamento inteligente de desenhos tecnicos',
    description:
        'Solucao de IA que classifica e agrupa desenhos tecnicos por grau de '
        'similaridade, facilitando a identificacao, a organizacao e a '
        'padronizacao do acervo por engenheiros e times tecnicos.',
    year: '2026',
    context: 'Hackathon Bosch Campinas',
    tags: ['Python', 'Flask', 'Go', 'DINOv2', 'K-Means', 'Docker'],
    icon: Icons.blur_on,
    gradient: [Color(0xFF7C3AED), Color(0xFFEC4899)],
    highlights: [
      'Modelo de visao computacional com DINOv2 e K-Means para clusterizacao',
      'Metricas de qualidade dos agrupamentos entregues a camada de visualizacao',
      'Microsservicos: API em Go para HTTP e API em Python (Flask) para o modelo',
    ],
    baseLikes: 31,
  ),
  Project(
    id: 'agendamento',
    title: 'Sistema de Agendamento',
    subtitle: 'Reserva de salas e eventos corporativos',
    description:
        'Aplicacao para agendamento de salas e eventos, construida ponta a ponta '
        'e operada em Kubernetes com entrega continua e observabilidade.',
    year: '2025',
    context: 'Robert Bosch',
    tags: ['Python', 'FastAPI', 'React', 'Next.js', 'Kubernetes', 'ArgoCD'],
    icon: Icons.event_available_outlined,
    gradient: [Color(0xFF0F766E), Color(0xFF22D3EE)],
    highlights: [
      'Back-end em FastAPI e front-end em Next.js (App Router, SSR)',
      'Deploy GitOps com ArgoCD, Ingress/Traefik e roteamento por path',
      'Logs estruturados, metricas e health checks para diagnostico pos-deploy',
    ],
    baseLikes: 17,
  ),
  Project(
    id: 'portfolio-mobile',
    title: 'Portfolio Mobile',
    subtitle: 'Este aplicativo',
    description:
        'Portfolio em Flutter com cenario em parallax, catalogo de projetos '
        'curtiveis e carrossel de frases. Construido para praticar design de '
        'interface e animacao fora do ambiente web.',
    year: '2026',
    context: 'Projeto pessoal',
    tags: ['Flutter', 'Dart', 'UI', 'Animacao'],
    icon: Icons.phone_iphone,
    gradient: [Color(0xFFB45309), Color(0xFFFFB800)],
    highlights: [
      'Fundo com tres camadas de parallax e poeira flutuante desenhada em canvas',
      'Curtidas com estado compartilhado entre as telas',
    ],
    baseLikes: 8,
  ),
];

const scenery = SceneryLayers(
  far: null, // 'assets/images/parallax/far.png'
  mid: null, // 'assets/images/parallax/mid.png'
  near: null, // 'assets/images/parallax/near.png'
);
