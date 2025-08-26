import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_ottocare/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App carga y muestra header', (WidgetTester tester) async {
    // Construimos la app pasando el id requerido
    await tester.pumpWidget(MyApp(initialContractId: 0));

    // Espera a que terminen animaciones/frames
    await tester.pumpAndSettle();

    // Ajusta el texto a algo que exista en tu FormPage,
    // por ejemplo: 'Asistencia Veterinaria'
    expect(find.text('Asistencia Veterinaria'), findsOneWidget);
  });
}
