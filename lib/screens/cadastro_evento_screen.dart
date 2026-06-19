import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../models/modalidade.dart';

class CadastroEventoScreen extends StatefulWidget {
  const CadastroEventoScreen({super.key});

  @override
  State<CadastroEventoScreen> createState() => _CadastroEventoScreenState();
}

class _CadastroEventoScreenState extends State<CadastroEventoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tituloCtrl = TextEditingController();
  final _localCtrl = TextEditingController();
  final _organizadorCtrl = TextEditingController();
  final _maxJogCtrl = TextEditingController();

  Modalidade _modalidade = Modalidade.futebol;
  DateTime _data = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _hora = const TimeOfDay(hour: 15, minute: 0);

  static const _bg = Color(0xFF0B1120);
  static const _surface = Color(0xFF0F1E35);
  static const _green = Color(0xFF2979FF);

  @override
  void initState() {
    super.initState();
    _maxJogCtrl.text = _modalidade.maxJogadoresPadrao.toString();
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _localCtrl.dispose();
    _organizadorCtrl.dispose();
    _maxJogCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        title: const Text(
          'Novo Evento',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.close_rounded,
                size: 18, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.06),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            _buildModalidadeSection(),
            const SizedBox(height: 24),
            _buildLabel('Título do Evento'),
            const SizedBox(height: 8),
            _buildCampoTexto(
              controller: _tituloCtrl,
              hint: 'Ex: Pelada das Quintas',
              icone: Icons.title_rounded,
              validator: (v) => v == null || v.isEmpty ? 'Informe um título' : null,
            ),
            const SizedBox(height: 20),
            _buildLabel('Local'),
            const SizedBox(height: 8),
            _buildCampoTexto(
              controller: _localCtrl,
              hint: 'Ex: Campo do Bairro, Caxias - MA',
              icone: Icons.location_on_rounded,
              validator: (v) => v == null || v.isEmpty ? 'Informe o local' : null,
            ),
            const SizedBox(height: 20),
            _buildLabel('Data e Hora'),
            const SizedBox(height: 8),
            _buildSeletorDataHora(),
            const SizedBox(height: 20),
            _buildLabel('Organizador'),
            const SizedBox(height: 8),
            _buildCampoTexto(
              controller: _organizadorCtrl,
              hint: 'Seu nome',
              icone: Icons.person_rounded,
              validator: (v) => v == null || v.isEmpty ? 'Informe o organizador' : null,
            ),
            const SizedBox(height: 20),
            _buildLabel('Máximo de Jogadores'),
            const SizedBox(height: 8),
            _buildCampoTexto(
              controller: _maxJogCtrl,
              hint: _modalidade.maxJogadoresPadrao.toString(),
              icone: Icons.group_rounded,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Informe o máximo';
                final n = int.tryParse(v);
                if (n == null || n < 2) return 'Mínimo 2 jogadores';
                return null;
              },
            ),
            const SizedBox(height: 32),
            _buildBotaoCriar(),
          ],
        ),
      ),
    );
  }

  // ─── MODALIDADE ────────────────────────────────────────────────────────────

  Widget _buildModalidadeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Modalidade'),
        const SizedBox(height: 10),
        Row(
          children: Modalidade.values.map((m) {
            final sel = _modalidade == m;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: m != Modalidade.values.last ? 8 : 0,
                ),
                child: GestureDetector(
                  onTap: () => setState(() {
                    _modalidade = m;
                    _maxJogCtrl.text = m.maxJogadoresPadrao.toString();
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: sel ? m.cor.withOpacity(0.18) : _surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: sel ? m.cor : Colors.white.withOpacity(0.08),
                        width: sel ? 1.5 : 1,
                      ),
                      boxShadow: sel
                          ? [
                              BoxShadow(
                                color: m.cor.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        Text(m.emoji,
                            style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(
                          m.label,
                          style: TextStyle(
                            color: sel
                                ? m.cor
                                : Colors.white.withOpacity(0.45),
                            fontSize: 11,
                            fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── DATA E HORA ───────────────────────────────────────────────────────────

  Widget _buildSeletorDataHora() {
    return Row(
      children: [
        Expanded(
          child: _BotaoSeletor(
            icone: Icons.calendar_today_rounded,
            texto: _formatarData(_data),
            onTap: _selecionarData,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _BotaoSeletor(
            icone: Icons.access_time_rounded,
            texto: _hora.format(context),
            onTap: _selecionarHora,
          ),
        ),
      ],
    );
  }

  // ─── BOTÃO CRIAR ───────────────────────────────────────────────────────────

  Widget _buildBotaoCriar() {
    final cor = _modalidade.cor;
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cor, cor.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cor.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _criarEvento,
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_rounded, size: 20, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Criar Evento',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── HELPERS ───────────────────────────────────────────────────────────────

  Widget _buildLabel(String texto) {
    return Text(
      texto.toUpperCase(),
      style: TextStyle(
        color: Colors.white.withOpacity(0.35),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.8,
      ),
    );
  }

  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String hint,
    required IconData icone,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      cursorColor: _green,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: Colors.white.withOpacity(0.22), fontSize: 14),
        prefixIcon: Icon(icone, color: _green.withOpacity(0.7), size: 18),
        filled: true,
        fillColor: _surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _green, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
      ),
    );
  }

  // ─── LÓGICA ────────────────────────────────────────────────────────────────

  String _formatarData(DateTime d) {
    final dias = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    final meses = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return '${dias[d.weekday % 7]}, ${d.day} ${meses[d.month - 1]}';
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _green,
            surface: Color(0xFF0F1E35),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _data = picked);
  }

  Future<void> _selecionarHora() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _hora,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _green,
            surface: Color(0xFF0F1E35),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _hora = picked);
  }

  void _criarEvento() {
    if (!_formKey.currentState!.validate()) return;

    final dataHora = DateTime(
      _data.year,
      _data.month,
      _data.day,
      _hora.hour,
      _hora.minute,
    );

    final novo = Evento(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: _tituloCtrl.text.trim(),
      local: _localCtrl.text.trim(),
      dataHora: dataHora,
      modalidade: _modalidade,
      organizador: _organizadorCtrl.text.trim(),
      maxJogadores: int.parse(_maxJogCtrl.text.trim()),
    );

    Navigator.pop(context, novo);
  }
}

// ─── BOTÃO SELETOR ────────────────────────────────────────────────────────────

class _BotaoSeletor extends StatelessWidget {
  final IconData icone;
  final String texto;
  final VoidCallback onTap;

  const _BotaoSeletor({
    required this.icone,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1E35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(icone,
                color: const Color(0xFF2979FF).withOpacity(0.7), size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                texto,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.expand_more_rounded,
                color: Colors.white.withOpacity(0.25), size: 18),
          ],
        ),
      ),
    );
  }
}
