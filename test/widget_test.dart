// Teste básico de widget do app de Eventos Esportivos.
//
// Este teste apenas garante que o app sobe corretamente (smoke test),
// já que o app não possui um contador como no template padrão do Flutter.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:championships_app/main.dart';

void main() {
  testWidgets('App inicia sem erros', (WidgetTester tester) async {
    // Constrói o app e dispara um frame.
    await tester.pumpWidget(const EventosEsportivosApp());
    await tester.pumpAndSettle();

    // Verifica que o app montou normalmente (ao menos um Scaffold na tela).
    expect(find.byType(Scaffold), findsWidgets);
  });
}
