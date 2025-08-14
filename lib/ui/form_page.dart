import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/form_bloc.dart';
import '../bloc/form_event.dart';
import '../bloc/form_blocstate.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';


class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _pageController = PageController();
  final _formKeyOwner = GlobalKey<FormState>();
  final _formKeyPet = GlobalKey<FormState>();

  // Dueño
  final TextEditingController _ownerName = TextEditingController();
  final TextEditingController _ownerId = TextEditingController();
  final TextEditingController _ownerPhone = TextEditingController();
  final TextEditingController _ownerAddress = TextEditingController();
  final TextEditingController _ownerEmail = TextEditingController();
  bool _acceptTerms = false;

  // Mascota
  final TextEditingController _petName = TextEditingController();
  String? _petGender;
  String? _petBreed;
  final TextEditingController _petAge = TextEditingController();
  final TextEditingController _petCard = TextEditingController();
  File? _petFile;
  List<Map<String, dynamic>> _pets = [];

  @override
  void dispose() {
    _pageController.dispose();
    _ownerName.dispose();
    _ownerId.dispose();
    _ownerPhone.dispose();
    _ownerAddress.dispose();
    _ownerEmail.dispose();
    _petName.dispose();
    _petAge.dispose();
    _petCard.dispose();
    super.dispose();
  }

  void _showTermsModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Términos y Condiciones"),
        content: const Text(
            "Aquí se muestran los términos y condiciones del servicio."),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _acceptTerms = true;
              });
              Navigator.pop(context);
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _petFile = File(result.files.single.path!);
      });
    }
  }

  void _addPet() {
    if (_formKeyPet.currentState!.validate() &&
        _petGender != null &&
        _petBreed != null) {
      setState(() {
        _pets.add({
          'nombre': _petName.text,
          'genero': _petGender,
          'raza': _petBreed,
        });
        _petName.clear();
        _petGender = null;
        _petBreed = null;
        _petAge.clear();
        _petCard.clear();
        _petFile = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
    }
  }

  void _registerPets() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Datos enviados'),
        content: const Text('El registro de mascotas se ha completado.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pageController.animateToPage(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              setState(() {
                _pets.clear();
              });
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false, IconData? icon}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: _inputDecoration(label, icon ?? Icons.text_fields),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged, IconData icon) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: (v) => v == null ? 'Seleccione una opción' : null,
      decoration: _inputDecoration(label, icon),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _styledButton(String text, VoidCallback onPressed,
      {IconData? icon, Color? color}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: icon != null ? Icon(icon, color: Colors.white) : const SizedBox(),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo completo
          Image.network(
            'https://c.files.bbci.co.uk/48DD/production/_107435681_perro1.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Container(
              width: 1100,
              height: 700,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Panel izquierdo con imagen adaptativa
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Image.network(
                            'https://c.files.bbci.co.uk/48DD/production/_107435681_perro1.jpg',
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            fit: BoxFit.cover, // Esto hace que se adapte
                          );
                        },
                      ),
                    ),
                  ),
                  // Panel derecho - formulario
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Página 1 - Dueño
                          Center(
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKeyOwner,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 40),
                                    const Text('Dueño de Mascota',
                                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: _buildTextField('Nombre', _ownerName, icon: Icons.person)),
                                        const SizedBox(width: 16),
                                        Expanded(
                                            child: _buildTextField('Cédula', _ownerId, icon: Icons.credit_card)),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: _buildTextField('Teléfono', _ownerPhone, icon: Icons.phone)),
                                        const SizedBox(width: 16),
                                        Expanded(
                                            child: _buildTextField('Correo electrónico', _ownerEmail, icon: Icons.email)),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField('Dirección', _ownerAddress, icon: Icons.home),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _acceptTerms,
                                          onChanged: (value) {
                                            if (value == true && !_acceptTerms) {
                                              _showTermsModal();
                                            }
                                          },
                                          activeColor: Colors.blueAccent,
                                        ),
                                        const Text('Aceptar Términos y Condiciones', style: TextStyle(fontSize: 13)),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    _styledButton('Siguiente', () {
                                      if (_acceptTerms && _formKeyOwner.currentState!.validate()) {
                                        _pageController.animateToPage(1,
                                            duration: const Duration(milliseconds: 500),
                                            curve: Curves.easeInOut);
                                      }
                                    }, icon: Icons.arrow_forward),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Página 2 - Mascota
                          Center(
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKeyPet,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 40),
                                    const Text('Registro Mascota',
                                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: _buildTextField('Nombre Mascota', _petName, icon: Icons.pets)),
                                        const SizedBox(width: 16),
                                        Expanded(
                                            child: _buildDropdownField('Género', _petGender,
                                                ['Macho', 'Hembra'], (v) => setState(() => _petGender = v), Icons.wc)),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: _buildDropdownField('Raza', _petBreed,
                                                ['Perro', 'Gato', 'Ave'], (v) => setState(() => _petBreed = v), Icons.category)),
                                        const SizedBox(width: 16),
                                        Expanded(child: _buildTextField('Edad', _petAge, icon: Icons.cake)),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(child: _buildTextField('Carnet', _petCard, icon: Icons.badge)),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _styledButton('Subir Archivo', _pickFile,
                                              icon: Icons.upload_file, color: Colors.amber),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    _styledButton('Agregar', _addPet, icon: Icons.add, color: Colors.blue),
                                    const SizedBox(height: 24),
                                    // DataTable scrollable
                                    if (_pets.isNotEmpty)
                                      Container(
                                        constraints: const BoxConstraints(maxHeight: 200),
                                        child: Scrollbar(
                                          thumbVisibility: true,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: DataTable(
                                              columns: const [
                                                DataColumn(label: Text('Nombre')),
                                                DataColumn(label: Text('Acciones')),
                                              ],
                                              rows: _pets.asMap().entries.map((e) => DataRow(cells: [
                                                    DataCell(Text(e.value['nombre'])),
                                                    DataCell(IconButton(
                                                      icon: const Icon(Icons.delete, color: Colors.red),
                                                      onPressed: () => setState(() => _pets.removeAt(e.key)),
                                                    )),
                                                  ])).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 50),
                                              child: IconButton(
                                                icon: const Icon(Icons.arrow_back, size: 32, color: Colors.blueAccent),
                                                onPressed: () {
                                                  _pageController.animateToPage(0,
                                                      duration: const Duration(milliseconds: 500),
                                                      curve: Curves.easeInOut);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 20),
                                              child: _styledButton('Registrar', _registerPets,
                                                  icon: Icons.check, color: Colors.green),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
class _FormPageState extends State<FormPage> {
  final _pageController = PageController();
  final _formKeyOwner = GlobalKey<FormState>();
  final _formKeyPet = GlobalKey<FormState>();

  // Dueño
  final TextEditingController _ownerName = TextEditingController();
  final TextEditingController _ownerId = TextEditingController();
  final TextEditingController _ownerPhone = TextEditingController();
  final TextEditingController _ownerAddress = TextEditingController();
  final TextEditingController _ownerEmail = TextEditingController();
  bool _acceptTerms = false;

  // Mascota
  final TextEditingController _petName = TextEditingController();
  String? _petGender;
  String? _petBreed;
  final TextEditingController _petAge = TextEditingController();
  final TextEditingController _petCard = TextEditingController();
  File? _petFile;
  List<Map<String, dynamic>> _pets = [];

  @override
  void dispose() {
    _pageController.dispose();
    _ownerName.dispose();
    _ownerId.dispose();
    _ownerPhone.dispose();
    _ownerAddress.dispose();
    _ownerEmail.dispose();
    _petName.dispose();
    _petAge.dispose();
    _petCard.dispose();
    super.dispose();
  }

  void _showTermsModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Términos y Condiciones"),
        content: const Text(
            "Aquí se muestran los términos y condiciones del servicio."),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _acceptTerms = true;
              });
              Navigator.pop(context);
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _petFile = File(result.files.single.path!);
      });
    }
  }

  void _addPet() {
    if (_formKeyPet.currentState!.validate() &&
        _petGender != null &&
        _petBreed != null) {
      setState(() {
        _pets.add({
          'nombre': _petName.text,
          'genero': _petGender,
          'raza': _petBreed,
        });
        _petName.clear();
        _petGender = null;
        _petBreed = null;
        _petAge.clear();
        _petCard.clear();
        _petFile = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
    }
  }

  void _registerPets() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Datos enviados'),
        content: const Text('El registro de mascotas se ha completado.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pageController.animateToPage(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              setState(() {
                _pets.clear();
              });
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black87, fontSize: 14),
      validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: (v) => v == null ? 'Seleccione una opción' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _styledButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            'https://c.files.bbci.co.uk/48DD/production/_107435681_perro1.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Container(
              width: 1000, // más ancho para campos dobles
              height: 650,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Panel izquierdo
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              'https://c.files.bbci.co.uk/48DD/production/_107435681_perro1.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Formulario Corporativo',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Gestión de Dueño y Mascota',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Panel derecho
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 30),
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Página 1 - Dueño
                          Form(
                            key: _formKeyOwner,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Dueño de Mascota',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _buildTextField(
                                              'Nombre', _ownerName)),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: _buildTextField(
                                              'Cédula', _ownerId)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _buildTextField(
                                              'Teléfono', _ownerPhone)),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: _buildTextField(
                                              'Correo electrónico',
                                              _ownerEmail)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTextField('Dirección', _ownerAddress),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _acceptTerms,
                                        onChanged: (value) {
                                          if (value == true && !_acceptTerms) {
                                            _showTermsModal();
                                          }
                                        },
                                        activeColor: Colors.blueAccent,
                                      ),
                                      const Text(
                                        'Aceptar Términos y Condiciones',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  _styledButton('Siguiente', () {
                                    if (_acceptTerms &&
                                        _formKeyOwner.currentState!
                                            .validate()) {
                                      _pageController.animateToPage(1,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut);
                                    }
                                  }),
                                ],
                              ),
                            ),
                          ),
                          // Página 2 - Mascota
                          Form(
                            key: _formKeyPet,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Registro Mascota',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _buildTextField(
                                              'Nombre Mascota', _petName)),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: _buildDropdownField(
                                              'Género',
                                              _petGender,
                                              ['Macho', 'Hembra'],
                                              (v) {
                                            setState(() => _petGender = v);
                                          })),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _buildDropdownField(
                                              'Raza',
                                              _petBreed,
                                              ['Perro', 'Gato', 'Ave'],
                                              (v) {
                                            setState(() => _petBreed = v);
                                          })),
                                      const SizedBox(width: 16),
                                      Expanded(
                                          child: _buildTextField(
                                              'Edad', _petAge)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                          child:
                                              _buildTextField('Carnet', _petCard)),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child:
                                            _styledButton('Subir Archivo', _pickFile),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  _styledButton('Agregar', _addPet),
                                  const SizedBox(height: 24),
                                  if (_pets.isNotEmpty)
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columns: const [
                                          DataColumn(label: Text('Nombre')),
                                          DataColumn(label: Text('Acciones')),
                                        ],
                                        rows: _pets
                                            .asMap()
                                            .entries
                                            .map((e) => DataRow(cells: [
                                                  DataCell(
                                                      Text(e.value['nombre'])),
                                                  DataCell(IconButton(
                                                    icon: const Icon(Icons.delete,
                                                        color: Colors.red),
                                                    onPressed: () {
                                                      setState(() =>
                                                          _pets.removeAt(e.key));
                                                    },
                                                  )),
                                                ]))
                                            .toList(),
                                      ),
                                    ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: _styledButton('Atrás', () {
                                        _pageController.animateToPage(0,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeInOut);
                                      })),
                                      const SizedBox(width: 20),
                                      Expanded(
                                          child: _styledButton(
                                              'Registrar', _registerPets)),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
/*
class _FormPageState extends State<FormPage> {
  final _pageController = PageController();
  final _formKeyOwner = GlobalKey<FormState>();
  final _formKeyPet = GlobalKey<FormState>();

  // Dueño
  final TextEditingController _ownerName = TextEditingController();
  final TextEditingController _ownerId = TextEditingController();
  final TextEditingController _ownerPhone = TextEditingController();
  final TextEditingController _ownerAddress = TextEditingController();
  final TextEditingController _ownerEmail = TextEditingController();
  bool _acceptTerms = false;

  // Mascota
  final TextEditingController _petName = TextEditingController();
  String? _petGender;
  String? _petBreed;
  final TextEditingController _petAge = TextEditingController();
  final TextEditingController _petCard = TextEditingController();
  File? _petFile;
  Uint8List? _petFileBytes;

  List<Map<String, dynamic>> _pets = [];

  @override
  void dispose() {
    _pageController.dispose();
    _ownerName.dispose();
    _ownerId.dispose();
    _ownerPhone.dispose();
    _ownerAddress.dispose();
    _ownerEmail.dispose();
    _petName.dispose();
    _petAge.dispose();
    _petCard.dispose();
    super.dispose();
  }

  void _showTermsModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Términos y Condiciones"),
        content: const Text("Aquí se muestran los términos y condiciones del servicio."),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _acceptTerms = true;
              });
              Navigator.pop(context);
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black87, fontSize: 14),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obligatorio';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Seleccione una opción' : null,
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        if (kIsWeb) {
          _petFileBytes = result.files.single.bytes;
        } else {
          _petFile = File(result.files.single.path!);
        }
      });
    }
  }

  void _addPet() {
    if (_formKeyPet.currentState!.validate()) {
      setState(() {
        _pets.add({
          'nombre': _petName.text,
          'genero': _petGender!,
          'raza': _petBreed!,
          'edad': _petAge.text,
          'carnet': _petCard.text,
          'archivo': kIsWeb ? _petFileBytes : _petFile,
        });

        // limpiar campos
        _petName.clear();
        _petAge.clear();
        _petCard.clear();
        _petGender = null;
        _petBreed = null;
        _petFile = null;
        _petFileBytes = null;
      });
    }
  }

  void _registerPets() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Registro"),
        content: const Text("Datos enviados exitosamente"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pageController.animateToPage(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            child: const Text("Atrás"),
          ),
        ],
      ),
    );
  }

  Widget _styledButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo oscuro con imagen
          Image.network(
            'https://c.files.bbci.co.uk/48DD/production/_107435681_perro1.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Container(
              width: 950,
              height: 650,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
              ),
              child: Row(
                children: [
                  // Imagen lateral
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              'https://c.files.bbci.co.uk/48DD/production/_107435681_perro1.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                              ),
                            ),
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Formulario Corporativo', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 8),
                                Text('Gestión de Dueño y Mascota', style: TextStyle(fontSize: 16, color: Colors.white70)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Formulario
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Página 1 - Dueño
                          Form(
                            key: _formKeyOwner,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Dueño de Mascota', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 20),
                                _buildTextField('Nombre', _ownerName),
                                const SizedBox(height: 16),
                                _buildTextField('Cédula', _ownerId),
                                const SizedBox(height: 16),
                                _buildTextField('Teléfono', _ownerPhone),
                                const SizedBox(height: 16),
                                _buildTextField('Dirección', _ownerAddress),
                                const SizedBox(height: 16),
                                _buildTextField('Correo electrónico', _ownerEmail),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _acceptTerms,
                                      onChanged: (value) { if(value == true && !_acceptTerms) _showTermsModal(); },
                                      activeColor: Colors.blueAccent,
                                    ),
                                    const Text('Aceptar Términos y Condiciones', style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                _styledButton('Siguiente', () {
                                  if(_acceptTerms && _formKeyOwner.currentState!.validate()){
                                    _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                                  }
                                }),
                              ],
                            ),
                          ),
                          // Página 2 - Mascota
                          Form(
                            key: _formKeyPet,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Registro Mascota', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 16),
                                  _buildTextField('Nombre Mascota', _petName),
                                  const SizedBox(height: 16),
                                  _buildDropdownField('Género', _petGender, ['Macho','Hembra'], (v){ setState(()=>_petGender=v); }),
                                  const SizedBox(height: 16),
                                  _buildDropdownField('Raza', _petBreed, ['Perro','Gato','Ave'], (v){ setState(()=>_petBreed=v); }),
                                  const SizedBox(height: 16),
                                  _buildTextField('Edad', _petAge),
                                  const SizedBox(height: 16),
                                  _buildTextField('Carnet', _petCard),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(child: _styledButton('Subir Archivo', _pickFile)),
                                      const SizedBox(width: 16),
                                      Text(_petFile != null ? 'Archivo seleccionado' : (_petFileBytes != null ? 'Archivo seleccionado' : '')),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  _styledButton('Agregar', _addPet),
                                  const SizedBox(height: 16),
                                  _pets.isNotEmpty
                                      ? SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            columns: const [
                                              DataColumn(label: Text('Nombre')),
                                              DataColumn(label: Text('Acciones')),
                                            ],
                                            rows: _pets.asMap().entries.map((e){
                                              final nombre = e.value['nombre'] ?? '';
                                              return DataRow(cells: [
                                                DataCell(Text(nombre)),
                                                DataCell(IconButton(
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () { setState(()=>_pets.removeAt(e.key)); },
                                                )),
                                              ]);
                                            }).toList(),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(child: _styledButton('Atrás', (){
                                        _pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                                      })),
                                      const SizedBox(width: 16),
                                      Expanded(child: _styledButton('Registrar', _registerPets)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/




/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/form_bloc.dart';
import '../bloc/form_event.dart';
import '../bloc/form_blocstate.dart'; // ahora es FormBlocState

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

 class _FormPageState extends State<FormPage> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();

  //Datos del Dueño de la Mascota
  final TextEditingController _nombreDuenoController = TextEditingController();
  final TextEditingController _cedulaDuenoController = TextEditingController();
  final TextEditingController _telefonoDuenoController = TextEditingController();
  final TextEditingController _direccionDuenoController = TextEditingController();
  final TextEditingController _correoElectronicoDuenoController = TextEditingController();


  //Datos de la Mascota
  final TextEditingController _nombreMascotaController = TextEditingController();
  final TextEditingController _generoMascotaController = TextEditingController();
  final TextEditingController _razaMascotaController = TextEditingController();
  final TextEditingController _edadMascotaController = TextEditingController();
  final TextEditingController _carnetMascotaController = TextEditingController();
  final TextEditingController _fotoMascotaController = TextEditingController();

  int _currentStep = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;


  @override
  void initState(){
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      );
    _fadeAnimation  = CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeInOut,
      );
      _controller.forward();

  }

  @override
  void dispose(){
    _controller.dispose();
    _nombreDuenoController.dispose();
    _telefonoDuenoController.dispose();
    _cedulaDuenoController.dispose();
    _correoElectronicoDuenoController.dispose();
    _direccionDuenoController.dispose();
    _nombreMascotaController.dispose();
    _generoMascotaController.dispose();
    _razaMascotaController.dispose();
    _edadMascotaController.dispose();
    _carnetMascotaController.dispose();
    _fotoMascotaController.dispose();
    super.dispose();
  }

  void _nextStep(){
    if(_currentStep < 1){
      setState(() {
        _currentStep ++;
      });
      _controller.forward(from:  0);
    }
  }

  void _previousStep(){
    if(_currentStep > 0){
      setState(() {
        _currentStep --;
      });
      _controller.forward(from: 0);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro Mascotas"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.orange],
              begin:  Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<FormBloc, FormBlocState>(
          listener: (context, state){
            if(state is FormSuccess){
              ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.mensaje)));
            }else if(state is FormError){
              ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Stepper(
                type: StepperType.vertical,
                currentStep: _currentStep,
                onStepContinue: _nextStep,
                onStepCancel: _previousStep,
                controlsBuilder: (context, details) {
                  return Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          backgroundColor: Colors.deepOrange,
                          shadowColor: Colors.black,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: details.onStepContinue,
                        child: const Text(
                          "Siguiente",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (_currentStep > 0)
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.deepOrange),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: details.onStepCancel,
                          child: const Text("Atrás"),
                        )
                    ],
                  );
                },
                steps: [
                  // Paso 1: Datos del dueño
                  Step(
                    title: const Text("Datos del Dueño"),
                    content: Column(
                      children: [
                        TextFormField(
                          controller: _nombreDuenoController,
                          decoration: InputDecoration(
                            labelText: "Nombre",
                            prefixIcon: const Icon(Icons.person, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cedulaDuenoController,
                          decoration: InputDecoration(
                            labelText: "Cedula",
                            prefixIcon: const Icon(Icons.email, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _telefonoDuenoController,
                          decoration: InputDecoration(
                            labelText: "Teléfono",
                            prefixIcon: const Icon(Icons.phone, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _direccionDuenoController,
                          decoration: InputDecoration(
                            labelText: "Direccion",
                            prefixIcon: const Icon(Icons.phone, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _correoElectronicoDuenoController,
                          decoration: InputDecoration(
                            labelText: "Correo electronico",
                            prefixIcon: const Icon(Icons.email, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                  ),

                  // Paso 2: Datos de la mascota
                  Step(
                    title: const Text("Datos de la Mascota"),
                    content: Column(
                      children: [
                        TextFormField(
                          controller: _nombreMascotaController,
                          decoration: InputDecoration(
                            labelText: "Nombre de la mascota",
                            prefixIcon: const Icon(Icons.pets, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _generoMascotaController,
                          decoration: InputDecoration(
                            labelText: "Genero",
                            prefixIcon: const Icon(Icons.category, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _razaMascotaController,
                          decoration: InputDecoration(
                            labelText: "Raza",
                            prefixIcon: const Icon(Icons.category, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _edadMascotaController,
                          decoration: InputDecoration(
                            labelText: "Edad",
                            prefixIcon: const Icon(Icons.info_outline, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _carnetMascotaController,
                          decoration: InputDecoration(
                            labelText: "Carnet",
                            prefixIcon: const Icon(Icons.category, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _fotoMascotaController,
                          decoration: InputDecoration(
                            labelText: "Foto",
                            prefixIcon: const Icon(Icons.category, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (state is FormLoading)
                          const CircularProgressIndicator()
                        else
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              backgroundColor: Colors.redAccent,
                              shadowColor: Colors.black,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              // Aquí se validaría si quieres
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Formulario listo para enviar")));
                            },
                            child: const Text(
                              "Finalizar",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    isActive: _currentStep >= 1,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
*/
 
/*
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Formulario con BLoC")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<FormBloc, FormBlocState>(
          listener: (context, state) {
            if (state is FormSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.mensaje)));
            } else if (state is FormError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: "Nombre"),
                    validator: (value) =>
                        value!.isEmpty ? "Ingrese su nombre" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) =>
                        value!.isEmpty ? "Ingrese su email" : null,
                  ),
                  const SizedBox(height: 20),
                  if (state is FormLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<FormBloc>().add(
                                EnviarFormulario(
                                  _nombreController.text,
                                  _emailController.text,
                                ),
                              );
                        }
                      },
                      child: const Text("Enviar"),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
*/