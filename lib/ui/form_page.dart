import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_ottocare/layout/responsive_layout.dart';
import '../bloc/form_bloc.dart';
import '../bloc/form_blocstate.dart';
import 'views/desktop_view.dart';
import 'views/tablet_view.dart';
import 'views/mobile_view.dart';

class FormPage extends StatelessWidget {
  final int idContrato;
  const FormPage({super.key, required this.idContrato});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<FormBloc, FormBlocState>(
        listener: (context, state) {
          if (state is FormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al registrar: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: ResponsiveLayout(
          desktop: DesktopView(contractId: idContrato.toString()),
          tablet: TabletView(contractId: idContrato.toString()),
          mobile: MobileView(contractId: idContrato.toString()),
        ),
      ),
    );
  }
}