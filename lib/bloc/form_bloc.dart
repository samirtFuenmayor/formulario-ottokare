import 'package:flutter_bloc/flutter_bloc.dart';
import 'form_event.dart';
import 'form_blocstate.dart';
import '../repository/form_repository.dart';

class FormBloc extends Bloc<FormEvent, FormBlocState> {
  final FormRepository _repository = FormRepository();

  FormBloc() : super(FormInitial()) {
    on<EnviarFormulario>(_onEnviarFormulario);
  }

  Future<void> _onEnviarFormulario(
      EnviarFormulario event,
      Emitter<FormBlocState> emit,
      ) async {
    emit(FormLoading());
    try {
      final result = await _repository.enviarDatos(
        nombre: event.nombre,
        apellido: event.apellido,
        cedula: event.cedula,
        celular: event.celular,
        email: event.email,
        ciudad: event.ciudad,
        contractId: event.contractId,
        mascotas: event.mascotas,
      );
      emit(FormSuccess('Registro exitoso'));
    } catch (e) {
      emit(FormError(e.toString()));
    }
  }
}