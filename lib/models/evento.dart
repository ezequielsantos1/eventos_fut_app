import 'modalidade.dart';

class Evento {
  final String id;
  final String titulo;
  final String local;
  final DateTime dataHora;
  final Modalidade modalidade;
  final String organizador;
  final int maxJogadores;
  final Set<String> confirmados;

  Evento({
    required this.id,
    required this.titulo,
    required this.local,
    required this.dataHora,
    required this.modalidade,
    required this.organizador,
    required this.maxJogadores,
    Set<String>? confirmados,
  }) : confirmados = confirmados ?? {};

  bool get cheio => confirmados.length >= maxJogadores;

  int get vagasRestantes => maxJogadores - confirmados.length;

  double get ocupacao =>
      maxJogadores > 0 ? confirmados.length / maxJogadores : 0.0;
}