import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';
import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../models/modalidade.dart';
import '../services/cep_service.dart';

class CadastroEventoScreen extends StatefulWidget {
  CadastroEventoScreen({super.key});

  @override
  State<CadastroEventoScreen> createState() => _CadastroEventoScreenState();
}

class _CadastroEventoScreenState extends State<CadastroEventoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tituloCtrl = TextEditingController();
  final _localCtrl = TextEditingController();
  final _organizadorCtrl = TextEditingController();
  final _maxJogCtrl = TextEditingController();

  // Endereço / CEP
  final _cepCtrl = TextEditingController();
  final _bairroCtrl = TextEditingController();
  final _cidadeCtrl = TextEditingController();
  final _estadoCtrl = TextEditingController();

  bool _buscandoCep = false;
  String? _erroCep;

  Modalidade _modalidade = Modalidade.futebol;
  DateTime _data = DateTime.now().add(Duration(days: 1));
  TimeOfDay _hora = TimeOfDay(hour: 15, minute: 0);

  static Color get _bg => AppColors.bg;
  static Color get _surface => AppColors.surface;
  static const Color _green = Color(0xFF2979FF);

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
    _cepCtrl.dispose();
    _bairroCtrl.dispose();
    _cidadeCtrl.dispose();
    _estadoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        title: Text(
          'Novo Evento',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppColors.text,
            letterSpacing: -0.3,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.text.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.close_rounded,
                size: 18, color: AppColors.text),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.text.withOpacity(0.08),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            _buildModalidadeSection(),
            SizedBox(height: 24),
            _buildLabel('Título do Evento'),
            SizedBox(height: 8),
            _buildCampoTexto(
              controller: _tituloCtrl,
              hint: 'Ex: Pelada das Quintas',
              icone: Icons.title_rounded,
              validator: (v) => v == null || v.isEmpty ? 'Informe um título' : null,
            ),
            SizedBox(height: 20),
            _buildLabel('Local'),
            SizedBox(height: 8),
            _buildCampoTexto(
              controller: _localCtrl,
              hint: 'Ex: Campo do Bairro, Caxias - MA',
              icone: Icons.location_on_rounded,
              validator: (v) => v == null || v.isEmpty ? 'Informe o local' : null,
            ),
            SizedBox(height: 20),
            _buildLabel('CEP'),
            SizedBox(height: 8),
            _buildCampoCep(),
            SizedBox(height: 20),
            _buildLabel('Bairro'),
            SizedBox(height: 8),
            _buildCampoTexto(
              controller: _bairroCtrl,
              hint: 'Ex: Centro',
              icone: Icons.holiday_village_rounded,
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Cidade'),
                      SizedBox(height: 8),
                      _buildCampoTexto(
                        controller: _cidadeCtrl,
                        hint: 'Ex: Caxias',
                        icone: Icons.location_city_rounded,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('UF'),
                      SizedBox(height: 8),
                      _buildCampoTexto(
                        controller: _estadoCtrl,
                        hint: 'MA',
                        icone: Icons.map_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildLabel('Data e Hora'),
            SizedBox(height: 8),
            _buildSeletorDataHora(),
            SizedBox(height: 20),
            _buildLabel('Organizador'),
            SizedBox(height: 8),
            _buildCampoTexto(
              controller: _organizadorCtrl,
              hint: 'Seu nome',
              icone: Icons.person_rounded,
              validator: (v) => v == null || v.isEmpty ? 'Informe o organizador' : null,
            ),
            SizedBox(height: 20),
            _buildLabel('Máximo de Jogadores'),
            SizedBox(height: 8),
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
            SizedBox(height: 32),
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
        SizedBox(height: 10),
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
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: sel ? m.cor.withOpacity(0.18) : _surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: sel ? m.cor : AppColors.text.withOpacity(0.07),
                        width: sel ? 1.5 : 1,
                      ),
                      boxShadow: sel
                          ? [
                              BoxShadow(
                                color: m.cor.withOpacity(0.2),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        Text(m.emoji,
                            style: TextStyle(fontSize: 26)),
                        SizedBox(height: 6),
                        Text(
                          m.label,
                          style: TextStyle(
                            color: sel
                                ? m.cor
                                : AppColors.text.withOpacity(0.55),
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
        SizedBox(width: 10),
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

  Widget _buildCampoCep() {
    return TextFormField(
      controller: _cepCtrl,
      keyboardType: TextInputType.number,
      style: TextStyle(color: AppColors.text, fontSize: 14),
      cursorColor: _green,
      onChanged: (valor) {
        final mascarado = CepService.aplicarMascara(valor);
        if (mascarado != valor) {
          _cepCtrl.value = TextEditingValue(
            text: mascarado,
            selection: TextSelection.collapsed(offset: mascarado.length),
          );
        }
        if (_erroCep != null) setState(() => _erroCep = null);
        final digitos = mascarado.replaceAll(RegExp(r'[^0-9]'), '');
        if (digitos.length == 8) {
          _buscarCep(mascarado);
        }
      },
      validator: (v) {
        if (v == null || v.isEmpty) return 'Informe o CEP';
        final digitos = v.replaceAll(RegExp(r'[^0-9]'), '');
        if (digitos.length != 8) return 'CEP inválido';
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Ex: 65600-000',
        hintStyle:
            TextStyle(color: AppColors.text.withOpacity(0.35), fontSize: 14),
        prefixIcon: Icon(Icons.markunread_mailbox_rounded,
            color: _green.withOpacity(0.7), size: 18),
        suffixIcon: _buscandoCep
            ? Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _green,
                  ),
                ),
              )
            : null,
        filled: true,
        fillColor: _surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.text.withOpacity(0.07)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.text.withOpacity(0.07)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _green, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorText: _erroCep,
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 11),
      ),
    );
  }

  Future<void> _buscarCep(String cep) async {
    setState(() {
      _buscandoCep = true;
      _erroCep = null;
    });
    try {
      final endereco = await CepService.buscar(cep);
      if (!mounted) return;
      setState(() {
        _bairroCtrl.text = endereco.bairro;
        _cidadeCtrl.text = endereco.cidade;
        _estadoCtrl.text = endereco.estado;
        // Se o campo Local ainda estiver vazio, sugere o logradouro.
        if (_localCtrl.text.isEmpty && endereco.logradouro.isNotEmpty) {
          _localCtrl.text = endereco.logradouro;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _erroCep = e.toString());
    } finally {
      if (mounted) setState(() => _buscandoCep = false);
    }
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
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _criarEvento,
          child: Center(
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
        color: AppColors.text.withOpacity(0.45),
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
      style: TextStyle(color: AppColors.text, fontSize: 14),
      cursorColor: _green,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: AppColors.text.withOpacity(0.35), fontSize: 14),
        prefixIcon: Icon(icone, color: _green.withOpacity(0.7), size: 18),
        filled: true,
        fillColor: _surface,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.text.withOpacity(0.07)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.text.withOpacity(0.07)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _green, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 11),
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
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: isDarkMode
              ? ColorScheme.dark(
                  primary: _green,
                  surface: AppColors.surface,
                  onSurface: AppColors.text,
                )
              : ColorScheme.light(
                  primary: _green,
                  surface: AppColors.surface,
                  onSurface: AppColors.text,
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
          colorScheme: isDarkMode
              ? ColorScheme.dark(
                  primary: _green,
                  surface: AppColors.surface,
                  onSurface: AppColors.text,
                )
              : ColorScheme.light(
                  primary: _green,
                  surface: AppColors.surface,
                  onSurface: AppColors.text,
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
      cep: _cepCtrl.text.trim(),
      bairro: _bairroCtrl.text.trim(),
      cidade: _cidadeCtrl.text.trim(),
      estado: _estadoCtrl.text.trim(),
    );

    Navigator.pop(context, novo);
  }
}

// ─── BOTÃO SELETOR ────────────────────────────────────────────────────────────

class _BotaoSeletor extends StatelessWidget {
  final IconData icone;
  final String texto;
  final VoidCallback onTap;

  _BotaoSeletor({
    required this.icone,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.text.withOpacity(0.07)),
        ),
        child: Row(
          children: [
            Icon(icone,
                color: Color(0xFF2979FF).withOpacity(0.7), size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.expand_more_rounded,
                color: AppColors.text.withOpacity(0.4), size: 18),
          ],
        ),
      ),
    );
  }
}
