import 'package:flutter_bloc/flutter_bloc.dart';
import 'form_event.dart';
import 'form_blocstate.dart'; // aquí tienes FormBlocState
import '../repository/form_repository.dart';

class FormBloc extends Bloc<FormEvent, FormBlocState> {
  FormBloc() : super(FormInitial()) {
    on<EnviarFormulario>(_onEnviarFormulario);
  }

  Future<void> _onEnviarFormulario(EnviarFormulario event, Emitter<FormBlocState> emit) async {
    emit(FormLoading());
    try {
      // Aquí iría tu lógica: HTTP, validaciones, subir archivo, etc.
      // Simulamos un delay y devolvemos éxito.
      await Future.delayed(const Duration(seconds: 1));
      emit(FormSuccess('Formulario enviado correctamente: ${event.nombre}'));
    } catch (e) {
      emit(FormError(e.toString()));
    }
  }
}