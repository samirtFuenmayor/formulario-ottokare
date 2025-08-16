// lib/pages/form_page.dart
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


class FormPage extends StatefulWidget {
  const FormPage({super.key});

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
  final TextEditingController _petCarnetCtrl = TextEditingController();

  // Age fields
  final TextEditingController _ageDayCtrl = TextEditingController();
  final TextEditingController _ageMonthCtrl = TextEditingController();
  final TextEditingController _ageYearCtrl = TextEditingController();
  DateTime? _selectedBirthDate; // Nueva variable
  // Generar controladores y variables
  final TextEditingController _birthDateCtrl = TextEditingController();
  String? _selectedGender;
  String? _selectedSpecies;
  String? _selectedBreed;

  // Lista para guardar mascotas temporalmente
  List<Map<String, String>> _mascotas = [];


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
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _photoFile = File(result.files.single.path!);
      });
    }

  }


  InputDecoration _fieldDecoration(String hint) =>
      InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF6FBFB),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

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
            "physical_defect": pet['defect'] ?? ""
          },
          "birth_date": pet['birth_date'] != null &&
              pet['birth_date'] is DateTime
              ? (pet['birth_date'] as DateTime).toIso8601String()
              : null, // ISO completo: 2020-12-31T00:00:00
          "identification": pet['carnet'] ?? _petCarnetCtrl.text
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
                          content: Text('Debes aceptar los términos y condiciones'),
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

                    // Mostrar indicador de carga
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    try {
                      // Enviar datos al backend
                      final mensaje = await _formRepository.enviarDatos(
                        nombre: _ownerNameCtrl.text,
                        apellido: _ownerLastNameCtrl.text,
                        cedula: _idCtrl.text,
                        celular: _phoneCtrl.text,
                        email: _emailCtrl.text,
                        ciudad: _cityCtrl.text,
                        mascotas: _mascotas,
                      );

                      // Cerrar indicador de carga
                      Navigator.of(context).pop();

                      // Mostrar mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(mensaje),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 3),
                        ),
                      );

                      // Limpiar formulario
                      _limpiarFormularios();

                    } catch (e) {
                      // Cerrar indicador de carga en caso de error
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al enviar: ${e.toString()}'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
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
            ),          ],
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
    });
  }


  @override
  Widget build(BuildContext context) {
    const Color headerBlue = Color(0xFF0A5970); // Azul oscuro original
    const Color backgroundTurquoise = Color(0xFF08AFC0);
    //const Color headerBlue = Color(0xFF0A5970);
    final isMobile = MediaQuery
        .of(context)
        .size
        .width < 800;

    return BlocProvider<FormBloc>(
      create: (_) => FormBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1150),
                margin: const EdgeInsets.symmetric(
                    vertical: 24, horizontal: 12),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Columna izquierda (formulario)
                            Expanded(
                              flex: 6,
                              child: Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        // Header
                                        // Header
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isMobile ? 12 : 18,
                                            vertical: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: headerBlue,
                                            borderRadius: const BorderRadius
                                                .vertical(
                                                top: Radius.circular(12)),
                                          ),
                                          child: isMobile
                                              ? Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [

                                                  const SizedBox(width: 10),
                                                  const Text(
                                                    'Asistencia Veterinaria',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight
                                                            .w600),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceAround,
                                                children: const [
                                                  Icon(Icons.medical_services,
                                                      color: Colors.white,
                                                      size: 20),
                                                  Icon(Icons.local_hospital,
                                                      color: Colors.white,
                                                      size: 20),
                                                  Icon(Icons.pets,
                                                      color: Colors.white,
                                                      size: 20),
                                                ],
                                              )
                                            ],
                                          )
                                              : Row(
                                            children: [
                                              // Container(
                                              //   width: 200,
                                              //   height: 80,
                                              //   child: Image.asset(
                                              //     'lib/ui/img/Logo.png',
                                              //     fit: BoxFit.contain, // Mantiene proporciones
                                              //   ),
                                              // ),
                                              const SizedBox(width: 14),
                                              const Text(
                                                'Asistencia Veterinaria',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight
                                                        .w600),
                                              ),
                                              const Spacer(),
                                              Row(
                                                children: const [
                                                  Icon(Icons.medical_services,
                                                      color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Icon(Icons.local_hospital,
                                                      color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Icon(Icons.pets,
                                                      color: Colors.white),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        // Imagen
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                12),
                                            child: Image.asset(
                                              'lib/ui/img/Clinica-Veterinaria.png',
                                              width: double.infinity,
                                              height: 250,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                  stackTrace) =>
                                                  Container(
                                                    color: Colors.grey[200],
                                                    child: const Center(
                                                        child: Text(
                                                            'Error cargando imagen')),
                                                  ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 16),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 6),
                                          child: Text(
                                            'Datos Dueño de la Mascota',
                                            style: TextStyle(
                                                color: headerBlue,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),

                                        // Campos Dueño
                                        _rowLabelFieldResponsive(
                                          'Nombre dueño de la mascota',
                                          TextFormField(
                                            controller: _ownerNameCtrl,
                                            decoration: _fieldDecoration('Nombre'),
                                            validator: (v) =>
                                            (v == null || v.isEmpty)
                                                ? 'Obligatorio'
                                                : null,
                                          ),
                                          isMobile,
                                        ),
                                        const SizedBox(height: 12),
                                        _rowLabelFieldResponsive(
                                          'Apellido del dueño de la mascota',
                                          TextFormField(
                                            controller: _ownerLastNameCtrl,
                                            decoration: _fieldDecoration('Apellido'),
                                            validator: (v) =>
                                            (v == null || v.isEmpty)
                                                ? 'Obligatorio'
                                                : null,
                                          ),
                                          isMobile,
                                        ),
                                        const SizedBox(height: 12),
                                        _rowLabelFieldResponsive(
                                          'Cédula',
                                          TextFormField(
                                            controller: _idCtrl,
                                            decoration: _fieldDecoration('Cedula'),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Solo números
                                            validator: (v) {
                                              if (v == null || v.isEmpty) return 'Campo obligatorio';
                                              if (!RegExp(r'^\d+$').hasMatch(v)) return 'Solo números permitidos';
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
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Solo números
                                            validator: (v) {
                                              if (v == null || v.isEmpty) return 'Campo obligatorio';
                                              if (!RegExp(r'^\d+$').hasMatch(v)) return 'Solo números permitidos';
                                              if (v.length < 10) return 'Mínimo 10 dígitos';
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
                                            decoration: _fieldDecoration('Correo Electronico'),
                                            keyboardType: TextInputType.emailAddress,
                                            validator: (v) {
                                              if (v == null || v.isEmpty) return 'Campo obligatorio';
                                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                                                return 'Ingrese un email válido';
                                              }
                                              return null;
                                            },
                                          ),
                                          isMobile,
                                        ),
                                        const SizedBox(height: 12),
                                        _rowLabelFieldResponsive(
                                          'Ciudad',
                                          TextFormField(
                                            controller: _cityCtrl,
                                            decoration: _fieldDecoration('Ciudad'),
                                            validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                                          ),
                                          isMobile,
                                        ),

                                        const SizedBox(height: 20),
                                        // Datos Mascota
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 6),
                                          child: Text(
                                            'Datos de la Mascota',
                                            style: TextStyle(
                                                color: headerBlue,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        _rowLabelFieldResponsive(
                                          'Nombre de la mascota',
                                          TextFormField(
                                            controller: _petNameCtrl,
                                            decoration: _fieldDecoration('Nombre de la Mascota'),
                                            validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                                          ),
                                          isMobile,
                                        ),
                                        const SizedBox(height: 12),

                                        // Dropdowns
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
                                        // Fecha nacimiento
                                        _rowLabelFieldResponsive(
                                          'Fecha de nacimiento',
                                          TextFormField(
                                            controller: _birthDateCtrl,
                                            readOnly: true,
                                            decoration: _fieldDecoration(
                                                'Selecciona fecha'),
                                            onTap: () async {
                                              DateTime? pickedDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now(),
                                                locale: const Locale(
                                                    'es', 'ES'),
                                              );
                                              if (pickedDate != null) {
                                                setState(() {
                                                  _selectedBirthDate =
                                                      pickedDate; // guardamos DateTime
                                                  _birthDateCtrl.text =
                                                  "${pickedDate.day
                                                      .toString()
                                                      .padLeft(2, '0')}/"
                                                      "${pickedDate.month
                                                      .toString().padLeft(
                                                      2, '0')}/"
                                                      "${pickedDate.year}";
                                                });
                                              }
                                            },
                                            validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                                          ),
                                          isMobile,
                                        ),

                                        const SizedBox(height: 12),
                                        _rowLabelFieldResponsive(
                                          'Color',
                                          TextFormField(
                                            controller: _petColorCtrl,
                                            decoration: _fieldDecoration('Coloque el color de su Mascota'),
                                            validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                                          ),
                                          isMobile,
                                        ),
                                        const SizedBox(height: 12),
                                        _rowLabelFieldResponsive(
                                          'La mascota tiene algún defecto físico o enfermedad?',
                                          TextFormField(
                                            decoration: _fieldDecoration(
                                                'Especifique'),
                                            validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                                          ),
                                          isMobile,
                                        ),
                                        const SizedBox(height: 12),
                                        _rowLabelFieldResponsive(
                                          'Carnet',
                                          TextFormField(
                                            controller: _petCarnetCtrl,
                                            decoration: _fieldDecoration('Digite el numero de Carnet'),
                                            validator: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                                          ),
                                          isMobile,
                                        ),
                                        const SizedBox(height: 12),

                                        // Foto
                                        Row(
                                          children: [
                                            _labelPill('Foto'),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: _pickFile,
                                                icon: const Icon(
                                                    Icons.upload_file),
                                                label: const Text('Subir foto'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .amber[700],
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 14),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(16)),
                                                ),
                                              ),
                                            ),
                                          ],
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

                                        // Checkbox
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                              value: _acceptData,
                                              onChanged: (v) {
                                                if (v ?? false) {
                                                  _showTermsDialog(context); // Muestra modal solo al marcar
                                                } else {
                                                  setState(() => _acceptData = false); // Desmarca directamente
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
                                                  'Declaro que la información es real y acepto el uso de la misma según la Protección de Datos Personales.',
                                                  style: TextStyle(fontSize: 13),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 18),

                                        // Botón agregar mascota

                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  if (_petNameCtrl.text
                                                      .isEmpty ||
                                                      _selectedBreed == null ||
                                                      _selectedBirthDate ==
                                                          null) {

                                                    ScaffoldMessenger.of(
                                                        context).showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Complete todos los datos del formulario')),
                                                    );
                                                    return;
                                                  }

                                                  // Convertimos DateTime a String (dd/MM/yyyy)
                                                  final birthDateStr =
                                                      "${_selectedBirthDate!.day
                                                      .toString().padLeft(
                                                      2, '0')}/"
                                                      "${_selectedBirthDate!
                                                      .month.toString().padLeft(
                                                      2, '0')}/"
                                                      "${_selectedBirthDate!
                                                      .year}";

                                                  setState(() {
                                                    _mascotas.add({
                                                      'nombre': _petNameCtrl
                                                          .text,
                                                      'raza': _selectedBreed ??
                                                          '',
                                                      'species': _selectedSpecies ??
                                                          '',
                                                      'gender': _selectedGender ??
                                                          '',
                                                      'color': _petColorCtrl
                                                          .text,
                                                      //'birth_date': birthDateStr! .toIso8601String(),
                                                      'birth_date': _selectedBirthDate!
                                                          .toIso8601String(),
                                                      // ✅ correcto// <-- ahora es String
                                                      'carnet': _petCarnetCtrl
                                                          .text,
                                                      'defect': '',
                                                    });

                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Mascota agregada correctamente'),
                                                        backgroundColor: Colors.green,
                                                      ),
                                                    );

                                                    // Limpiar campos
                                                    // _petNameCtrl.clear();
                                                    // _selectedSpecies = null;
                                                    // _selectedBreed = null;
                                                    // _birthDateCtrl.clear();
                                                  });
                                                },
                                                icon: const Icon(Icons.add),
                                                label: const Text(
                                                    'Agregar Mascota'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  foregroundColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),

                                        // Botón Confirmar y modal de mascotas
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (!_acceptData) {
                                                ScaffoldMessenger
                                                    .of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Debes aceptar el uso de datos')),
                                                );
                                                return;
                                              }

                                              final double modalWidth = MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width < 800
                                                  ? MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.9
                                                  : 600;

                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    Dialog(
                                                      insetPadding: const EdgeInsets
                                                          .all(16),
                                                      child: Container(
                                                        width: modalWidth,
                                                        padding: const EdgeInsets
                                                            .all(16),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(12),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize
                                                              .min,
                                                          children: [
                                                            const Text(
                                                              'Mascotas Registradas',
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight
                                                                      .bold
                                                              ),
                                                            ),

                                                            const SizedBox(
                                                                height: 16),
                                                            SingleChildScrollView(
                                                              scrollDirection: Axis
                                                                  .horizontal,
                                                              child: ConstrainedBox(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: 600),
                                                                child: SingleChildScrollView(
                                                                  scrollDirection: Axis
                                                                      .vertical,
                                                                  child: DataTable(
                                                                    columns: const [
                                                                      DataColumn(label: Text('Nombre')),
                                                                      DataColumn(label: Text('Epecies')),
                                                                      DataColumn(label: Text('Raza')),
                                                                      DataColumn(label: Text('Carnet')),
                                                                      DataColumn(label: Text('Acciones')),
                                                                    ],
                                                                    rows: _mascotas.map((m) =>
                                                                          DataRow(cells: [
                                                                            DataCell(Text(m['nombre']!)),
                                                                            DataCell(Text(m['species']!)),
                                                                            DataCell(Text(m['raza']!)),
                                                                            DataCell(Text(m['carnet']!)),
                                                                              DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.red),
                                                                                  onPressed: () {
                                                                                    setState(() {_mascotas.remove(m);
                                                                                    });
                                                                                    Navigator.of(context).pop();
                                                                                    Future.delayed(Duration.zero, () {
                                                                                      showDialog(context: context, builder: (_) =>
                                                                                            buildMascotasDialog(
                                                                                                context,
                                                                                                modalWidth),
                                                                                      );
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                    )
                                                                        .toList(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 20),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: const Text('Cancelar'),
                                                                ),
                                                                const SizedBox(width: 12),
                                                                ElevatedButton(
                                                                  onPressed: () async {
                                                                    // Validaciones antes de enviar
                                                                    if (!_acceptData) {
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        const SnackBar(
                                                                          content: Text('Debes aceptar los términos y condiciones'),
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

                                                                    if (_mascotas.isEmpty) {
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                        const SnackBar(
                                                                          content: Text('Debes agregar al menos una mascota'),
                                                                          backgroundColor: Colors.red,
                                                                        ),
                                                                      );
                                                                      return;
                                                                    }

                                                                    // Cerrar el modal de mascotas
                                                                    Navigator.of(context).pop();

                                                                    // Enviar datos
                                                                    await _enviarDatos();
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
                                                    ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                  0xFF074B5E),
                                              padding: const EdgeInsets
                                                  .symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(12),
                                              ),
                                            ),
                                            child: const Text('Confirmar',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Columna derecha (solo escritorio)
                            if (!isMobile)
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: backgroundTurquoise,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      const SizedBox(height: 100),
                                      //TEXTO CON FRANJA
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Título en azul con salto de línea
                                            const Text(
                                              "Mantén\nProtegido",
                                              style: TextStyle(
                                                fontSize: 32, // más grande
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFFFFFF), // azul oscuro
                                                height: 1.2, // control del interlineado
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            // Franja verde ocupando mitad de la columna
                                            FractionallySizedBox(
                                              widthFactor: 0.5, // la franja llega a la mitad de la columna
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF77B255), // verde
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Text(
                                                  "a tu mascota",
                                                  style: TextStyle(
                                                    fontSize: 20, // más grande
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),

                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            // Texto descriptivo debajo
                                            const Text(
                                              "Durante todo el año,\n"
                                                  "pagando menos respecto a\n"
                                                  "los precios de los servicios\n"
                                                  "independientes y accediendo a\n"
                                                  "descuentos exclusivos.",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white, // gris oscuro
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 40),
                                      // Iconos arriba
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Imagen del perrito justo encima de la franja naranja
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.asset(
                                                'lib/ui/img/Perro.png',
                                                width: double.infinity,
                                                height: 380,
                                                fit: BoxFit.cover,
                                              ),
                                            ),

                                            //const SizedBox(height: 12),

                                            // Franja naranja superior con icono y texto
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF39C12), // naranja
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Icon(Icons.pets, color: Colors.white, size: 18),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Coberturas Veterinarias',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 18),

                                            // Lista de opciones con icono y texto al lado
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                              child: Column(
                                                children: [
                                                  // Hospedaje
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 42,
                                                        width: 42,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white.withOpacity(0.08),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: const Icon(Icons.local_hotel, color: Colors.white, size: 28),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      const Expanded(
                                                        child: Text(
                                                          'Hospedaje',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 12),

                                                  // Red de beneficios
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 42,
                                                        width: 42,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white.withOpacity(0.08),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: const Icon(Icons.medical_services, color: Colors.white, size: 28),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      const Expanded(
                                                        child: Text(
                                                          'Red de beneficios',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 12),

                                                  // Atención Telefónica
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 42,
                                                        width: 42,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white.withOpacity(0.08),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: const Icon(Icons.call, color: Colors.white, size: 28),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      const Expanded(
                                                        child: Text(
                                                          'Atención Telefónica',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 12),

                                                  // Y mucho más (icono de huesito: uso Icons.pets por defecto)
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 42,
                                                        width: 42,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white.withOpacity(0.08),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: const Icon(Icons.pets, color: Colors.white, size: 28),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      const Expanded(
                                                        child: Text(
                                                          'Y mucho más',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Si tu Column está dentro de otro contenedor que requiere espacio flexible:
                                            // const Spacer(),
                                          ],
                                        ),
                                      ),

                                      const Spacer(),

                                      // Imagen perro al final
                                      Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              12),
                                          child: Image.asset(
                                            'lib/ui/img/Gato.png',
                                            width: double.infinity,
                                            height: 350,
                                            fit: BoxFit.cover,
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
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

// Función auxiliar responsive
  Widget _rowLabelFieldResponsive(String label, Widget field, bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _labelPill(label),
          ),
          field,
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 200, // Ancho fijo para desktop
            child: Padding(
              padding: const EdgeInsets.only(top: 6), // Ajuste fino de alineación
              child: _labelPill(label),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: field,
            ),
          ),
        ],
      );
    }
  }
  Widget _labelPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A5970), // Azul oscuro directo
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white, // Texto blanco
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Fondo blanco
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // esquinas suaves
        title: const Text(
          'Tratamiento de Datos Personales',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6, // Ancho mediano
          height: MediaQuery.of(context).size.height * 0.6, // Alto mediano
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OTTOKARE, conforme a lo dispuesto en la Ley Orgánica de Protección de Datos Personales (LOPDP), informa a los titulares que:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.justify, // Justificación formal del texto
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '1. Datos personales que se recopilarán\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        'Se podrán tratar las siguientes categorías:\n\n'
                            '   • Datos identificativos: nombres, apellidos, cédula/pasaporte, dirección, teléfono, correo electrónico.\n\n'
                            '   • Datos de pago: número de cuenta o tarjeta, historial de pagos.\n\n'
                            '   • Datos relacionados con la mascota: nombre, especie, raza, edad, historial médico veterinario, características físicas, fotografías.\n\n'
                            '   • Datos sensibles: información sobre la salud de la mascota.\n\n',
                      ),
                      TextSpan(
                        text: '2. Finalidades del tratamiento\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        'Los datos serán tratados con las siguientes finalidades:\n\n'
                            '   • Gestionar la suscripción y prestación del servicio de asistencia para mascotas.\n\n'
                            '   • Coordinar atención veterinaria, transporte o servicios complementarios conforme el certificado de cobertura.\n\n'
                            '   • Realizar seguimiento y control de casos de asistencia.\n\n'
                            '   • Gestionar pagos, facturación y cobranzas.\n\n'
                            '   • Atender consultas, solicitudes o reclamos.\n\n'
                            '   • Cumplir con obligaciones legales, contractuales o regulatorias.\n\n'
                            '   • Enviar comunicaciones informativas o comerciales relacionadas con el servicio, siempre que el titular no haya ejercido su derecho de oposición.\n\n',
                      ),
                      TextSpan(
                        text: '3. Base legal del tratamiento\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        'El tratamiento se realiza sobre las siguientes bases legitimadoras:\n\n'
                            '   • Que sea realizado por el responsable del tratamiento, por orden judicial u obligación legal.\n\n'
                            '   • Para la ejecución de medidas precontractuales a petición del titular o para el cumplimiento de obligaciones contractuales.\n\n'
                            '   • Para satisfacer un interés legítimo del responsable de tratamiento.\n\n',
                      ),
                      TextSpan(
                        text: '4. Comunicación y almacenamiento de datos\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        'Los datos podrán ser compartidos con proveedores, veterinarios, clínicas, aseguradoras, empresas de transporte o call centers que actúen como encargados del tratamiento, únicamente para el cumplimiento de las finalidades antes descritas.\n\n'
                            'En caso de transferencias internacionales, se garantizará que el país de destino cuente con niveles adecuados de protección o que existan garantías contractuales suficientes.\n\n'
                            'El almacenamiento podrá realizarse en servidores propios o en servicios de computación en la nube, con las medidas técnicas y organizativas necesarias para proteger la información.\n\n',
                      ),
                      TextSpan(
                        text: '5. Plazo de conservación\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        'En el caso de que se termine la relación contractual con los Titulares, OTTOKARE conservará los datos personales de estos por un período de tiempo razonable para permitir la defensa del Responsable del Tratamiento en caso de presentarse algún reclamo administrativo o judicial por él o en su contra con relación a la prestación de los servicios que ofrece. En todo caso, los datos personales serán tratados en la medida en que sean necesarios para satisfacer los fines para los cuales se recogieron, o para cumplir con cualquier requisito legal, por lo que el plazo podría prolongarse. En el supuesto de que la autoridad establezca plazos determinados, OTTOKARE se compromete a tratar los datos personales hasta el plazo máximo establecido por esta. OTTOKARE se compromete a que, en el supuesto de que no se requiera el tratamiento de los datos personales de los Titulares durante un periodo de tiempo razonable, este tomará todas las medidas de seguridad pertinentes para eliminar, bloquear, seudonimizar o anonimizar los datos personales.\n\n',
                      ),
                      TextSpan(
                        text: '6. Derechos del titular\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        'Para el ejercicio de cualquiera de los derechos aquí plasmados o reclamación única y exclusivamente sobre el tratamiento de datos personales, los Titulares deberán enviar una solicitud a la siguiente dirección electrónica: legal@mmhcloseness.com\n\n'
                            'La solicitud deberá contener, al menos lo siguiente:\n\n'
                            '   • Nombres y apellidos completos de los Titulares, número de cédula de identidad o pasaporte y dirección domiciliaria o electrónica para notificaciones. Cuando se actúa en calidad de representante legal, se hará constar también los datos del representado.\n\n'
                            '   • La descripción clara y precisa del derecho que se busca ejercer y detalle de los datos personales en los cuales se busca ejercer el mismo, conforme la Ley Orgánica de Protección de Datos Personales.\n\n'
                            '   • A la solicitud se acompañará los documentos que acrediten la identidad o, en su caso, la representación legal o convencional del titular.\n\n'
                            'En caso de que la información constante en la solicitud requiera ser aclarecida o ampliada, OTTOKARE requerirá a los Titulares, por una sola vez y dentro del término de cinco días de recibida la solicitud, que la aclare o complete. Los Titulares contará con el término de diez días contados a partir del día siguiente en el que haya sido notificado con la solicitud de aclaración o ampliación para aclarar o completar la solicitud. Si los Titulares aclaran o completan la solicitud dentro del término mencionado, el Responsable del Tratamiento dará la debida atención a la solicitud, caso contrario, OTTOKARE se reserva el derecho de archivar la solicitud, para lo cual se notificará a los Titulares de este hecho con las razones de la decisión. En el caso de que se lo requiera, los Titulares podrán comunicarse directamente con la Autoridad de Protección de Datos Personales ecuatoriana.\n\n',
                      ),
                      TextSpan(
                        text: '7. No entrega de datos personales, o datos erróneos o inexactos\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        'Para el cumplimiento de cualquiera de los fines establecidos por OTTOKARE, los Titulares deberán entregar la información exacta y completa, caso contrario los servicios o solicitudes no podrán ser prestados de manera adecuada. Así mismo, OTTOKARE se reserva el derecho de no prestar el servicio o solicitudes a los Titulares, si los datos de estos no son entregados, o son entregados con errores, inexactos o incorrectos.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Botón verde
              foregroundColor: Colors.white, // Texto blanco
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _acceptData = true);
            },
            child: const Text('Aceptar', style: TextStyle(fontSize: 14)),
          ),
        ],
        scrollable: true,
      ),
    );
  }
  Future<void> _enviarDatos() async {
    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final mensaje = await _formRepository.enviarDatos(
        nombre: _ownerNameCtrl.text,
        apellido: _ownerLastNameCtrl.text, // Asegurando que se envía el apellido
        cedula: _idCtrl.text,
        celular: _phoneCtrl.text,
        email: _emailCtrl.text,
        ciudad: _cityCtrl.text,
        mascotas: _mascotas,
      );

      // Cerrar indicador de carga
      Navigator.of(context).pop();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Limpiar formulario
      _limpiarFormularios();

    } catch (e) {
      // Cerrar indicador de carga en caso de error
      Navigator.of(context).pop();

      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar los datos: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

}