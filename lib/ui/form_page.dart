import 'package:flutter/material.dart';
import 'package:frontend_ottocare/layout/responsive_layout.dart';
import 'views/desktop_view.dart';
import 'views/tablet_view.dart';
import 'views/mobile_view.dart';

class FormPage extends StatelessWidget {
  final int idContrato;

  const FormPage({super.key, required this.idContrato});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        desktop: const DesktopView(),
        tablet: const TabletView(),
        mobile: const MobileView(),
      ),
    );
  }
}