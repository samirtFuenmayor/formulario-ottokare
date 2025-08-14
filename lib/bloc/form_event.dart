//import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class FormEvent {

  @override
  List<Object?> get props =>[];

}

class EnviarFormulario extends FormEvent{
  
  final String nombre;
  final String email;

  EnviarFormulario(this.nombre, this.email);

  @override
  List<Object?> get props =>[nombre, email];

  
}
