import 'package:http/http.dart' as http;
import 'dart:convert';

class FormRepository {
  final String baseUrl = "https://ottocare-api-g6bbdbezgngpcycm.chilecentral-01.azurewebsites.net/";

  Future<String> enviarDatos({
    required String nombre,
    required String apellido,
    required String cedula,
    required String celular,
    required String email,
    required String ciudad,
    required List<Map<String, dynamic>> mascotas,
  }) async {
    final url = Uri.parse("$baseUrl/clients/");

    // Construir JSON dinámico
    final jsonData = {
      "first_name": nombre.split(" ").first,
      "last_name": apellido,
      "identification": cedula,
      "phone_number": celular,
      "email": email,
      "address": {
        "home_address": ciudad,
        "postal_code": "1122" // si quieres dinámico, agregar campo ciudad
      },
      "pets": mascotas.map((pet) {
        return {
          "first_name": pet['nombre'],
          "gender": {"gender": pet['gender'] ?? "M"},
          "client_type": {
            "name": pet['species'] ?? "dog",
            "breed": {"name": pet['raza'] ?? ""},
            "color": pet['color'] ?? "",
            "physical_defect": pet['defect'] ?? "La mascota no tiene defectos",
          },
          "birth_date": pet['birth_date'] != null
              ? (pet['birth_date'] is DateTime
                  ? (pet['birth_date'] as DateTime).toIso8601String()
                  : pet['birth_date'])
              : null,
          "identification": pet['carnet'] ?? "",
        };
      }).toList(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data["mensaje"] ?? "Datos enviados correctamente";
      } else {
        throw Exception("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Error al enviar datos: $e");
    }
  }
}
/*
class _FormPageState extends State<FormPage> {
  //final _pageController = PageController();
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


  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }


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
    _pageController.dispose();

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
  // === NUEVO: función toast flotante (verde/rojo) ===
  void _showToast(String message,
      {bool isError = false, String? actionLabel, VoidCallback? onAction}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.yellowAccent,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }
  // REEMPLAZA _showPetRecordsModal()
void _showPetRecordsModal() {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Registros de Mascotas"),
            content: SizedBox(
              width: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Género')),
                    DataColumn(label: Text('Raza')),
                    DataColumn(label: Text('Edad')),
                    DataColumn(label: Text('Carnet')),
                    DataColumn(label: Text('Archivo')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: _pets.asMap().entries.map((entry) {
                    final i = entry.key;
                    final pet = entry.value;
                    return DataRow(cells: [
                      DataCell(Text(pet['nombre'] ?? '')),
                      DataCell(Text(pet['genero'] ?? '')),
                      DataCell(Text(pet['raza'] ?? '')),
                      DataCell(Text(pet['edad'] ?? '')),
                      DataCell(Text(pet['carnet'] ?? '')),
                      DataCell(Text(pet['archivo'] ?? '')),
                      DataCell(IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() => _pets.removeAt(i));
                          setStateDialog(() {}); // rebuild del dialog
                        },
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            actions: [
              SizedBox(
                width: 140,
                child: _styledButton('Cerrar', () => Navigator.pop(context), icon: Icons.close, color: Colors.grey),
              ),
            ],
          );
        },
      );
    },
  );
}

 // === NUEVO ===
    Future<void> _pickFile() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null && result.files.single.path != null) {
          setState(() {
            _petFile = File(result.files.single.path!);
          });
          _showToast("Archivo subido correctamente");
        } else {
          _showToast("No se seleccionó archivo", isError: true);
        }
      } catch (e) {
        _showToast("Error al subir archivo", isError: true);
      }
    }
    // === FIN NUEVO ===
  // === NUEVO ===
 void _addPet() {
  if (_formKeyPet.currentState!.validate() &&
      _petGender != null &&
      _petBreed != null) {
    setState(() {
      _pets.add({
        'nombre': _petName.text,
        'genero': _petGender,
        'raza': _petBreed,
        'edad': _petAge.text,
        'carnet': _petCard.text,
        'archivo': _petFile != null ? _petFile!.path.split('/').last : '',
      });
      _petName.clear();
      _petGender = null;
      _petBreed = null;
      _petAge.clear();
      _petCard.clear();
      _petFile = null;
    });
    // sólo un toast de confirmación — no abrimos tabla aquí
    _showToast('Mascota agregada');
  } else {
    _showToast('Complete todos los campos', isError: true);
  }
}


// REEMPLAZA _registerPets()
void _registerPets() {
  if (_pets.isEmpty) {
    _showToast("No hay mascotas para registrar", isError: true);
    return;
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Confirmar registros'),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicWidth(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Género')),
                        DataColumn(label: Text('Raza')),
                        DataColumn(label: Text('Edad')),
                        DataColumn(label: Text('Carnet')),
                        DataColumn(label: Text('Archivo')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: _pets.asMap().entries.map((entry) {
                        final i = entry.key;
                        final pet = entry.value;
                        return DataRow(cells: [
                          DataCell(Text(pet['nombre'] ?? '')),
                          DataCell(Text(pet['genero'] ?? '')),
                          DataCell(Text(pet['raza'] ?? '')),
                          DataCell(Text(pet['edad'] ?? '')),
                          DataCell(Text(pet['carnet'] ?? '')),
                          DataCell(Text(pet['archivo'] ?? '')),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() => _pets.removeAt(i));
                              setStateDialog(() {}); // rebuild del diálogo
                            },
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              SizedBox(
                width: 140,
                child: _styledButton('Cancelar', () => Navigator.pop(context), icon: Icons.close, color: Colors.grey),
              ),
              SizedBox(width: 12),
              SizedBox(
                width: 140,
                child: _styledButton('Guardar', () {
                  try {
                    // lógica real de guardado iría aquí
                    _showToast('Datos registrados correctamente');
                    Navigator.pop(context);
                    _pageController.animateToPage(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                    setState(() {
                      _pets.clear();
                    });
                  } catch (e) {
                    _showToast('Error al guardar los datos', isError: true);
                  }
                }, icon: Icons.save, color: Colors.green),
              ),
            ],
          );
        },
      );
    },
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
      width: 800,
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


  Widget _styledButton2(String text, VoidCallback onPressed,
      {IconData? icon, Color? color}) {
    return SizedBox(
      width: 154,
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
            child: LayoutBuilder(builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;
            final isMobile = screenWidth < 800;

            Widget twoFieldRow(Widget left, Widget right) {
              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    left,
                    const SizedBox(height: 12),
                    right,
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(child: left),
                    const SizedBox(width: 16),
                    Expanded(child: right),
                  ],
                );
              }
            }

            return Container(
              width: isMobile ? double.infinity : 1100,
              height: isMobile ? MediaQuery.of(context).size.height * 0.9 : 700,
              margin: isMobile ? const EdgeInsets.all(12) : null,
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
              child: isMobile
                ? Column(
                    children: [
                      // Imagen superior
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            'https://c.files.bbci.co.uk/48DD/production/_107435681_perro1.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // PageView expandido
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            // Página 1 - Dueño
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: _formKeyOwner,
                                child: Column(
                                  children: [
                                    const Text('Dueño de Mascota',
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 20),
                                    twoFieldRow(
                                      _buildTextField('Nombre', _ownerName, icon: Icons.person),
                                      _buildTextField('Cédula', _ownerId, icon: Icons.credit_card),
                                    ),
                                    const SizedBox(height: 12),
                                    twoFieldRow(
                                      _buildTextField('Teléfono', _ownerPhone, icon: Icons.phone),
                                      _buildTextField('Correo electrónico', _ownerEmail, icon: Icons.email),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildTextField('Dirección', _ownerAddress, icon: Icons.home),
                                    const SizedBox(height: 24),
                                      _styledButton('Siguiente', () {
                                      _pageController.animateToPage(
                                        1,
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }, icon: Icons.arrow_forward),
                                  ],
                                ),
                              ),
                            ),
                            // Página 2 - Mascota
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: _formKeyPet,
                                child: Column(
                                  children: [
                                    const Text('Datos de la Mascota',
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 20),
                                    twoFieldRow(
                                      _buildTextField('Nombre Mascota', _petName, icon: Icons.pets),
                                      _buildDropdownField('Género', _petGender,
                                          ['Macho', 'Hembra'], (v) => setState(() => _petGender = v), Icons.wc),
                                    ),
                                    const SizedBox(height: 12),
                                    twoFieldRow(
                                      _buildDropdownField('Raza', _petBreed,
                                          ['Perro', 'Gato', 'Ave'], (v) => setState(() => _petBreed = v), Icons.category),
                                      _buildTextField('Edad', _petAge, icon: Icons.cake),
                                    ),
                                    const SizedBox(height: 12),
                                    twoFieldRow(
                                      _buildTextField('Carnet', _petCard, icon: Icons.badge),
                                      _styledButton('Subir Archivo', _pickFile,
                                          icon: Icons.upload_file, color: Colors.amber),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _acceptTerms,
                                          onChanged: (value) {
                                            if (value == true && !_acceptTerms) {
                                              _showTermsModal();
                                            } else {
                                              setState(() {
                                                _acceptTerms = value ?? false;
                                              });
                                            }
                                          },
                                          activeColor: Colors.blueAccent,
                                        ),
                                        const Text('Aceptar Términos', style: TextStyle(fontSize: 13)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    _styledButton('Agregar', _addPet, icon: Icons.add, color: Colors.blue),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.arrow_back, size: 32, color: Colors.blueAccent),
                                          onPressed: () {
                                            _pageController.animateToPage(0,
                                                duration: const Duration(milliseconds: 500),
                                                curve: Curves.easeInOut);
                                          },
                                        ),
                                        const Spacer(),
                                        _styledButton2('Registrar', _registerPets, icon: Icons.check, color: Colors.green),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )

                    : Row(
                        children: [
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
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                              child: PageView(
                                controller: _pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
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
                                                Expanded(child: _buildTextField('Nombre', _ownerName, icon: Icons.person)),
                                                const SizedBox(width: 16),
                                                Expanded(child: _buildTextField('Cédula', _ownerId, icon: Icons.credit_card)),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Expanded(child: _buildTextField('Teléfono', _ownerPhone, icon: Icons.phone)),
                                                const SizedBox(width: 16),
                                                Expanded(child: _buildTextField('Correo electrónico', _ownerEmail, icon: Icons.email)),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            _buildTextField('Dirección', _ownerAddress, icon: Icons.home),
                                            const SizedBox(height: 16),
                                            const SizedBox.shrink(),
                                            const SizedBox(height: 24),
                                            _styledButton('Siguiente', () {
                                              _pageController.animateToPage(
                                                1,
                                                duration: const Duration(milliseconds: 500),
                                                curve: Curves.easeInOut,
                                              );
                                            }, icon: Icons.arrow_forward),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: SingleChildScrollView(
                                      child: Form(
                                        key: _formKeyPet,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 40),
                                            const Text('Datos de la Mascota',
                                                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Expanded(child: _buildTextField('Nombre Mascota', _petName, icon: Icons.pets)),
                                                const SizedBox(width: 16),
                                                Expanded(child: _buildDropdownField('Género', _petGender,
                                                    ['Macho', 'Hembra'], (v) => setState(() => _petGender = v), Icons.wc)),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Expanded(child: _buildDropdownField('Raza', _petBreed,
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
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: _acceptTerms,
                                                  onChanged: (value) {
                                                    if (value == true && !_acceptTerms) {
                                                      _showTermsModal();
                                                    } else {
                                                      setState(() {
                                                        _acceptTerms = value ?? false;
                                                      });
                                                    }
                                                 },
                                                  activeColor: Colors.blueAccent,
                                                ),
                                                const Text('Aceptar Términos y Condiciones', style: TextStyle(fontSize: 13)),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            const SizedBox.shrink(),
                                            const SizedBox(height: 24),
                                            _styledButton('Agregar', _addPet, icon: Icons.add, color: Colors.blue),
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
              );
            }),
          ),
        ],
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
