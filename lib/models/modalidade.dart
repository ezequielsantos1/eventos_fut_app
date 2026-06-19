import 'package:flutter/material.dart';

enum Modalidade { futebol, society, futsal }

extension ModalidadeExt on Modalidade {
  String get label {
    switch (this) {
      case Modalidade.futebol:
        return 'Futebol';
      case Modalidade.society:
        return 'Society';
      case Modalidade.futsal:
        return 'Futsal';
    }
  }

  String get emoji {
    switch (this) {
      case Modalidade.futebol:
        return '⚽';
      case Modalidade.society:
        return '🏟️';
      case Modalidade.futsal:
        return '🥅';
    }
  }

  Color get cor {
    switch (this) {
      case Modalidade.futebol:
        return const Color(0xFF2DA44E);
      case Modalidade.society:
        return const Color(0xFFE07B00);
      case Modalidade.futsal:
        return const Color(0xFF1565C0);
    }
  }

  int get maxJogadoresPadrao {
    switch (this) {
      case Modalidade.futebol:
        return 22;
      case Modalidade.society:
        return 14;
      case Modalidade.futsal:
        return 10;
    }
  }
}