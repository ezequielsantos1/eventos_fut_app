import 'package:flutter/material.dart';
import 'evento.dart';
import 'modalidade.dart';

class EventosProvider extends ChangeNotifier {
  final List<Evento> _eventos = [
    Evento(
      id: '1',
      titulo: 'Pelada das Quartas',
      local: 'Campo do Bairro Novo, Caxias - MA',
      dataHora: DateTime.now().add(const Duration(days: 1, hours: 3)),
      modalidade: Modalidade.futebol,
      organizador: 'João Silva',
      maxJogadores: 22,
      confirmados: {'eu'},
    ),
    Evento(
      id: '2',
      titulo: 'Torneio Society Fim de Semana',
      local: 'Arena Society Park, Caxias - MA',
      dataHora: DateTime.now().add(const Duration(days: 3, hours: 8)),
      modalidade: Modalidade.society,
      organizador: 'Pedro Alves',
      maxJogadores: 14,
      confirmados: {},
    ),
    Evento(
      id: '3',
      titulo: 'Futsal de Sábado',
      local: 'Ginásio Municipal, Caxias - MA',
      dataHora: DateTime.now().add(const Duration(days: 5, hours: 5)),
      modalidade: Modalidade.futsal,
      organizador: 'Carlos Lima',
      maxJogadores: 10,
      confirmados: {},
    ),
    Evento(
      id: '4',
      titulo: 'Clássico do Bairro',
      local: 'Campo da Ressaca, Caxias - MA',
      dataHora: DateTime.now().add(const Duration(days: 7, hours: 4)),
      modalidade: Modalidade.futebol,
      organizador: 'Roberto Costa',
      maxJogadores: 22,
      confirmados: {'eu', 'amigo1', 'amigo2'},
    ),
    Evento(
      id: '5',
      titulo: 'Copa Futsal Noturna',
      local: 'Quadra Coberta Central, Caxias - MA',
      dataHora: DateTime.now().add(const Duration(days: 9, hours: 7)),
      modalidade: Modalidade.futsal,
      organizador: 'Marcos Rocha',
      maxJogadores: 10,
      confirmados: {},
    ),
    Evento(
      id: '6',
      titulo: 'Society da Amizade',
      local: 'Society Boa Vista, Caxias - MA',
      dataHora: DateTime.now().add(const Duration(days: 12, hours: 6)),
      modalidade: Modalidade.society,
      organizador: 'Felipe Mendes',
      maxJogadores: 14,
      confirmados: {},
    ),
  ];

  List<Evento> get eventos => List.unmodifiable(_eventos);

  List<Evento> filtrarPor(Modalidade? modalidade) {
    if (modalidade == null) return eventos;
    return _eventos.where((e) => e.modalidade == modalidade).toList();
  }

  void adicionarEvento(Evento evento) {
    _eventos.add(evento);
    notifyListeners();
  }

  void confirmarPresenca(String eventoId, String userId) {
    final idx = _eventos.indexWhere((e) => e.id == eventoId);
    if (idx == -1) return;
    final evento = _eventos[idx];
    if (evento.confirmados.contains(userId)) {
      evento.confirmados.remove(userId);
    } else if (!evento.cheio) {
      evento.confirmados.add(userId);
    }
    notifyListeners();
  }

  bool estaConfirmado(String eventoId, String userId) {
    final evento = _eventos.firstWhere(
      (e) => e.id == eventoId,
      orElse: () => Evento(
        id: '',
        titulo: '',
        local: '',
        dataHora: DateTime.now(),
        modalidade: Modalidade.futebol,
        organizador: '',
        maxJogadores: 0,
      ),
    );
    return evento.confirmados.contains(userId);
  }
}