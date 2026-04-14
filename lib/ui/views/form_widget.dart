import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/form_bloc.dart';
import '../../bloc/form_event.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/razas_data.dart';


// ═══════════════════════════════════════════════════════════════════
//  COLORES DEL DESIGN SYSTEM
// ═══════════════════════════════════════════════════════════════════
const Color kAzulPrincipal  = Color(0xFF005871);   // Azul principal
const Color kAzulClaro      = Color(0xFF00B0C8);   // Azul claro
const Color kText           = Color(0xFF005871);   // Text → Azul principal (color base de todos los textos del formulario)
const Color kBlanco         = Color(0xFFFFFFFF);   // Blanco
const Color kNegro          = Color(0xFF000000);   // Negro
const Color kTextInput      = Color(0xFF8E8E8E);   // Text input (placeholder)
const Color kRojo           = Color(0xFFF3000C);   // Rojo (errores)
const Color kPasoCompletado = Color(0xFF1D8841);   // Paso completado
const Color kPasoFaltante   = Color(0xFFE1E1E6);   // Paso faltante
const Color kBorder         = Color(0xFFCDD8DC);   // Borde inputs

// Aliases de compatibilidad
const Color kTeal        = kAzulPrincipal;
const Color kTealLight   = Color(0xFFE6F4F6);
const Color kTealSuccess = kPasoCompletado;
const Color kTextDark    = kText;
const Color kTextMuted   = kTextInput;
const Color kBgCard      = Color(0xFFF0F7F9);

// ═══════════════════════════════════════════════════════════════════
//  ESTILOS DE TIPOGRAFÍA DEL DESIGN SYSTEM
// ═══════════════════════════════════════════════════════════════════

TextStyle get kStyleTituloWebTablet => GoogleFonts.quicksand(
  fontSize: 40, fontWeight: FontWeight.w700,
  height: 48 / 40, color: kAzulPrincipal,
);

TextStyle get kStyleTituloMovil => GoogleFonts.quicksand(
  fontSize: 36, fontWeight: FontWeight.w700,
  height: 1.2, color: kAzulPrincipal,
);

TextStyle get kStyleEncabezadoFormWeb => GoogleFonts.quicksand(
  fontSize: 22, fontWeight: FontWeight.w700, color: kAzulPrincipal,
);

TextStyle get kStyleEncabezadoFormMovil => GoogleFonts.quicksand(
  fontSize: 18, fontWeight: FontWeight.w700,
  height: 1.2, color: kAzulPrincipal,
);

TextStyle get kStyleMensajeConfirmacion => GoogleFonts.quicksand(
  fontSize: 32, fontWeight: FontWeight.w700, color: kBlanco,
);

TextStyle get kStylePasosFormulario => GoogleFonts.quicksand(
  fontSize: 16, fontWeight: FontWeight.w700,
  height: 1.5, color: kAzulPrincipal,
);

TextStyle get kStyleInputButtons => GoogleFonts.quicksand(
  fontSize: 16, fontWeight: FontWeight.w700,
  height: 20 / 16, color: kBlanco,
);

TextStyle get kStyleTextosBotones => GoogleFonts.montserrat(
  fontSize: 16, fontWeight: FontWeight.w700,
  height: 1.5,
);

TextStyle get kStyleTextoP => GoogleFonts.montserrat(
  fontSize: 18, fontWeight: FontWeight.w500,
  height: 26 / 18, color: kAzulPrincipal,
);

TextStyle get kStyleLabel => GoogleFonts.montserrat(
  fontSize: 17, fontWeight: FontWeight.w600,
  height: 20 / 17, color: kAzulPrincipal,
);

TextStyle get kStyleInput => GoogleFonts.montserrat(
  fontSize: 17, fontWeight: FontWeight.w500,
  height: 20 / 17, color: kAzulPrincipal,
);

TextStyle get kStyleWarning => GoogleFonts.montserrat(
  fontSize: 12, fontWeight: FontWeight.w600,
  height: 20 / 12, color: kRojo,
);

TextStyle get kStyleInformacionFormulario => GoogleFonts.montserrat(
  fontSize: 14, fontWeight: FontWeight.w500,
  height: 20 / 14, color: kAzulPrincipal,
);

// ═══════════════════════════════════════════════════════════════════
//  WIDGET PRINCIPAL
// ═══════════════════════════════════════════════════════════════════
class FormWidget extends StatefulWidget {
  final void Function(int step)? onStepChanged;
  final bool showStepper;
  final String contractId;
  const FormWidget({super.key, this.onStepChanged, this.showStepper = true, required this.contractId});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  int _step = 0; // 0=datos dueño, 1=mascota, 2=condición, 3=éxito

  // ── Datos paso 1 ──────────────────────────────────────────────
  final _nombreCtrl    = TextEditingController();
  final _apellidoCtrl  = TextEditingController();
  final _cedulaCtrl    = TextEditingController();
  final _celularCtrl   = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _direccionCtrl = TextEditingController();
  String? _ciudad;

  // ── Datos paso 2 ──────────────────────────────────────────────
  final _petNombreCtrl = TextEditingController();
  final _colorCtrl     = TextEditingController();
  String? _fechaNac;
  DateTime? _selectedDate;
  String? _sexo;
  String? _especie;
  String? _raza;

  // ── Datos paso 3 ──────────────────────────────────────────────
  String? _limitacion;
  String? _vacunacion;
  final _limitacionCtrl = TextEditingController();
  final _vacunacionCtrl = TextEditingController();
  bool    _acepta = false;

  // ── Form keys ─────────────────────────────────────────────────
  final _key1 = GlobalKey<FormState>();
  final _key2 = GlobalKey<FormState>();
  final _key3 = GlobalKey<FormState>();

  final List<String> _ciudades = [
    'Ambato', 'Azogues', 'Babahoyo', 'Baños', 'Calceta', 'Cañar',
    'Catamayo', 'Cayambe', 'Chone', 'Coca', 'Cotacachi', 'Cuenca',
    'Daule', 'Esmeraldas', 'Guano', 'Guaranda', 'Guayaquil', 'Huaquillas',
    'Ibarra', 'La Libertad', 'Lago Agrio', 'Latacunga', 'Loja', 'Machachi',
    'Machala', 'Manta', 'Milagro', 'Montecristi', 'Morona', 'Otavalo',
    'Pasaje', 'Pedro Vicente Maldonado', 'Portoviejo', 'Puyo', 'Quevedo',
    'Quito', 'Riobamba', 'Salcedo', 'Salinas', 'Samborondón', 'Santa Elena',
    'Santa Rosa', 'Santo Domingo', 'Tena', 'Tulcán', 'Ventanas', 'Vinces',
    'Zamora', 'Zaruma',
  ];

  List<String> get _razas {
    if (_especie == 'Perro') return razasPerros.map((r) => r.nombre).toList();
    if (_especie == 'Gato')  return razasGatos.map((r) => r.nombre).toList();
    return [];
  }

  Uint8List? _imageBytes;
  String? _imageName;
  bool _hasImage = false;
  int? _razaCodigo;

  // ── Auto-reset tras éxito ─────────────────────────────────────
  Timer? _resetTimer;
  int _countdown = 10;

  void _startResetTimer() {
    _resetTimer?.cancel();
    _countdown = 10;
    _resetTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _countdown--);
      if (_countdown <= 0) { t.cancel(); _resetForm(); }
    });
  }

  void _resetForm() {
    _resetTimer?.cancel();
    _nombreCtrl.clear();    _apellidoCtrl.clear();
    _cedulaCtrl.clear();    _celularCtrl.clear();
    _emailCtrl.clear();     _direccionCtrl.clear();
    _petNombreCtrl.clear(); _colorCtrl.clear();
    _limitacionCtrl.clear(); _vacunacionCtrl.clear();
    setState(() {
      _ciudad = null; _fechaNac = null; _selectedDate = null;
      _sexo = null; _especie = null; _raza = null;
      _limitacion = null; _vacunacion = null; _acepta = false;
      _imageBytes = null; _imageName = null; _hasImage = false;
      _countdown = 10;
    });
    _goToStep(0);
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _nombreCtrl.dispose();  _apellidoCtrl.dispose();
    _cedulaCtrl.dispose();  _celularCtrl.dispose();
    _emailCtrl.dispose();   _direccionCtrl.dispose();
    _petNombreCtrl.dispose(); _colorCtrl.dispose();
    _limitacionCtrl.dispose();
    _vacunacionCtrl.dispose();
    super.dispose();
  }

  void _goToStep(int newStep) {
    setState(() => _step = newStep);
    widget.onStepChanged?.call(newStep);
    if (newStep == 3) _startResetTimer();
  }

  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 1),
      firstDate: DateTime(2000),
      lastDate: now,
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      // ── Validación de rango de edad ──────────────────────────
      // Mínimo: la mascota debe tener AL MENOS 6 meses
      // → su fecha de nacimiento debe ser ANTERIOR a (hoy - 6 meses)
      final DateTime fechaMinima = DateTime(now.year, now.month - 6, now.day);

      // Máximo: la mascota debe tener MENOS DE 9 años y 29 días
      // → su fecha de nacimiento debe ser POSTERIOR a (hoy - 9 años - 29 días)
      final DateTime fechaMaxima = DateTime(now.year - 9, now.month, now.day - 29);

      if (picked.isAfter(fechaMinima)) {
        _showSnack("Tu mascota debe tener al menos 6 meses de edad");
        return;
      }
      if (picked.isBefore(fechaMaxima)) {
        _showSnack("Tu mascota debe tener menos de 9 años y 29 días de edad");
        return;
      }

      setState(() {
        _selectedDate = picked;
        _fechaNac = _formatDateWithAge(picked);
      });
    }
  }

  String _formatDateWithAge(DateTime date) {
    final now = DateTime.now();
    int years = now.year - date.year;
    int months = now.month - date.month;
    int days = now.day - date.day;
    if (days < 0) { months--; days += DateTime(now.year, now.month, 0).day; }
    if (months < 0) { years--; months += 12; }
    final fecha = "${date.day.toString().padLeft(2,'0')}/"
        "${date.month.toString().padLeft(2,'0')}/${date.year}";
    return "$fecha | $years años $months meses $days días";
  }

  void _showPdfModal() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: kAzulPrincipal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Política de Datos",
                        style: kStyleTextosBotones.copyWith(color: kBlanco),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: kBlanco),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SfPdfViewer.asset(
                    'https://www.ecuasanitas.com/assets/files/POLITICA_DE_PROTECCION_DE_DATOS.pdf',
                    canShowScrollHead: true,
                    canShowScrollStatus: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: kBlanco,
        child: _step == 3
            ? GestureDetector(
          onTap: _resetForm,
          behavior: HitTestBehavior.opaque,
          child: _buildSuccess(),
        )
            : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        if (widget.showStepper) _Stepper(step: _step),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 14, 28, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 44),
                child: IntrinsicHeight(
                  child: [_buildStep1(), _buildStep2(), _buildStep3()][_step],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  PASO 1 — Datos del dueño
  // ═══════════════════════════════════════════════════════════════
  Widget _buildStep1() {
    return Form(
      key: _key1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _sectionTitle("Ingresa los datos del dueño de la mascota"),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _field("Nombre", _nombreCtrl,
                  hint: "Ej. Juan", required: true)),
              const SizedBox(width: 16),
              Expanded(child: _field("Apellido", _apellidoCtrl,
                  hint: "Ej. García", required: true)),
            ],
          ),
          const SizedBox(height: 14),
          _field("Cédula del titular", _cedulaCtrl,
              hint: "Ej. 1789653698", required: true,
              inputType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 14),
          _field("Celular", _celularCtrl,
              hint: "Ej. 0986532956", required: true,
              inputType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: 14),
          _field("E-mail", _emailCtrl,
              hint: "correo@ejemplo.com", required: true,
              inputType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Campo requerido';
                if (!v.contains('@')) return 'Email inválido';
                return null;
              }),
          const SizedBox(height: 14),
          _ciudadAutocomplete(),
          const SizedBox(height: 14),
          _field("Dirección", _direccionCtrl,
              hint: "Ingresa tu dirección actual", required: true),
          const SizedBox(height: 28),
          Align(
            alignment: Alignment.centerRight,
            child: _btnPrimary("Continuar", () {
              if (_key1.currentState!.validate() && _ciudad != null) {
                _goToStep(1);
              } else if (_ciudad == null) {
                _showSnack("Selecciona una ciudad");
              }
            }),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  PASO 2 — Datos de la mascota
  // ═══════════════════════════════════════════════════════════════
  Widget _buildStep2() {
    return Form(
      key: _key2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _sectionTitle("Ingresa los datos de tu mascota"),
          const SizedBox(height: 20),
          _field("Nombre", _petNombreCtrl, hint: "Ej. Firulais", required: true),
          const SizedBox(height: 14),
          _dateField(),
          const SizedBox(height: 14),
          _label("Sexo", required: true),
          const SizedBox(height: 8),
          Row(
            children: [
              _toggleBtn(label: "Macho", iconPath: 'lib/ui/img/icon-male.svg',
                  selected: _sexo == 'Macho',
                  onTap: () => setState(() => _sexo = 'Macho')),
              const SizedBox(width: 12),
              _toggleBtn(label: "Hembra", iconPath: 'lib/ui/img/icon-female.svg',
                  selected: _sexo == 'Hembra',
                  onTap: () => setState(() => _sexo = 'Hembra')),
            ],
          ),
          const SizedBox(height: 14),
          _label("Especie", required: true),
          const SizedBox(height: 8),
          Row(
            children: [
              _toggleBtn(label: "Perro", iconPath: 'lib/ui/img/icon-dog.svg',
                  selected: _especie == 'Perro',
                  onTap: () => setState(() { _especie = 'Perro'; _raza = null; })),
              const SizedBox(width: 12),
              _toggleBtn(label: "Gato", iconPath: 'lib/ui/img/icon-cat.svg',
                  selected: _especie == 'Gato',
                  onTap: () => setState(() { _especie = 'Gato'; _raza = null; })),
            ],
          ),
          const SizedBox(height: 14),
          _razaAutocomplete(),
          const SizedBox(height: 14),
          _field("Color(es) de pelaje", _colorCtrl,
              hint: "Describe el color(es) de tu mascota", required: true),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _btnSecondary("Volver", () => _goToStep(0)),
              _btnPrimary("Continuar", () {
                if (_key2.currentState!.validate() &&
                    _sexo != null && _especie != null &&
                    _fechaNac != null && _raza != null) {
                  _goToStep(2);
                } else if (_fechaNac == null) {
                  _showSnack("Selecciona la fecha de nacimiento de tu mascota");
                } else {
                  _showSnack("Completa todos los campos");
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  PASO 3 — Condición de la mascota
  // ═══════════════════════════════════════════════════════════════
  Widget _buildStep3() {
    return Form(
      key: _key3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _sectionTitle("Ingresa la condición de salud de tu mascota"),
          const SizedBox(height: 4),
          Text("Tu respuesta no va a afectar el precio de tu plan.",
              style: kStyleInformacionFormulario.copyWith(color: kTextInput)),
          const SizedBox(height: 20),
          _label("¿Tu mascota posee alguna limitación física o enfermedad?", required: true),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _yesNoBtn("Si",
                  selected: _limitacion == 'Si',
                  onTap: () => setState(() => _limitacion = 'Si'))),
              const SizedBox(width: 12),
              Expanded(child: _yesNoBtn("No",
                  selected: _limitacion == 'No',
                  onTap: () => setState(() {
                    _limitacion = 'No';
                    _limitacionCtrl.clear();
                  }))),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => SizeTransition(
              sizeFactor: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: _limitacion == 'Si'
                ? Padding(
              key: const ValueKey("limitacion_on"),
              padding: const EdgeInsets.only(top: 12),
              child: TextFormField(
                controller: _limitacionCtrl,
                maxLines: 3,
                style: kStyleInput,
                decoration: _inputDeco("Cuéntanos sobre su estado físico o enfermedad"),
              ),
            )
                : const SizedBox(key: ValueKey("limitacion_off")),
          ),
          const SizedBox(height: 16),
          _label("¿Cuenta con carnet de vacunación?", required: true),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _yesNoBtn("Si",
                  selected: _vacunacion == 'Si',
                  onTap: () => setState(() => _vacunacion = 'Si'))),
              const SizedBox(width: 12),
              Expanded(child: _yesNoBtn("No",
                  selected: _vacunacion == 'No',
                  onTap: () => setState(() {
                    _vacunacion = 'No';
                    _vacunacionCtrl.clear();
                  }))),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => SizeTransition(
              sizeFactor: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: _vacunacion == 'Si'
                ? Padding(
              key: const ValueKey("vacunacion_on"),
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "El carnet de vacunación es necesario para solicitar los diferentes servicios OttoKare. Recuerda mantenerlo actualizado.",
                style: kStyleInformacionFormulario.copyWith(color: kAzulClaro),
              ),
            )
                : _vacunacion == 'No'
                ? Padding(
              key: const ValueKey("vacunacion_no"),
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Para solicitar los servicios OttoKare, su mascota debe contar con carnet de vacunación vigente. Te recomendamos gestionarlo y mantenerlo activo.",
                style: kStyleInformacionFormulario.copyWith(color: kAzulClaro),
              ),
            )
                : const SizedBox(key: ValueKey("vacunacion_off")),
          ),

          const SizedBox(height: 20),
          _label("Foto de tu mascota"),
          const SizedBox(height: 4),
          Text("Puedes agregar la foto de tu mascota después.",
              style: kStyleInformacionFormulario.copyWith(color: kTextInput)),
          const SizedBox(height: 8),
          _uploadBox(),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _acepta,
                activeColor: kAzulPrincipal,
                onChanged: (v) {
                  _showPdfModal();
                  setState(() => _acepta = v ?? false);
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showPdfModal();
                    setState(() => _acepta = !_acepta);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: kStyleInformacionFormulario,
                        children: [
                          TextSpan(text: "Conozco y acepto la ", style: TextStyle(color: kAzulPrincipal)),
                          TextSpan(
                            text: "Política de Tratamiento de Datos Personales.",
                            style: TextStyle(
                              color: kAzulClaro,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _btnSecondary("VOLVER", () => _goToStep(1)),
              _btnPrimary("Registrarse", () {
                if (_limitacion == null || _vacunacion == null) {
                  _showSnack("Responde todas las preguntas");
                } else if (!_acepta) {
                  _showSnack("Debes aceptar la política de datos");
                } else {
                  // Construir la mascota
                  final mascota = {
                    'nombre': _petNombreCtrl.text,
                    'gender': _sexo == 'Macho' ? 'M' : 'F',
                    'species': _especie?.toLowerCase() == 'perro' ? 'dog' : 'cat',
                    'raza': _raza ?? '',
                    'color': _colorCtrl.text,
                    'birth_date': _selectedDate?.toIso8601String(),
                    'defect': _limitacion == 'Si'
                        ? _limitacionCtrl.text
                        : 'La mascota no tiene defectos',
                    'carnet': _vacunacion == 'Si' ? _vacunacionCtrl.text : '',
                    'image_base64': _imageBytes != null
                        ? base64Encode(_imageBytes!)
                        : '',
                  };

                  // Disparar evento al BLoC
                  context.read<FormBloc>().add(
                    EnviarFormulario(
                      nombre: _nombreCtrl.text,
                      apellido: _apellidoCtrl.text,
                      cedula: _cedulaCtrl.text,
                      celular: _celularCtrl.text,
                      email: _emailCtrl.text,
                      ciudad: _ciudad ?? '',
                      direccion: _direccionCtrl.text,
                      contractId: widget.contractId,
                      mascotas: [mascota],
                    ),
                  );

                  _goToStep(3);
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  PASO 4 — Éxito
  // ═══════════════════════════════════════════════════════════════
  Widget _buildSuccess() {
    final petName = _petNombreCtrl.text.isNotEmpty ? _petNombreCtrl.text : "tu mascota";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
      child: Column(
        children: [
          // Tarjeta principal azul
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
              color: kAzulPrincipal,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const Icon(Icons.pets_rounded, size: 80, color: Colors.white24),
                    Container(
                      decoration: BoxDecoration(color: kAzulPrincipal, shape: BoxShape.circle),
                      child: const Icon(Icons.check_circle, color: kBlanco, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Text(
                  "¡$petName ya está protegido!",
                  style: kStyleMensajeConfirmacion,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 280,
                  child: Text(
                    "Tu plan está activo. A partir de hoy tu mascota tiene acceso a todos los beneficios de OttoKare.",
                    style: kStyleInformacionFormulario.copyWith(
                      color: kBlanco.withOpacity(0.9),
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ahora puedes acceder a",
                    style: kStyleEncabezadoFormWeb.copyWith(color: kAzulPrincipal)),
                const SizedBox(height: 6),
                Container(height: 3, width: 45, color: kAzulClaro),
              ],
            ),
          ),
          const SizedBox(height: 25),
          ..._beneficios.map((b) => _beneficioRow(b['icon']!, b['label']!)),
          const SizedBox(height: 28),
          // ── Contador de auto-reset ────────────────────────────
          Column(
            children: [
              Text(
                "Toca en cualquier lugar para registrar otra mascota",
                style: kStyleInformacionFormulario.copyWith(color: kTextInput),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Barra de progreso animada + número de segundos
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: _countdown / 10.0,
                      minHeight: 28,
                      backgroundColor: const Color(0xFFE1E1E6),
                      valueColor: AlwaysStoppedAnimation<Color>(kAzulPrincipal),
                    ),
                  ),
                  Text(
                    "Nuevo registro en $_countdown s",
                    style: GoogleFonts.montserrat(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: kBlanco,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  HELPERS DE UI
  // ═══════════════════════════════════════════════════════════════

  Widget _sectionTitle(String text) => Text(
    text,
    // Encabezado formulario: Quicksand Bold 22px (web/tablet)
    style: kStyleEncabezadoFormWeb,
  );

  Widget _label(String text, {bool required = false}) => RichText(
    text: TextSpan(
      // Label: Montserrat SemiBold 17px
      style: kStyleLabel,
      children: [
        TextSpan(text: text),
        if (required)
          TextSpan(text: " *", style: TextStyle(color: kAzulClaro)),
      ],
    ),
  );

  Widget _field(
      String label,
      TextEditingController ctrl, {
        String hint = '',
        bool required = false,
        TextInputType inputType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: required),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          // Input: Montserrat Medium 17px
          style: kStyleInput,
          decoration: _inputDeco(hint),
          validator: validator ??
              (required
                  ? (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null
                  : null),
        ),
      ],
    );
  }

  Widget _razaAutocomplete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Raza", required: true),
        const SizedBox(height: 6),
        KeyedSubtree(
          key: ValueKey(_especie), // Se reconstruye al cambiar Perro ↔ Gato
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) return const Iterable.empty();
              return _razas.where((raza) =>
                  raza.toLowerCase().contains(textEditingValue.text.toLowerCase()));
            },
            onSelected: (String selection) {
              setState(() {
                _raza = selection;
                final lista = _especie == 'Perro' ? razasPerros : razasGatos;
                _razaCodigo = lista.firstWhere((r) => r.nombre == selection).codigo;
              });
            },
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                style: kStyleInput,
                enabled: _especie != null,
                decoration: _inputDeco(
                  _especie != null
                      ? "Escribe para buscar la raza..."
                      : "Selecciona primero la especie",
                ),
                onChanged: (v) {
                  if (v.isEmpty) setState(() { _raza = null; _razaCodigo = null; });
                },
                validator: (_) =>
                (_raza == null || _raza!.isEmpty) ? 'Campo requerido' : null,
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220, maxWidth: 500),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final raza = options.elementAt(index);
                        return ListTile(
                          dense: true,
                          title: Text(raza, style: kStyleInput),
                          onTap: () => onSelected(raza),
                          hoverColor: kTealLight,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  Widget _ciudadAutocomplete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Ciudad", required: true),
        const SizedBox(height: 6),
        Autocomplete<String>(
          initialValue: _ciudad != null
              ? TextEditingValue(text: _ciudad!)
              : TextEditingValue.empty,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) return const Iterable.empty();
            return _ciudades.where((ciudad) =>
                ciudad.toLowerCase().contains(
                    textEditingValue.text.toLowerCase()));
          },
          onSelected: (String selection) {
            setState(() => _ciudad = selection);
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              style: kStyleInput,
              decoration: _inputDeco("Escribe para buscar tu ciudad..."),
              onChanged: (v) {
                if (v.isEmpty) setState(() => _ciudad = null);
              },
              validator: (_) =>
              (_ciudad == null || _ciudad!.isEmpty)
                  ? 'Campo requerido'
                  : null,
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: 220, maxWidth: 500),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final ciudad = options.elementAt(index);
                      return ListTile(
                        dense: true,
                        title: Text(ciudad, style: kStyleInput),
                        onTap: () => onSelected(ciudad),
                        hoverColor: kTealLight,
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _dateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Fecha de nacimiento", required: true),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: kBorder),
              borderRadius: BorderRadius.circular(8),
              color: kBlanco,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _fechaNac ?? "Selecciona la fecha de nacimiento",
                  // Input: Montserrat Medium 17px
                  style: kStyleInput.copyWith(
                    color: _fechaNac != null ? kAzulPrincipal : kTextInput,
                  ),
                ),
                const Icon(Icons.calendar_today, size: 18, color: kTextInput),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    // Hint / placeholder: Montserrat Medium, color kTextInput (#8E8E8E)
    hintStyle: kStyleInput.copyWith(color: kTextInput),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kBorder)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kBorder)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kAzulPrincipal, width: 1.5)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kRojo)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kRojo, width: 1.5)),
    // Warning: Montserrat SemiBold 12px, color kRojo
    errorStyle: kStyleWarning,
    filled: true,
    fillColor: kBlanco,
  );

  Widget _toggleBtn({
    required String label,
    required String iconPath,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return _HoverToggleButton(
      label: label,
      iconPath: iconPath,
      selected: selected,
      onTap: onTap,
    );
  }

  Widget _yesNoBtn(String text,
      {required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? kAzulPrincipal : kBlanco,
          border: Border.all(
              color: selected ? kAzulPrincipal : kBorder,
              width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            // Input Buttons: Quicksand Bold 16px
            style: kStyleInputButtons.copyWith(
              color: selected ? kBlanco : kAzulPrincipal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _uploadBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.all(_hasImage ? 14 : 24),
      decoration: BoxDecoration(
        color: kBgCard,
        border: Border.all(color: kAzulPrincipal, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _hasImage ? _fileLoaded() : _fileEmpty(),
      ),
    );
  }

  Widget _fileEmpty() {
    return Column(
      key: const ValueKey("empty"),
      children: [
        Icon(Icons.upload_rounded, color: kAzulPrincipal, size: 28),
        const SizedBox(height: 8),
        Text(
          "Arrastra y suelta tu archivo aquí, o da clic para seleccionar",
          style: kStyleInformacionFormulario.copyWith(color: kTextInput),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: kAzulPrincipal,
            foregroundColor: kBlanco,
          ),
          // Input Buttons: Quicksand Bold 16px
          child: Text("Subir imagen", style: kStyleInputButtons),
        ),
        const SizedBox(height: 8),
        Text(
          "Formato PNG, JPEG. Máximo 200KB",
          style: kStyleWarning.copyWith(color: kTextInput),
        ),
      ],
    );
  }

  Widget _fileLoaded() {
    return Row(
      key: const ValueKey("loaded"),
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kTealLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.image, color: kAzulPrincipal),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _imageName ?? "imagen.png",
            style: kStyleInformacionFormulario,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: _removeImage,
          child: const Icon(Icons.close, size: 18),
        ),
      ],
    );
  }

  Widget _beneficioRow(String iconPath, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFD6E6E9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kAzulPrincipal, width: 1.5),
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: 28, height: 28),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                // Label: Montserrat SemiBold 17px
                style: kStyleLabel.copyWith(color: kAzulPrincipal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnPrimary(String text, VoidCallback onTap) => ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: kAzulPrincipal,
      foregroundColor: kBlanco,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    // Texto para botones: Montserrat Bold 16px
    child: Text(text, style: kStyleTextosBotones.copyWith(color: kBlanco)),
  );

  Widget _btnSecondary(String text, VoidCallback onTap) => OutlinedButton(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      foregroundColor: kAzulPrincipal,
      side: BorderSide(color: kAzulPrincipal),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    // Texto para botones: Montserrat Bold 16px
    child: Text(text, style: kStyleTextosBotones.copyWith(color: kAzulPrincipal)),
  );

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: kStyleInformacionFormulario.copyWith(color: kBlanco)),
        backgroundColor: kAzulPrincipal,
      ),
    );
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.size > 200 * 1024) { _showSnack("La imagen supera los 200KB"); return; }
      setState(() { _imageBytes = file.bytes; _imageName = file.name; _hasImage = true; });
    }
  }

  void _removeImage() {
    setState(() { _imageBytes = null; _imageName = null; _hasImage = false; });
  }

  static const List<Map<String, String>> _beneficios = [
    {'icon': 'lib/ui/img/icon-orientacion-veterinaria.svg', 'label': 'Orientación veterinaria'},
    {'icon': 'lib/ui/img/icon-hospedaje.svg',               'label': 'Hospedaje'},
    {'icon': 'lib/ui/img/icon-asistencia-telefonica.svg',   'label': 'Asistencia telefónica'},
    {'icon': 'lib/ui/img/icon-hospitalizacion.svg',         'label': 'Hospitalización'},
    {'icon': 'lib/ui/img/icon-mucho-mas.svg',               'label': 'Y mucho más'},
  ];
}

// ═══════════════════════════════════════════════════════════════════
//  STEPPER
// ═══════════════════════════════════════════════════════════════════
class _Stepper extends StatelessWidget {
  final int step;
  const _Stepper({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorder, width: 1.2)),
      ),
      child: Row(
        children: [
          Expanded(child: _stepItem(0, "Tus datos")),
          _chevron(),
          Expanded(child: Center(child: _stepItem(1, "Tu mascota"))),
          _chevron(),
          Expanded(child: Align(
              alignment: Alignment.centerRight,
              child: _stepItem(2, "Condición de tu mascota"))),
        ],
      ),
    );
  }

  Widget _stepItem(int index, String label) {
    final bool done    = step > index;
    final bool active  = step == index;
    final bool pending = step < index;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 32, height: 32,
          decoration: BoxDecoration(
            // done → kPasoCompletado (#1D8841)
            // active → kAzulPrincipal (#005871)
            // pending → kPasoFaltante (#E1E1E6) con borde
            color: done
                ? kPasoCompletado
                : active
                ? kAzulPrincipal
                : kPasoFaltante,
            border: Border.all(
              color: pending ? kBorder : Colors.transparent,
              width: 1.5,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check, color: kBlanco, size: 15)
                : Text(
              "${index + 1}",
              style: GoogleFonts.quicksand(
                // Pasos formulario: Quicksand Bold 16px
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: active ? kBlanco : kTextInput,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          // Pasos formulario: Quicksand Bold 16px
          style: GoogleFonts.quicksand(
            fontSize: 13,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: pending ? kTextInput : kAzulPrincipal,
          ),
        ),
      ],
    );
  }

  Widget _chevron() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Icon(Icons.chevron_right, size: 18, color: kBorder),
  );


}

// ═══════════════════════════════════════════════════════════════════
//  TOGGLE BUTTON CON HOVER ANIMATION
// ═══════════════════════════════════════════════════════════════════
class _HoverToggleButton extends StatefulWidget {
  final String label;
  final String iconPath;
  final bool selected;
  final VoidCallback onTap;

  const _HoverToggleButton({
    required this.label,
    required this.iconPath,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_HoverToggleButton> createState() => _HoverToggleButtonState();
}

class _HoverToggleButtonState extends State<_HoverToggleButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool highlight = widget.selected || _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: highlight ? kAzulPrincipal : kBlanco,
            border: Border.all(
              color: highlight ? kAzulPrincipal : kBorder,
              width: highlight ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                widget.iconPath,
                width: 22, height: 22,
                colorFilter: ColorFilter.mode(
                  highlight ? kBlanco : kAzulPrincipal,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                // Input Buttons: Quicksand Bold 16px
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: highlight ? kBlanco : kAzulPrincipal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}