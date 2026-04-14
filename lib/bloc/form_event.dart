import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class FormEvent {
  List<Object?> get props => [];
}

class EnviarFormulario extends FormEvent {
  final String nombre;
  final String apellido;
  final String cedula;
  final String celular;
  final String email;
  final String ciudad;
  final String direccion;
  final String contractId;
  final List<Map<String, dynamic>> mascotas;

  EnviarFormulario({
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.celular,
    required this.email,
    required this.ciudad,
    required this.direccion,
    required this.contractId,
    required this.mascotas,
  });

  @override
  List<Object?> get props => [nombre, email, contractId];
}