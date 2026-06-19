import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/modalidade.dart';
import '../models/evento.dart';

class DetalheEventoScreen extends StatefulWidget {
  final Evento evento;
  final String userId;
  final VoidCallback onConfirmar;

  const DetalheEventoScreen({
    super.key,
    required this.evento,
    required this.userId,
    required this.onConfirmar,
  });

  @override
  State<DetalheEventoScreen> createState() => _DetalheEventoScreenState();
}

class _DetalheEventoScreenState extends State<DetalheEventoScreen> {
  bool get _confirmado => widget.evento.confirmados.contains(widget.userId);

  String _formatarDataCompleta(DateTime d) {
    final dias = [
      'Domingo', 'Segunda-feira', 'Terça-feira',
      'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'Sábado'
    ];
    final meses = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${dias[d.weekday % 7]}, ${d.day} de ${meses[d.month - 1]} · ${h}h$m';
  }

  @override
  Widget build(BuildContext context) {
    final evento = widget.evento;
    final cor = evento.modalidade.cor;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(cor),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildBadgeModalidade(cor),
                  const SizedBox(height: 10),
                  Text(
                    evento.titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSecaoInfo(cor),
                  const SizedBox(height: 16),
                  _buildSecaoVagas(cor),
                  const SizedBox(height: 28),
                  _buildBotaoConfirmar(cor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── HEADER ────────────────────────────────────────────────────────────────

  Widget _buildHeader(Color cor) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFF0B1120),
      iconTheme: const IconThemeData(color: Colors.white),
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                cor.withOpacity(0.7),
                const Color(0xFF0B1120),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -40,
                top: -40,
                child: Opacity(
                  opacity: 0.06,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
              // Big emoji centered
              Center(
                child: Text(
                  widget.evento.modalidade.emoji,
                  style: const TextStyle(fontSize: 80),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── BADGE MODALIDADE ──────────────────────────────────────────────────────

  Widget _buildBadgeModalidade(Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Text(
        '${widget.evento.modalidade.emoji}  ${widget.evento.modalidade.label}',
        style: TextStyle(
          color: cor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ─── SEÇÃO INFORMAÇÕES ─────────────────────────────────────────────────────

  Widget _buildSecaoInfo(Color cor) {
    final evento = widget.evento;
    return _SecaoCard(
      titulo: 'DETALHES',
      child: Column(
        children: [
          _DetalheItem(
            icon: Icons.calendar_today_rounded,
            cor: cor,
            rotulo: 'Data e Hora',
            valor: _formatarDataCompleta(evento.dataHora),
          ),
          _Divisor(),
          _DetalheItem(
            icon: Icons.location_on_rounded,
            cor: cor,
            rotulo: 'Local',
            valor: evento.local,
          ),
          _Divisor(),
          _DetalheItem(
            icon: Icons.person_rounded,
            cor: cor,
            rotulo: 'Organizador',
            valor: evento.organizador,
          ),
        ],
      ),
    );
  }

  // ─── SEÇÃO VAGAS ───────────────────────────────────────────────────────────

  Widget _buildSecaoVagas(Color cor) {
    final evento = widget.evento;
    final pct = evento.ocupacao.clamp(0.0, 1.0);
    final barCor = evento.cheio ? Colors.redAccent : cor;

    return _SecaoCard(
      titulo: 'VAGAS',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: barCor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.group_rounded, color: barCor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${evento.confirmados.length} de ${evento.maxJogadores} confirmados',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        evento.cheio
                            ? 'Nenhuma vaga disponível'
                            : '${evento.vagasRestantes} vagas restantes',
                        style: TextStyle(
                          color: barCor.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: barCor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: barCor.withOpacity(0.25)),
                  ),
                  child: Text(
                    '${(pct * 100).round()}%',
                    style: TextStyle(
                      color: barCor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation<Color>(barCor),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── BOTÃO CONFIRMAR ───────────────────────────────────────────────────────

  Widget _buildBotaoConfirmar(Color cor) {
    final evento = widget.evento;
    final bloqueado = evento.cheio && !_confirmado;

    final Color bgColor;
    final Color fgColor;
    final String texto;
    final IconData icone;

    if (_confirmado) {
      bgColor = Colors.red.shade900.withOpacity(0.8);
      fgColor = Colors.red.shade200;
      texto = 'Cancelar Presença';
      icone = Icons.cancel_outlined;
    } else if (bloqueado) {
      bgColor = Colors.white.withOpacity(0.05);
      fgColor = Colors.white.withOpacity(0.3);
      texto = 'Evento Lotado';
      icone = Icons.lock_rounded;
    } else {
      bgColor = cor;
      fgColor = Colors.white;
      texto = 'Confirmar Presença';
      icone = Icons.check_circle_outline_rounded;
    }

    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: bloqueado || _confirmado
            ? []
            : [
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
          onTap: bloqueado
              ? null
              : () {
                  widget.onConfirmar();
                  setState(() {});
                },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icone, size: 20, color: fgColor),
                const SizedBox(width: 10),
                Text(
                  texto,
                  style: TextStyle(
                    color: fgColor,
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
}

// ─── WIDGETS AUXILIARES ───────────────────────────────────────────────────────

class _SecaoCard extends StatelessWidget {
  final String titulo;
  final Widget child;

  const _SecaoCard({required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            titulo,
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F1E35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _DetalheItem extends StatelessWidget {
  final IconData icon;
  final Color cor;
  final String rotulo;
  final String valor;

  const _DetalheItem({
    required this.icon,
    required this.cor,
    required this.rotulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: cor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rotulo,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  valor,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divisor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Colors.white.withOpacity(0.06),
      indent: 66,
    );
  }
}

class _ItemInfo {
  final IconData icone;
  final String rotulo;
  final String valor;

  const _ItemInfo({
    required this.icone,
    required this.rotulo,
    required this.valor,
  });
}
