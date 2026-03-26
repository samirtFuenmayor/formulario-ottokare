import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ═══════════════════════════════════════════════════════════════════
//  COLORES GLOBALES
// ═══════════════════════════════════════════════════════════════════
const Color kTeal        = Color(0xFF0D7A8A);
const Color kTealLight   = Color(0xFFE6F4F6);
const Color kTealSuccess = Color(0xFF1A9E6E);
const Color kTextDark    = Color(0xFF1B3A4B);
const Color kTextMuted   = Color(0xFF6B7C85);
const Color kBorder      = Color(0xFFCDD8DC);
const Color kBgCard      = Color(0xFFF0F7F9);

// ═══════════════════════════════════════════════════════════════════
//  WIDGET PRINCIPAL
// ═══════════════════════════════════════════════════════════════════
class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

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
  String? _sexo;      // 'Macho' | 'Hembra'
  String? _especie;   // 'Perro'  | 'Gato'
  String? _raza;

  // ── Datos paso 3 ──────────────────────────────────────────────
  String? _limitacion;   // 'Si' | 'No'
  String? _vacunacion;   // 'Si' | 'No'
  bool    _acepta = false;

  // ── Form keys ─────────────────────────────────────────────────
  final _key1 = GlobalKey<FormState>();
  final _key2 = GlobalKey<FormState>();
  final _key3 = GlobalKey<FormState>();

  // ── Ciudades de ejemplo ───────────────────────────────────────
  final List<String> _ciudades = [
    'Quito', 'Guayaquil', 'Cuenca', 'Ambato',
    'Loja', 'Manta', 'Machala', 'Santo Domingo',
  ];

  // ── Razas de ejemplo ─────────────────────────────────────────
  List<String> get _razas {
    if (_especie == 'Perro') {
      return ['Labrador', 'Golden Retriever', 'Bulldog', 'Poodle',
        'Chihuahua', 'Husky', 'Pastor Alemán', 'Otra'];
    } else if (_especie == 'Gato') {
      return ['Siamés', 'Persa', 'Maine Coon', 'Bengalí',
        'Ragdoll', 'Mestizo', 'Otra'];
    }
    return [];
  }

  // ── Años para fecha de nacimiento ────────────────────────────
  final List<String> _fechas = List.generate(
    20,
        (i) => (DateTime.now().year - i).toString(),
  );

  @override
  void dispose() {
    _nombreCtrl.dispose();  _apellidoCtrl.dispose();
    _cedulaCtrl.dispose();  _celularCtrl.dispose();
    _emailCtrl.dispose();   _direccionCtrl.dispose();
    _petNombreCtrl.dispose(); _colorCtrl.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.white,
        child: _step == 3 ? _buildSuccess() : _buildForm(),
      ),
    );
  }

  // ── Wrapper con stepper + scroll ─────────────────────────────
  Widget _buildForm() {
    return Column(
      children: [
        _Stepper(step: _step),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
            child: [
              _buildStep1(),
              _buildStep2(),
              _buildStep3(),
            ][_step],
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
          _dropdown("Ciudad", _ciudades, _ciudad,
              hint: "Selecciona tu ciudad de residencia",
              onChanged: (v) => setState(() { _ciudad = v; _raza = null; })),
          const SizedBox(height: 14),
          _field("Dirección", _direccionCtrl,
              hint: "Ingresa tu dirección actual", required: true),
          const SizedBox(height: 28),
          Align(
            alignment: Alignment.centerRight,
            child: _btnPrimary("Continuar", () {
              if (_key1.currentState!.validate() && _ciudad != null) {
                setState(() => _step = 1);
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
        children: [
          _sectionTitle("Ingresa los datos de tu mascota"),
          const SizedBox(height: 20),
          _field("Nombre", _petNombreCtrl,
              hint: "Ej. Firulais", required: true),
          const SizedBox(height: 14),
          _dropdown("Fecha de nacimiento", _fechas, _fechaNac,
              hint: "Selecciona la fecha de nacimiento",
              onChanged: (v) => setState(() => _fechaNac = v)),
          const SizedBox(height: 14),
          _label("Sexo", required: true),
          const SizedBox(height: 8),
          Row(
            children: [
              _toggleBtn(
                label: "Macho",
                iconPath: 'lib/ui/img/icon_macho.png',
                selected: _sexo == 'Macho',
                onTap: () => setState(() => _sexo = 'Macho'),
              ),
              const SizedBox(width: 12),
              _toggleBtn(
                label: "Hembra",
                iconPath: 'lib/ui/img/icon_hembra.png',
                selected: _sexo == 'Hembra',
                onTap: () => setState(() => _sexo = 'Hembra'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _label("Especie", required: true),
          const SizedBox(height: 8),
          Row(
            children: [
              _toggleBtn(
                label: "Perro",
                iconPath: 'lib/ui/img/icon_perro.png',
                selected: _especie == 'Perro',
                onTap: () => setState(() {
                  _especie = 'Perro';
                  _raza = null;
                }),
              ),
              const SizedBox(width: 12),
              _toggleBtn(
                label: "Gato",
                iconPath: 'lib/ui/img/icon_gato.png',
                selected: _especie == 'Gato',
                onTap: () => setState(() {
                  _especie = 'Gato';
                  _raza = null;
                }),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _dropdown("Raza", _razas, _raza,
              hint: "Selecciona la raza de tu mascota",
              onChanged: (v) => setState(() => _raza = v)),
          const SizedBox(height: 14),
          _field("Color(es) de pelaje", _colorCtrl,
              hint: "Describe el color(es) de tu mascota", required: true),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _btnSecondary("Volver", () => setState(() => _step = 0)),
              _btnPrimary("Continuar", () {
                if (_key2.currentState!.validate() &&
                    _sexo != null && _especie != null &&
                    _fechaNac != null && _raza != null) {
                  setState(() => _step = 2);
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
        children: [
          _sectionTitle("Ingresa la condición de salud de tu mascota"),
          const SizedBox(height: 4),
          Text("Tu respuesta no va a afectar el precio de tu plan.",
              style: TextStyle(color: kTextMuted, fontSize: 13)),
          const SizedBox(height: 20),
          _label("¿Tu mascota posee alguna limitación física o enfermedad?",
              required: true),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _yesNoBtn("Si",
                  selected: _limitacion == 'Si',
                  onTap: () => setState(() => _limitacion = 'Si'))),
              const SizedBox(width: 12),
              Expanded(child: _yesNoBtn("No",
                  selected: _limitacion == 'No',
                  onTap: () => setState(() => _limitacion = 'No'))),
            ],
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
                  onTap: () => setState(() => _vacunacion = 'No'))),
            ],
          ),
          const SizedBox(height: 20),
          _label("Foto de tu mascota"),
          const SizedBox(height: 4),
          Text("Puedes agregar la foto de tu mascota después.",
              style: TextStyle(color: kTextMuted, fontSize: 13)),
          const SizedBox(height: 8),
          _uploadBox(),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _acepta,
                activeColor: kTeal,
                onChanged: (v) => setState(() => _acepta = v ?? false),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _acepta = !_acepta),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: kTextDark, fontSize: 13),
                        children: [
                          const TextSpan(text: "Conozco y acepto la "),
                          TextSpan(
                            text: "Política de Tratamiento de Datos Personales.",
                            style: TextStyle(
                                color: kTeal,
                                decoration: TextDecoration.underline),
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
              _btnSecondary("VOLVER", () => setState(() => _step = 1)),
              _btnPrimary("Registrarse", () {
                if (_limitacion == null || _vacunacion == null) {
                  _showSnack("Responde todas las preguntas");
                } else if (!_acepta) {
                  _showSnack("Debes aceptar la política de datos");
                } else {
                  setState(() => _step = 3);
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
    final petName = _petNombreCtrl.text.isNotEmpty
        ? _petNombreCtrl.text
        : "tu mascota";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: kTeal,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Image.asset('lib/ui/img/icon_paw.png',
                        width: 48, color: Colors.white54,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.pets, size: 48, color: Colors.white54)),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: kTealSuccess, shape: BoxShape.circle),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "¡$petName ya esta protegido!",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Tu plan está activo. A partir de hoy tu mascota tiene acceso a todos los beneficios de OttoKare.",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Ahora puedes acceder a",
                style: TextStyle(
                    color: kTextDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          ..._beneficios.map((b) => _beneficioRow(b['icon']!, b['label']!)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  HELPERS DE UI
  // ═══════════════════════════════════════════════════════════════

  Widget _sectionTitle(String text) => Text(
    text,
    style: TextStyle(
        color: kTextDark, fontSize: 18, fontWeight: FontWeight.bold),
  );

  Widget _label(String text, {bool required = false}) => RichText(
    text: TextSpan(
      style: TextStyle(
          color: kTextDark, fontSize: 13, fontWeight: FontWeight.w600),
      children: [
        TextSpan(text: text),
        if (required)
          TextSpan(text: " *", style: TextStyle(color: kTeal)),
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
          decoration: _inputDeco(hint),
          validator: validator ??
              (required
                  ? (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null
                  : null),
        ),
      ],
    );
  }

  Widget _dropdown(
      String label,
      List<String> items,
      String? value, {
        String hint = '',
        required void Function(String?) onChanged,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: true),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint,
              style: TextStyle(color: kTextMuted, fontSize: 14)),
          decoration: _inputDeco(''),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: kTextMuted, fontSize: 14),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kBorder)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kBorder)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kTeal, width: 1.5)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red)),
    filled: true,
    fillColor: Colors.white,
  );

  // Botón toggle con ícono (Macho/Hembra/Perro/Gato)
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

  // Botón Sí/No
  Widget _yesNoBtn(String text,
      {required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? kTeal : Colors.white,
          border: Border.all(
              color: selected ? kTeal : kBorder, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : kTextDark,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _uploadBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kBgCard,
        border: Border.all(color: kTeal, width: 1.5,
            style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(Icons.upload_rounded, color: kTeal, size: 28),
          const SizedBox(height: 8),
          Text(
            "Arrastra y suelta tu archivo aquí, o da clic para seleccionar",
            style: TextStyle(color: kTextMuted, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {}, // TODO: file picker
            style: ElevatedButton.styleFrom(
              backgroundColor: kTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text("Subir imagen"),
          ),
          const SizedBox(height: 8),
          Text("Formato PNG, JPEG. Máximo 200KB",
              style: TextStyle(color: kTextMuted, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _beneficioRow(String iconPath, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: kTealLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 24, height: 24,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.star, color: kTeal, size: 22)),
            const SizedBox(width: 14),
            Text(label,
                style: TextStyle(color: kTextDark, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _btnPrimary(String text, VoidCallback onTap) =>
      ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kTextDark,
          foregroundColor: Colors.white,
          padding:
          const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _btnSecondary(String text, VoidCallback onTap) =>
      OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: kTextDark,
          side: BorderSide(color: kTextDark),
          padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: kTeal),
    );
  }

  static const List<Map<String, String>> _beneficios = [
    {'icon': 'lib/ui/img/icon_vet.png',    'label': 'Orientación veterinaria'},
    {'icon': 'lib/ui/img/icon_hospedaje.png', 'label': 'Hospedaje'},
    {'icon': 'lib/ui/img/icon_tel.png',    'label': 'Asistencia telefónica'},
    {'icon': 'lib/ui/img/icon_hosp.png',   'label': 'Hospitalización'},
    {'icon': 'lib/ui/img/icon_mas.png',    'label': 'Y mucho más'},
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
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorder)),
      ),
      child: Row(
        children: [
          _stepItem(0, "Tus datos"),
          _divider(step > 0),
          _stepItem(1, "Tu mascota"),
          _divider(step > 1),
          _stepItem(2, "Condición de tu mascota"),
        ],
      ),
    );
  }

  Widget _stepItem(int index, String label) {
    final bool done    = step > index;
    final bool active  = step == index;
    final bool pending = step < index;

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: done
                ? kTealSuccess
                : active
                ? kTeal
                : Colors.transparent,
            border: Border.all(
              color: pending ? kBorder : Colors.transparent,
              width: 1.5,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : Text(
              "${index + 1}",
              style: TextStyle(
                color: active ? Colors.white : kTextMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: pending ? kTextMuted : kTextDark,
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _divider(bool done) => Expanded(
    child: Container(
      height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: done ? kTealSuccess : kBorder,
    ),
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
            color: highlight ? kTeal : Colors.white,
            border: Border.all(
              color: highlight ? kTeal : kBorder,
              width: highlight ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                widget.iconPath,
                width: 22, height: 22,
                color: highlight ? Colors.white : kTeal,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.pets,
                  size: 20,
                  color: highlight ? Colors.white : kTeal,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: highlight ? Colors.white : kTextDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}