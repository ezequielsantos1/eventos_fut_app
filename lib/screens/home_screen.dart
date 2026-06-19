import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../models/eventos_provider.dart';
import '../models/modalidade.dart';
import '../widgets/card_evento.dart';
import '../widgets/chip_filtro.dart';
import 'cadastro_evento_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      backgroundColor: const Color(0xFF0B1120),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildFiltros()),
          SliverToBoxAdapter(child: _buildContador()),
          _eventosFiltrados.isEmpty
              ? SliverFillRemaining(child: _buildVazio())
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final evento = _eventosFiltrados[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
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
          const SliverPadding(padding: EdgeInsets.only(bottom: 110)),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ─── SLIVER APP BAR ────────────────────────────────────────────────────────

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFF0B1120),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2979FF).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text('⚽', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Championships App',
              style: TextStyle(
                color: Colors.white,
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF112240), Color(0xFF0B1120)],
                ),
              ),
            ),
            // Decorative field lines
            Positioned(
              right: -30,
              top: 10,
              child: Opacity(
                opacity: 0.05,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 30,
              top: 50,
              child: Opacity(
                opacity: 0.04,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            ChipFiltro(
              label: 'Todos',
              emoji: '🎯',
              selecionado: _filtro == null,
              cor: const Color(0xFF4A4A4A),
              onTap: () => setState(() => _filtro = null),
            ),
            const SizedBox(width: 8),
            ...Modalidade.values.map(
              (m) => Padding(
                padding: const EdgeInsets.only(right: 8),
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
    if (total == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(
        '${total} evento${total != 1 ? 's' : ''}',
        style: TextStyle(
          color: Colors.white.withOpacity(0.35),
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
              color: const Color(0xFF0F1E35),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
              ),
            ),
            child: Center(
              child: Text(
                '⚽',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Nenhum evento aqui',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Crie um evento ou troque o filtro',
            style: TextStyle(
              color: Colors.white.withOpacity(0.25),
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
        gradient: const LinearGradient(
          colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2979FF).withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _abrirCadastro,
          child: const Padding(
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
        pageBuilder: (_, anim, __) => const CadastroEventoScreen(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
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
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '"${novo.titulo}" criado com sucesso!',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF0D2147),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: const Color(0xFF2979FF).withOpacity(0.3),
              ),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

