import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/form_repository.dart';
import 'bloc/form_bloc.dart';
import 'ui/form_page.dart';
//import 'dart:html' as html;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {

  final uri = Uri.base;
  String? idStr = uri.queryParameters['contract'];

  if ((idStr == null || idStr.isEmpty) && uri.fragment.isNotEmpty) {
    final frag = uri.fragment;
    try {
      final parsed = Uri.parse(frag);
      if (parsed.pathSegments.isNotEmpty) {
        idStr = parsed.pathSegments.last;
      } else {
        idStr = frag.replaceFirst('/', '');
      }
    } catch (_) {
      idStr = frag.replaceFirst('/', '');
    }
  }

  if (idStr == null || idStr.isEmpty) {
    if (uri.pathSegments.isNotEmpty) {
      idStr = uri.pathSegments.last;
    }
  }

  final initialId = int.tryParse(idStr ?? '') ?? 0;

  runApp(MyApp(initialContractId: initialId));
}

class MyApp extends StatelessWidget {
  final int initialContractId;
  const MyApp({super.key, required this.initialContractId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // ✅ agrega esto
      debugShowCheckedModeBanner: false,
      title: 'Formulario Registro Mascota',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
      ],
      home: BlocProvider(
        create: (_) => FormBloc(),
        child: FormPage(idContrato: initialContractId), 
      ),
    );
  }
}

