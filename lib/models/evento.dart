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
  final String cep;
  final String bairro;
  final String cidade;
  final String estado;

  Evento({
    required this.id,
    required this.titulo,
    required this.local,
    required this.dataHora,
    required this.modalidade,
    required this.organizador,
    required this.maxJogadores,
    Set<String>? confirmados,
    this.cep = '',
    this.bairro = '',
    this.cidade = '',
    this.estado = '',
  }) : confirmados = confirmados ?? {};

  /// Endereço completo formatado (bairro, cidade - estado, CEP),
  /// ignorando partes vazias.
  String get enderecoCompleto {
    final partes = <String>[];
    if (bairro.isNotEmpty) partes.add(bairro);
    if (cidade.isNotEmpty && estado.isNotEmpty) {
      partes.add('$cidade - $estado');
    } else if (cidade.isNotEmpty) {
      partes.add(cidade);
    }
    if (cep.isNotEmpty) partes.add('CEP $cep');
    return partes.join(', ');
  }

  bool get cheio => confirmados.length >= maxJogadores;

  int get vagasRestantes => maxJogadores - confirmados.length;

  double get ocupacao =>
      maxJogadores > 0 ? confirmados.length / maxJogadores : 0.0;
}