import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/form_bloc.dart';
import '../bloc/form_event.dart';
import '../bloc/form_blocstate.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert'; // Para json.encode
import 'package:http/http.dart' as http; // Para http.post
import '../repository/form_repository.dart';
import 'package:flutter/services.dart'; // Para FilteringTextInputFormatter
import 'Succes_page.dart';
import 'package:lottie/lottie.dart';
import 'Error_page.dart';
import 'package:url_launcher/url_launcher.dart';

class FormPage extends StatefulWidget {
  final int idContrato;
  //NUEVO PARAMETRO

  const FormPage({super.key, required this.idContrato});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _ownerNameCtrl = TextEditingController();
  final TextEditingController _ownerLastNameCtrl = TextEditingController();
  final TextEditingController _idCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final FormRepository _formRepository = FormRepository();
  final TextEditingController _petNameCtrl = TextEditingController();
  final TextEditingController _petGenderCtrl = TextEditingController();
  final TextEditingController _petBreedCtrl = TextEditingController();
  final TextEditingController _petSpeciesCtrl = TextEditingController();
  final TextEditingController _petColorCtrl = TextEditingController();
  final TextEditingController _ageDayCtrl = TextEditingController();
  final TextEditingController _ageMonthCtrl = TextEditingController();
  final TextEditingController _ageYearCtrl = TextEditingController();
  final TextEditingController _birthDateCtrl = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final _emailFocus = FocusNode();
  final List<String> _genders = ['Hembra', 'Macho'];
  final List<String> _species = ['Perro', 'Gato'];
  final Map<String, List<String>> _breeds = {
    'Perro': [
      'Mestizo',
      'Affenpinscher',
      'Airedale Terrier',
      'Akita',
      'Akita americano',
      'Alano español',
      'Alaskan Husky',
      'Alaska malamute',
      'American Foxhound',
      'American pit bull terrier',
      'American stanfforshire terrier',
      'Ariegeois',
      'Artois',
      'Australian silky terrier',
      'Australian terrier',
      'Austrian Black & Tan Hound',
      'Azawakh',
      'Balkan Hound',
      'Basenji',
      'Basset Alpino (Alpine Dachsbracke)',
      'Basset Artesiano Normando',
      'Basset Azul de Gascuña (Basset Bleu de Gascogne)',
      'Basset de Artois',
      'Basset de Westphalie',
      'Basset Hound',
      'Basset Leonado de Bretaña (Basset fauve de Bretagne)',
      'Bavarian Mountain Scenthound',
      'Beagle',
      'Beagle Harrier',
      'Beauceron',
      'Bedlington Terrier',
      'Bichón boloñés',
      'Bichón frisé',
      'Bichón habanero',
      'Bichón maltés',
      'Billy',
      'Black and Tan Coonhound',
      'Bloodhound (Sabueso de San Huberto)',
      'Bobtail',
      'Boerboel',
      'Border Collie',
      'Border Terrier',
      'Borzoi',
      'Bosnian Hound',
      'Boston Terrier',
      'Bouvier des Flandres',
      'Boxer',
      'Boyero de Appenzell',
      'Boyero australiano',
      'Boyero de Entlebuch',
      'Boyero de las Ardenas',
      'Boyero de Montaña Bernes',
      'Braco Alemán de pelo corto',
      'Braco Alemán de pelo duro',
      'Braco de Ariege',
      'Braco de Auvernia',
      'Braco de Bourbonnais',
      'Braco de Saint Germain',
      'Braco Dupuy',
      'Braco Francés',
      'Braco Italiano',
      'Broholmer',
      'Buhund Noruego',
      'Bull terrier',
      'Bulldog',
      'Bulldog americano',
      'Bulldog francés',
      'Bullmastiff',
      'Ca de Bestiar',
      'Cairn terrier',
      'Cane Corso',
      'Cane da Pastore Maremmano-Abruzzese',
      'Caniche',
      'Cao da Serra de Aires',
      'Cao da Serra de Estrela',
      'Cao de Castro Laboreiro',
      'Cao de Fila de Sao Miguel',
      'Cavalier King Charles Spaniel',
      'Cesky Fousek',
      'Ceský teriér',
      'Chesapeake Bay Retriever',
      'Chihuahua',
      'Chin',
      'Chow Chow',
      'Cirneco del Etna',
      'Clumber Spaniel',
      'Cocker Spaniel Americano',
      'Cocker Spaniel Inglés',
      'Collie Barbudo',
      'Collie pelo corto',
      'Coton de Tuléar',
      'Curly Coated Retriever',
      'Dálmata',
      'Dandie dinmont terrier',
      'Deerhound',
      'Dobermann',
      'Dogo Argentino',
      'Dogo de Burdeos',
      'Dogo del Tibet',
      'Drentse Partridge Dog',
      'Drever',
      'Dunker',
      'Elkhound Noruego',
      'Elkhound Sueco',
      'English Foxhound',
      'English Springer Spaniel',
      'English toy terrier',
      'Epagneul Picard',
      'Eurasier',
      'Fila Brasileiro',
      'Finnish Lapphound',
      'Flat Coated Retriever',
      'Fox terrier de pelo de alambre',
      'Fox terrier de pelo liso',
      'Foxhound Inglés',
      'Frisian Pointer',
      'Galgo español',
      'Galgo húngaro (Magyar Agar)',
      'Galgo Italiano',
      'Galgo Polaco (Chart Polski)',
      'Glen of Imaal Terrier',
      'Golden Retriever',
      'Gordon Setter',
      'Gos dAtura Catalá',
      'Gran Basset Griffon Vendeano',
      'Gran Boyero Suizo',
      'Gran Danés (Dogo Aleman)',
      'Gran Gascón Saintongeois',
      'Gran Griffon Vendeano',
      'Gran Munsterlander',
      'Gran Perro Japonés',
      'Grand Anglo Francais Tricoleur',
      'Grand Bleu de Gascogne',
      'Greyhound',
      'Griffon Bleu de Gascogne',
      'Griffon de pelo duro (Grifón Korthals)',
      'Griffon leonado de Bretaña',
      'Griffon Nivernais',
      'Grifón belga',
      'Grifón de Bruselas',
      'Haldenstoever',
      'Harrier',
      'Hokkaido',
      'Hovawart',
      'Husky siberiano',
      'Ioujnorousskaia Ovtcharka',
      'Irish Glen of Imaal terrier',
      'Irish soft coated wheaten terrier',
      'Irish terrier',
      'Irish Water Spaniel',
      'Irish wolfhound',
      'Jack Russell terrier',
      'Jindo Coreano',
      'Klee klai alaskan',
      'Keeshond',
      'Kelpie Australiano (Australian Kelpie)',
      'Kerry blue terrier',
      'King Charles Spaniel',
      'Kishu',
      'Komondor',
      'Kooiker',
      'Kromfohrländer',
      'Kuvasz',
      'Labrador Retriever',
      'Lagotto Romagnolo',
      'Yorkshire terrier'
    ],

    'Gato': [
      'Mestizo',
      'Abisinio',
      'Africano doméstico',
      'American Curl',
      'American shorthair',
      'American wirehair',
      'Angora turco',
      'Aphrodite-s Giants',
      'Australian Mist',
      'Azul ruso',
      'Bengala',
      'Bobtail japonés',
      'Bombay',
      'Bosque de Noruega',
      'Brazilian Shorthair',
      'British Shorthair',
      'Burmés',
      'Burmilla',
      'California Spangled',
      'Ceylon',
      'Chartreux',
      'Cornish rex',
      'Cymric',
      'Deutsch Langhaar',
      'Devon rex',
      'Don Sphynx',
      'Dorado africano',
      'Europeo común',
      'Gato exótico',
      'German Rex',
      'Habana brown',
      'Himalayo',
      'Khao Manee',
      'Korat',
      'Maine Coon',
      'Manx',
      'Mau egipcio',
      'Munchkin',
      'Ocicat',
      'Ojos azules',
      'Oriental',
      'Oriental de pelo largo',
      'Persa',
      'Peterbald',
      'Pixi Bob',
      'Ragdoll',
      'Sagrado de Birmania',
      'Scottish Fold',
      'Selkirk rex',
      'Serengeti',
      'Seychellois',
      'Siamés',
      'Siamés Moderno',
      'Siamés Tradicional',
      'Siberiano',
      'Snowshoe',
      'Sphynx',
      'Tonkinés',
      'Van Turco'
    ]
  };

  String? _selectedGender;
  String? _selectedSpecies;
  String? _selectedBreed;
  bool? _hasCarnet;
  TextEditingController _petCarnetCtrl = TextEditingController();
  DateTime? _selectedBirthDate;
  List<Map<String, String>> _mascotas = [];
  bool? _hasDefect;
  TextEditingController _defectCtrl = TextEditingController();
  String? _emailError;
  Uint8List? _photoBytes;
  String? _photoFileName;
  File? _photoFile;
  bool _acceptData = false;

  @override
  void dispose() {
    _ownerNameCtrl.dispose();
    _ownerLastNameCtrl.dispose();
    _idCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _cityCtrl.dispose();

    _petNameCtrl.dispose();
    _petGenderCtrl.dispose();
    _petBreedCtrl.dispose();
    _petSpeciesCtrl.dispose();
    _petColorCtrl.dispose();
    _petCarnetCtrl.dispose();

    _ageDayCtrl.dispose();
    _ageMonthCtrl.dispose();
    _ageYearCtrl.dispose();

    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // útil en Web
    );

    if (result != null) {
      setState(() {
        if (result.files.single.bytes != null) {
          // Web o móvil
          _photoBytes = result.files.single.bytes;
          _photoFileName = result.files.single.name;
        } else if (result.files.single.path != null) {
          // Escritorio / móvil con path real
          _photoFile = File(result.files.single.path!);
          _photoFileName = result.files.single.name;
        }
      });

      // 👉 Mostrar SnackBar tipo "toast"
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ La foto ha sido cargada'),
          backgroundColor: Colors.green[600],
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating, // flota como toast
          margin: const EdgeInsets.all(16),   // pequeño margen
        ),
      );
    }
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Color(0xFF0A5970), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
    );
  }

// Función para construir JSON
  Map<String, dynamic> buildRequestJson() {
    return {
      "first_name": _ownerNameCtrl.text
          .split(' ')
          .first,
      "last_name": _ownerLastNameCtrl.text.split(' ').skip(1).join(' '),
      "identification": _idCtrl.text,
      "phone_number": _phoneCtrl.text,
      "email": _emailCtrl.text,
      "address": {
        "home_address": _cityCtrl.text,
        "postal_code": "1122", // si quieres dinámico, reemplazar
      },
      "contract_id": widget.idContrato.toString(),
      "pets": _mascotas.map((pet) {
        return {
          "first_name": pet['nombre'],
          "gender": {
            "gender": pet['gender'] ?? _selectedGender
          },
          "client_type": {
            "name": pet['species'] ?? _selectedSpecies,
            "breed": {"name": pet['raza'] ?? ""},
            "color": pet['color'] ?? _petColorCtrl.text,
            "physical_defect": _hasDefect == true
                ? _defectCtrl.text // toma el valor del textarea
                : "La mascota no tiene defectos",
          },
          "birth_date": pet['birth_date'] != null &&
              pet['birth_date'] is DateTime
              ? (pet['birth_date'] as DateTime).toIso8601String()
              : null, // ISO completo: 2020-12-31T00:00:00
          'carnet': _hasCarnet == false
              ? "No tendrá cobertura hasta que tenga carnet"
              : _petCarnetCtrl.text,
        };
      }).toList(),
    };
  }

  // Función para enviar datos
  Future<void> sendForm() async {
    final url = Uri.parse('TU_ENDPOINT_AQUI');

    final jsonData = buildRequestJson();

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(jsonData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Datos enviados correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //fubncion par dirigir url
  Future<void> _abrirEnlace() async {
    final Uri url = Uri.parse("https://www.ecuasanitas.com/");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir $url');
    }
  }

  String _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();

    int years = today.year - birthDate.year;
    int months = today.month - birthDate.month;
    int days = today.day - birthDate.day;

    if (days < 0) {
      final prevMonth = DateTime(today.year, today.month, 0); // último día del mes anterior
      days += prevMonth.day;
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    return "$years años $months meses $days días";
  }

  Widget buildMascotasDialog(BuildContext context, double width) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Mascotas Registradas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Especie')),
                  DataColumn(label: Text('Raza')),
                  DataColumn(label: Text('Carnet')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: _mascotas
                    .map(
                      (m) =>
                      DataRow(cells: [
                        DataCell(Text(m['nombre']!)),
                        DataCell(Text(m['specie']!)),
                        DataCell(Text(m['raza']!)),
                        DataCell(Text(m['carnet']!)),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _mascotas.remove(m);
                              });
                              // cerrar y reabrir modal para refrescar DataTable
                              Navigator.of(context).pop();
                              Future.delayed(Duration.zero, () {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      buildMascotasDialog(context, width),
                                );
                              });
                            },
                          ),
                        ),
                      ]),
                )
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    // Validaciones antes de cerrar el modal
                    if (!_acceptData) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Debes aceptar los términos y condiciones'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (_formKey.currentState?.validate() != true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Completa todos los campos obligatorios'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (_mascotas.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Debes agregar al menos una mascota'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Cerrar el modal
                    Navigator.of(context).pop();

                    if (_photoBytes == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Debes subir una foto'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          Center(
                            child: Lottie.asset(
                              'lib/ui/animation/Animacion_de_carga.json',
                              width: 200, // Ajusta tamaño
                              height: 200, // Ajusta tamaño
                              fit: BoxFit.contain,
                            ),
                          ),
                    );
                    String? imageBase64;
                    if (_photoBytes != null) {
                      // Caso Web (bytes)
                      imageBase64 = base64Encode(_photoBytes!);
                    } else if (_photoFile != null) {
                      // Caso Android/iOS/Escritorio (File con path)
                      final bytes = await _photoFile!.readAsBytes();
                      imageBase64 = base64Encode(bytes);
                    }

                    try {
                      // Enviar datos al backend
                      final data = await _formRepository.enviarDatos(
                        nombre: _ownerNameCtrl.text,
                        apellido: _ownerLastNameCtrl.text,
                        cedula: _idCtrl.text,
                        celular: _phoneCtrl.text,
                        email: _emailCtrl.text,
                        ciudad: _cityCtrl.text,
                        contractId: widget.idContrato.toString(),
                        mascotas: _mascotas,
                      );

                      Navigator.of(context).pop(); // cerrar loader

                      if (data["status"] == "success") {
                        final bool esAfiliado = data["data"]["statusTitular"] == true;

                        if (esAfiliado) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SuccessPage(
                                imageBase64: data["data"]["email_base64"] ?? "",
                              ),
                            ),
                          );
                        } else {
                          mostrarErrorPopup(context, data["data"]["message_coberage"] ?? "Error desconocido");                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(data["message"] ?? "Error en la validación"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      // Limpiar formulario
                      _limpiarFormularios();
                    } catch (e) {
                      // Cerrar indicador de carga en caso de error
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ErrorPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF074B5E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _limpiarFormularios() {
    setState(() {
      _formKey.currentState?.reset();
      _mascotas.clear();
      _ownerNameCtrl.clear();
      _ownerLastNameCtrl.clear();
      _idCtrl.clear();
      _phoneCtrl.clear();
      _emailCtrl.clear();
      _cityCtrl.clear();
      _petNameCtrl.clear();
      _selectedSpecies = null;
      _selectedBreed = null;
      _birthDateCtrl.clear();
      _petColorCtrl.clear();
      _petCarnetCtrl.clear();
      _photoFile = null;
      _acceptData = false;
      //_phoneFocusNode.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;
    final bool isTablet = size.width >= 600 && size.width < 1024;
    final bool isDesktop = size.width >= 1024;

    if (isTablet) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView( // scroll global
          child: Center(
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    double containerWidth = size.width * 0.9;
                    return Image.asset(
                      "lib/ui/img/vistaEscritorio.jpg",
                      width: containerWidth,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),

                const SizedBox(height: 16),
                Container(
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: _buildFormContainer(false),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: size.width * 0.9,
          height: isMobile ? null : size.height * 0.85,
          constraints: isMobile
              ? const BoxConstraints()
              : BoxConstraints(maxHeight: size.height * 0.85),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: isMobile
              ? Column(
            children: [
              _responsiveImage("lib/ui/img/vista_movil.png", size.width),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildFormContainer(isMobile),
                ),
              ),
            ],
          )
              : Row(
            children: [
              Expanded(
                flex: 2,
                child: _responsiveImage("lib/ui/img/vistaEscritorio.jpg", size.width),
              ),
              Expanded(
                flex: 2,
                child: _buildFormContainer(isMobile),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _responsiveImage(String path, double screenWidth) {
    double maxWidth;

    if (screenWidth < 600) {
      maxWidth = screenWidth;
    } else if (screenWidth >= 600 && screenWidth < 1024) {
      maxWidth = screenWidth;
    } else {
      maxWidth = 800;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Image.asset(
          path,
          fit: BoxFit.fitWidth,
          width: double.infinity,
        ),
      ),
    );
  }
  Widget _buildFormContainer(bool isMobile) {

    final formContent = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: Center(
                child: Text(
                  'Datos Dueño de la Mascota',
                  style: const TextStyle(
                    color: Color(0xFF074B5E),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            _rowLabelFieldResponsive(
              'Nombre dueño de la mascota',
              TextFormField(
                controller: _ownerNameCtrl,
                decoration: _fieldDecoration('Nombre'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Obligatorio';
                  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(v))
                    return 'Solo letras permitidas';
                  return null;
                },
              ),
              isMobile,
            ),

            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'Apellido del dueño de la mascota',
              TextFormField(
                controller: _ownerLastNameCtrl,
                decoration: _fieldDecoration('Apellido'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Obligatorio';
                  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(v))
                    return 'Solo letras permitidas';
                  return null;
                },
              ),
              isMobile,
            ),

            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'Cédula del titular',
              TextFormField(
                controller: _idCtrl,
                decoration: _fieldDecoration('Cédula'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo obligatorio';
                  if (!RegExp(r'^\d+$').hasMatch(v)) return 'Solo números permitidos';
                  if (v.length != 10) return 'Debe tener 10 dígitos';
                  return null;
                },
              ),
              isMobile,
            ),

            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'Celular',
              TextFormField(
                controller: _phoneCtrl,
                decoration: _fieldDecoration('Celular'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo obligatorio';
                  if (!RegExp(r'^\d+$').hasMatch(v)) return 'Solo números permitidos';
                  if (v.length != 10) return 'Debe tener 10 dígitos';
                  return null;
                },
              ),
              isMobile,
            ),

            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'E-mail',
              TextFormField(
                controller: _emailCtrl,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                decoration: _fieldDecoration('Correo Electrónico').copyWith(
                  errorText: _emailError,
                ),
              ),
              isMobile,
            ),

            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'Ciudad',
              TextFormField(
                controller: _cityCtrl,
                decoration: _fieldDecoration('Ciudad'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo obligatorio';
                  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(v))
                    return 'Solo letras permitidas';
                  return null;
                },
              ),
              isMobile,
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: Center(
                child: Text(
                  'Datos de la Mascota',
                  style: const TextStyle(
                    color: Color(0xFF074B5E),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (_mascotas.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Especie')),
                        DataColumn(label: Text('Raza')),
                        DataColumn(label: Text('Color')),
                        DataColumn(label: Text('Carnet')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: _mascotas.map((m) {
                        return DataRow(cells: [
                          DataCell(Text(m['nombre']!)),
                          DataCell(Text(m['species']!)),
                          DataCell(Text(m['raza']!)),
                          DataCell(Text(m['color']!)),
                          DataCell(Text(m['carnet']!)),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _mascotas.remove(m);
                                });
                              },
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'Nombre de la mascota',
              TextFormField(
                controller: _petNameCtrl,
                decoration: _fieldDecoration('Nombre de la Mascota'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo obligatorio';
                  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(v)) return 'Solo letras permitidas';
                  return null;
                },
              ),
              isMobile,
            ),
            const SizedBox(height: 12),


            _rowLabelFieldResponsive(
              'Género',
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: _fieldDecoration(
                    'Seleccione'),
                items: _genders
                    .map((gender) =>
                    DropdownMenuItem(value: gender,
                        child: Text(gender)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
              ),
              isMobile,
            ),
            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'Especie',
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                decoration: _fieldDecoration(
                    'Seleccione'),
                items: _species
                    .map((specie) =>
                    DropdownMenuItem(
                        value: specie,
                        child: Text(specie)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSpecies = value;
                    _selectedBreed = null;
                  });
                },
                validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
              ),
              isMobile,
            ),
            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'Raza',
              DropdownButtonFormField<String>(
                value: _selectedBreed,
                decoration: _fieldDecoration(
                    'Seleccione'),
                items: (_selectedSpecies != null
                    ? _breeds[_selectedSpecies!] ??
                    <String>[]
                    : <String>[])
                    .map((breed) =>
                    DropdownMenuItem(
                        value: breed,
                        child: Text(breed)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBreed = value;
                  });
                },
                validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
              ),
              isMobile,
            ),
            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'Fecha de nacimiento',
              Builder(
                builder: (context) {
                  return TextFormField(
                    controller: _birthDateCtrl,
                    readOnly: true,
                    decoration: _fieldDecoration('Selecciona fecha'),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        locale: const Locale('es', 'ES'),
                      );

                      if (pickedDate != null) {
                        final today = DateTime.now();
                        final ageInMonths = (today.year - pickedDate.year) * 12 + (today.month - pickedDate.month);

                        // Validación: mínimo 6 meses (0.5 años) y máximo 10 años (120 meses)
                        if (ageInMonths < 6 || ageInMonths > 120) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Queremos cuidar a tu mascota en el momento adecuado de su vida. '
                                    'Solo podemos registrar mascotas entre 6 meses y 10 años cumplidos.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _selectedBirthDate = pickedDate;
                          _birthDateCtrl.text = "${pickedDate.day.toString().padLeft(2, '0')}/"
                              "${pickedDate.month.toString().padLeft(2, '0')}/"
                              "${pickedDate.year} | ${_calculateAge(pickedDate)}";
                        });
                      }
                    },

                    validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                  );
                },
              ),
              isMobile,
            ),


            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'Color',
              TextFormField(
                controller: _petColorCtrl,
                decoration: _fieldDecoration('Coloque el color de su Mascota'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Campo obligatorio';
                  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(v)) return 'Solo letras permitidas';
                  return null;
                },
              ),
              isMobile,
            ),
            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'La mascota tiene algún defecto físico o enfermedad?',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _hasDefect == null ? null : (_hasDefect! ? 'Sí' : 'No'),
                    decoration: _fieldDecoration('Seleccione'),
                    items: ['Sí', 'No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      setState(() {
                        _hasDefect = (val == 'Sí');
                        if (_hasDefect == false) _defectCtrl.clear();
                      });
                    },
                    validator: (v) => (v == null || v.isEmpty) ? 'Selecciona una opción' : null,
                  ),
                  if (_hasDefect == true) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _defectCtrl,
                      maxLines: 4,
                      decoration: _fieldDecoration('Especifique el defecto o enfermedad'),
                      validator: (v) {
                        if (_hasDefect == true && (v == null || v.isEmpty)) return 'Campo obligatorio';
                        return null;
                      },
                    ),
                  ],
                ],
              ),
              isMobile,
              maxLines: 4,
            ),

            const SizedBox(height: 12),

            _rowLabelFieldResponsive(
              'Carnet',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _hasCarnet == null ? null : (_hasCarnet! ? 'Sí' : 'No'),
                    decoration: _fieldDecoration('Seleccione'),
                    items: ['Sí', 'No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      setState(() {
                        _hasCarnet = (val == 'Sí');
                        if (_hasCarnet != true) _petCarnetCtrl.clear();
                      });
                    },
                    validator: (v) => (v == null || v.isEmpty) ? 'Selecciona una opción' : null,
                  ),
                  if (_hasCarnet == true) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _petCarnetCtrl,
                      decoration: _fieldDecoration('Digite el número de carnet'),
                      validator: (v) {
                        if (_hasCarnet == true && (v == null || v.isEmpty)) return 'Campo obligatorio';
                        return null;
                      },
                    ),
                  ] else if (_hasCarnet == false) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        "Las asistencias no serán entregadas hasta que cuente con carnet actualizado",
                        style: TextStyle(color: Colors.red[700], fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ],
              ),
              isMobile,
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            _rowLabelFieldResponsive(
              'Foto',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Subir foto'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),

                    ),
                  ),
                  if (_photoFile != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Archivo: ${_photoFile!.path.split('/').last}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
              isMobile,
            ),

            if (_photoFile != null)
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Archivo: ${_photoFile!
                        .path
                        .split('/')
                        .last}',
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey),
                  ),
                ),
              ),
            const SizedBox(height: 18),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: _acceptData,
                  onChanged: (v) {
                    if (v ?? false) {
                      _showTermsDialog(context);
                    } else {
                      setState(() => _acceptData = false);
                    }
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _acceptData = !_acceptData);
                      if (_acceptData) {
                        _showTermsDialog(context);
                      }
                    },
                    child: const Text(
                      'He leído y comprendido sobre el tratamiento de datos personales.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Validaciones del formulario completo
                  if (!_acceptData) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Debes aceptar el uso de datos'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (_selectedBirthDate != null) {
                    final today = DateTime.now();
                    final ageInMonths = (today.year - _selectedBirthDate!.year) * 12 + (today.month - _selectedBirthDate!.month);

                    if (ageInMonths < 6 || ageInMonths > 120) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Queremos cuidar a tu mascota en el momento adecuado de su vida. '
                                'Solo podemos registrar mascotas entre 6 meses y 10 años cumplidos.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }

                  // Validar cédula
                  if (_idCtrl.text.length != 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('La cédula debe tener 10 dígitos'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Validar celular
                  if (_phoneCtrl.text.length != 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El celular debe tener 10 dígitos'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (_formKey.currentState?.validate() != true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Completa todos los campos obligatorios'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  // Validar correo
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(_emailCtrl.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ingresa un correo electrónico válido'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (_photoFile == null && _photoBytes == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Debes subir una foto'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }


                  if (_hasCarnet == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Selecciona si la mascota tiene carnet'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (_hasCarnet == true && _petCarnetCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Debes ingresar el número de carnet'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Validación adicional de campos de mascota
                  if (_petNameCtrl.text.isEmpty ||
                      _selectedBreed == null ||
                      _selectedSpecies == null ||
                      _selectedGender == null ||
                      _selectedBirthDate == null ||
                      _petColorCtrl.text.isEmpty ||
                      (_hasCarnet == true && _petCarnetCtrl.text.isEmpty) ||
                      (_hasDefect == true && _defectCtrl.text.isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Completa todos los datos de la mascota'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Mostrar indicador de carga
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: Lottie.asset(
                        'lib/ui/animation/Animacion_de_carga.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );

                  try {
                    // String? imageBase64;
                    String? imageBase64;
                    if (_photoBytes != null) {
                      imageBase64 = base64Encode(_photoBytes!);
                    } else if (_photoFile != null) {
                      final bytes = await _photoFile!.readAsBytes();
                      imageBase64 = base64Encode(bytes);
                    }
                    // Convertimos fecha a String
                    final birthDateStr = "${_selectedBirthDate!.day.toString().padLeft(2, '0')}/"
                        "${_selectedBirthDate!.month.toString().padLeft(2, '0')}/"
                        "${_selectedBirthDate!.year}";

                    // Enviar datos al backend
                    final data  = await _formRepository.enviarDatos(
                      nombre: _ownerNameCtrl.text,
                      apellido: _ownerLastNameCtrl.text,
                      cedula: _idCtrl.text,
                      celular: _phoneCtrl.text,
                      email: _emailCtrl.text,
                      ciudad: _cityCtrl.text,
                      contractId: widget.idContrato.toString(),
                      mascotas: [
                        {
                          'nombre': _petNameCtrl.text,
                          'raza': _selectedBreed!,
                          'species': _selectedSpecies!,
                          'gender': _selectedGender!,
                          'color': _petColorCtrl.text,
                          'birth_date': _selectedBirthDate!.toIso8601String(),
                          'carnet': _hasCarnet == false
                              ? "No tendrá cobertura hasta que tenga carnet"
                              : _petCarnetCtrl.text,  // Solo si es "Sí"
                          'defect': _hasDefect == true ? _defectCtrl.text : 'La mascota no tiene defectos',
                          'image_base64': imageBase64,
                        }
                      ],
                    );

                    Navigator.of(context).pop();
                    final nombreTemp = _ownerNameCtrl.text;
                    final mascotaTemp = _petNameCtrl.text;

                    _limpiarFormularios();
                    //se aplica la validacion
                    if(data["status"] == "success"){
                      final bool esTitular = data["data"]["statusTitular"] == true;
                     //final bool esTitular = true;
                      if(esTitular){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SuccessPage(
                              imageBase64: data["data"]["email_base64"] ?? "",
                            ),
                          ),
                        );
                      }else {
                        mostrarErrorPopup(context, data["data"]["message_coberage"] ?? "Error desconocido");
                      }
                    }else{
                      MaterialPageRoute(
                        builder: (_) => ErrorPage()
                      );
                    }
                  } catch (e) {
                    print("Nombre: ${_ownerNameCtrl.text}");
                    print("Mascota: ${_petNameCtrl.text}");
                    print("Nombre1: ${_ownerNameCtrl.text}");
                    print("Mascota2: ${_petNameCtrl.text}");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF074B5E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? formContent
          : ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.grey.shade600),
          trackColor: MaterialStateProperty.all(Colors.grey.shade300),
          trackBorderColor: MaterialStateProperty.all(Colors.grey.shade400),
          thickness: MaterialStateProperty.all(8),
          radius: const Radius.circular(8),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          interactive: true,
          child: SingleChildScrollView(
            child: formContent,
          ),
        ),
      ),


    );
  }
  Widget _rowLabelFieldResponsive(String label, Widget field, bool isMobile, {int maxLines = 1,}) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Rango para tablet vertical
    final isTabletVertical = !isMobile && screenWidth >= 600 && screenWidth < 767;

    // Nuevo rango para vertical grande (desktop pequeño)
    final isDesktopVertical = !isMobile && screenWidth >= 1024 && screenWidth <= 1534;

    if (isMobile || isTabletVertical || isDesktopVertical) {
      // Diseño vertical centrado
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // centrado horizontal
          children: [
            _labelPill(label, height: 40),
            const SizedBox(height: 6),
            SizedBox(
              width: screenWidth * 0.8, // ocupa un porcentaje del ancho
              child: field,
            ),
          ],
        ),
      );
    } else {
      // Diseño horizontal centrado
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // fila centrada
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: _labelPill(label),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: (maxLines > 1)
                  ? Padding(
                padding: const EdgeInsets.only(left: 0, top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // centrado vertical
                  children: [field],
                ),
              )
                  : SizedBox(
                height: 46,
                child: Center(child: field),
              ),
            ),
          ],
        ),
      );
    }
  }
  Widget _labelPill(String text, {bool multiline = false, double height = 46}) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      color: const Color(0xFF0A5970), // mismo color que usas
      child: Text(
        text,
        maxLines: multiline ? 2 : 1,
        overflow: TextOverflow.ellipsis,
        softWrap: multiline,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
  void _showTermsDialog(BuildContext context) {
    const Color pageWhite = Colors.white;
    const Color titleBlue = Color(0xFF0B7A95);
    const Color bodyBlue = Color(0xFF0B5E6C);

    const double logoWidth = 60; // ajustable
    const double contentWidthFactor = 0.62;

    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;

    // ancho máximo del papel según el dispositivo
    final double paperMaxWidth = isMobile ? size.width * 0.95 : size.width * 0.92;

    Widget _bullet(String text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6, right: 10),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: titleBlue,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: bodyBlue,
                  height: 1.48,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      );
    }

    Widget _numberedSection(int number, String heading, List<String> items) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$number. ',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: titleBlue,
                    ),
                  ),
                  TextSpan(
                    text: heading,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: titleBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (items.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.map((it) => _bullet(it)).toList(),
              ),
          ],
        ),
      );
    }

    final String intro =
        'OTTOKARE, conforme a lo dispuesto en la Ley Orgánica de Protección de Datos Personales (LOPDP), informa a los titulares que:';

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // 👇 Responsivo: en móvil usa 90%–95% del ancho, en desktop mínimo 600
              minWidth: isMobile ? size.width * 0.9 : 600,
              maxWidth: paperMaxWidth,
              maxHeight: size.height * 0.92,
            ),
            child: Material(
              color: pageWhite,
              elevation: 14,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                child: Column(
                  children: [
                    // ----- HEADER -----
                    SizedBox(
                      height: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Text(
                              'TRATAMIENTO DE DATOS PERSONALES',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: titleBlue,
                                letterSpacing: 0.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Image.asset(
                            'lib/ui/img/Logo1.png',
                            width: logoWidth,
                            height: logoWidth,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),
                    Divider(color: Colors.grey.shade300, thickness: 1),
                    const SizedBox(height: 8),

                    // ----- BODY (scrollable) -----
                    Expanded(
                      child: SingleChildScrollView(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: FractionallySizedBox(
                            widthFactor: isMobile ? 0.95 : contentWidthFactor,
                            alignment: Alignment.topCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TRATAMIENTO DE DATOS PERSONALES',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: titleBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  intro,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: bodyBlue,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 16),

                                _numberedSection(1, 'Datos personales que se recopilarán', [
                                  'Datos identificativos: nombres, apellidos, cédula/pasaporte, dirección, teléfono, correo electrónico.',
                                  'Datos de pago: número de cuenta o tarjeta, historial de pagos.',
                                  'Datos relacionados con la mascota: nombre, especie, raza, edad, historial médico veterinario, características físicas, fotografías.',
                                  'Datos sensibles: información sobre la salud de la mascota.',
                                ]),

                                _numberedSection(2, 'Finalidades del tratamiento', [
                                  'Gestionar la suscripción y prestación del servicio de asistencia para mascotas.',
                                  'Coordinar atención veterinaria, transporte o servicios complementarios conforme el certificado de cobertura.',
                                  'Realizar seguimiento y control de casos de asistencia.',
                                  'Gestionar pagos, facturación y cobranzas.',
                                  'Atender consultas, solicitudes o reclamos.',
                                  'Cumplir con obligaciones legales, contractuales o regulatorias.',
                                  'Enviar comunicaciones informativas o comerciales relacionadas con el servicio, siempre que el titular no haya ejercido su derecho de oposición.',
                                ]),

                                _numberedSection(3, 'Base legal del tratamiento', [
                                  'Que sea realizado por el responsable del tratamiento, por orden judicial u obligación legal.',
                                  'Para la ejecución de medidas precontractuales a petición del titular o para el cumplimiento de obligaciones contractuales.',
                                  'Para satisfacer un interés legítimo del responsable de tratamiento.',
                                ]),

                                _numberedSection(4, 'Comunicación y almacenamiento de datos', [
                                  'Los datos podrán ser compartidos con proveedores, veterinarios, clínicas, aseguradoras, empresas de transporte o call centers que actúen como encargados del tratamiento, únicamente para el cumplimiento de las finalidades antes descritas.',
                                  'En caso de transferencias internacionales, se garantizará que el país de destino cuente con niveles adecuados de protección o que existan garantías contractuales suficientes.',
                                  'El almacenamiento podrá realizarse en servidores propios o en servicios de computación en la nube, con las medidas técnicas y organizativas necesarias para proteger la información.',
                                ]),

                                _numberedSection(5, 'Plazo de conservación', [
                                  'OTTOKARE conservará los datos personales por un período de tiempo razonable tras terminar la relación contractual para permitir la defensa en caso de reclamos.',
                                  'Los datos serán tratados solo en la medida necesaria para los fines, o según lo exija la ley.',
                                  'OTTOKARE tomará medidas para eliminar, bloquear, seudonimizar o anonimizar los datos cuando no sean necesarios.',
                                ]),

                                _numberedSection(6, 'Derechos del titular', [
                                  'Para ejercer derechos sobre los datos, enviar solicitud a: legal@mmhcloseness.com',
                                  'La solicitud deberá contener al menos: nombres completos, cédula/pasaporte, dirección de notificación y descripción clara de la solicitud.',
                                ]),

                                _numberedSection(7, 'No entrega de datos personales, o datos erróneos o inexactos', [
                                  'Los titulares deberán entregar información exacta y completa, caso contrario los servicios no podrán ser prestados de manera adecuada.',
                                ]),

                                const SizedBox(height: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ----- FOOTER -----
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: titleBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() => _acceptData = true);
                        },
                        child: const Text(
                          'ACEPTAR',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  void mostrarErrorPopup(BuildContext context, String messageCoverage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animación Lottie
                SizedBox(
                  height: 120,
                  child: Lottie.asset(
                    "lib/ui/animation/ErrorForm.json",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),

                // Mensaje dinámico
                Text(
                  messageCoverage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // Botón de aceptar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _abrirEnlace();
                  },
                  child: const Text(
                    "Aceptar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }


  @override

  void initState() {
    // final String idContrato = Uri.base.queryParameters['contract'] ?? '';
    /*final String idContrato = Uri.base.queryParameters['contract_id'] ?? '';
    super.initState();
    runApp(MaterialApp(
      home: FormPage(idContrato: int.tryParse(idContrato) ?? 0),
    ));*/

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        setState(() {
          final email = _emailCtrl.text.trim();
          if (email.isEmpty) {
            _emailError = 'Campo obligatorio';
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
            _emailError = 'Ingrese un email válido';
          } else {
            _emailError = null; // ✅ válido
          }
        });
      }
    });
  }

}

