import 'package:equatable/equatable.dart';

abstract class FormBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FormInitial extends FormBlocState {}

class FormLoading extends FormBlocState {}

class FormSuccess extends FormBlocState {
  final String mensaje;
  FormSuccess(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}

class FormError extends FormBlocState {
  final String error;
  FormError(this.error);

  @override
  List<Object?> get props => [error];
}