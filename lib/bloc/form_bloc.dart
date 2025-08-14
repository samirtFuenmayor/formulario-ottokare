import 'package:flutter_bloc/flutter_bloc.dart';
import 'form_event.dart';
import 'form_blocstate.dart'; // aquí tienes FormBlocState
import '../repository/form_repository.dart';

class FormBloc extends Bloc<FormEvent, FormBlocState> { // <- cambio aquí
  final FormRepository repository;

  FormBloc(this.repository) : super(FormInitial()) {
    on<EnviarFormulario>((event, emit) async {
      emit(FormLoading());
      try {
        final mensaje = await repository.enviarDatos(event.nombre, event.email);
        emit(FormSuccess(mensaje));
      } catch (e) {
        emit(FormError(e.toString()));
      }
    });
  }
}
