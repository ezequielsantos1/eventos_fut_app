import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';
import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../models/eventos_provider.dart';
import '../models/modalidade.dart';
import '../widgets/card_evento.dart';
import '../widgets/chip_filtro.dart';
import 'cadastro_evento_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventosProvider _provider = EventosProvider();
  final String _userId = 'eu';
  Modalidade? _filtro;

  List<Evento> get _eventosFiltrados => _provider.filtrarPor(_filtro);

  @override
  void initState() {
    super.initState();
    _provider.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildFiltros()),
          SliverToBoxAdapter(child: _buildContador()),
          _eventosFiltrados.isEmpty
              ? SliverFillRemaining(child: _buildVazio())
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final evento = _eventosFiltrados[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: CardEvento(
                            evento: evento,
                            userId: _userId,
                            onConfirmar: () =>
                                _provider.confirmarPresenca(evento.id, _userId),
                          ),
                        );
                      },
                      childCount: _eventosFiltrados.length,
                    ),
                  ),
                ),
          SliverPadding(padding: EdgeInsets.only(bottom: 110)),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ─── TOGGLE DE TEMA ────────────────────────────────────────────────────────

  Widget _buildThemeToggle() {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        final dark = mode == ThemeMode.dark;
        return Material(
          color: AppColors.text.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: toggleTheme,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                size: 20,
                color: AppColors.text,
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── SLIVER APP BAR ────────────────────────────────────────────────────────

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.bg,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12, top: 6),
          child: _buildThemeToggle(),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        titlePadding: EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF2979FF).withOpacity(0.4),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text('⚽', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Championships App',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.surface, AppColors.bg],
                ),
              ),
            ),
            // Decorative field lines
            Positioned(
              right: -30,
              top: 10,
              child: Opacity(
                opacity: 0.08,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF1565C0), width: 2),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 30,
              top: 50,
              child: Opacity(
                opacity: 0.08,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF1565C0), width: 1.5),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ─── FILTROS ───────────────────────────────────────────────────────────────

  Widget _buildFiltros() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Row(
          children: [
            ChipFiltro(
              label: 'Todos',
              emoji: '🎯',
              selecionado: _filtro == null,
              cor: Color(0xFF4A4A4A),
              onTap: () => setState(() => _filtro = null),
            ),
            SizedBox(width: 8),
            ...Modalidade.values.map(
              (m) => Padding(
                padding: EdgeInsets.only(right: 8),
                child: ChipFiltro(
                  label: m.label,
                  emoji: m.emoji,
                  selecionado: _filtro == m,
                  cor: m.cor,
                  onTap: () => setState(() => _filtro = m),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── CONTADOR ──────────────────────────────────────────────────────────────

  Widget _buildContador() {
    final total = _eventosFiltrados.length;
    if (total == 0) return SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(
        '${total} evento${total != 1 ? 's' : ''}',
        style: TextStyle(
          color: AppColors.text.withOpacity(0.45),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ─── ESTADO VAZIO ──────────────────────────────────────────────────────────

  Widget _buildVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.text.withOpacity(0.08),
              ),
            ),
            child: Center(
              child: Text(
                '⚽',
                style: TextStyle(
                  fontSize: 36,
                  color: AppColors.text.withOpacity(0.35),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Nenhum evento aqui',
            style: TextStyle(
              color: AppColors.text.withOpacity(0.6),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Crie um evento ou troque o filtro',
            style: TextStyle(
              color: AppColors.text.withOpacity(0.4),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ─── FAB ───────────────────────────────────────────────────────────────────

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2979FF).withOpacity(0.35),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _abrirCadastro,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Novo Evento',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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

  // ─── NAVEGAÇÃO ─────────────────────────────────────────────────────────────

  Future<void> _abrirCadastro() async {
    final novo = await Navigator.push<Evento>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => CadastroEventoScreen(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: Duration(milliseconds: 350),
      ),
    );
    if (novo != null) {
      _provider.adicionarEvento(novo);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Text(novo.modalidade.emoji,
                    style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '"${novo.titulo}" criado com sucesso!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.surface,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Color(0xFF2979FF).withOpacity(0.3),
              ),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

