import '../theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../models/modalidade.dart';
import '../models/evento.dart';

class DetalheEventoScreen extends StatefulWidget {
  final Evento evento;
  final String userId;
  final VoidCallback onConfirmar;

  DetalheEventoScreen({
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
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          _buildHeader(cor),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _buildBadgeModalidade(cor),
                  SizedBox(height: 10),
                  Text(
                    evento.titulo,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildSecaoInfo(cor),
                  SizedBox(height: 16),
                  _buildSecaoVagas(cor),
                  SizedBox(height: 28),
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
      backgroundColor: AppColors.bg,
      iconTheme: IconThemeData(color: Colors.white),
      leading: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                cor.withOpacity(0.7),
                AppColors.bg,
              ],
              stops: [0.0, 1.0],
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
                  style: TextStyle(fontSize: 80),
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          if (evento.enderecoCompleto.isNotEmpty) ...[
            _Divisor(),
            _DetalheItem(
              icon: Icons.markunread_mailbox_rounded,
              cor: cor,
              rotulo: 'Endereço',
              valor: evento.enderecoCompleto,
            ),
          ],
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
        padding: EdgeInsets.all(16),
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
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${evento.confirmados.length} de ${evento.maxJogadores} confirmados',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
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
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: AppColors.text.withOpacity(0.07),
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
      bgColor = AppColors.text.withOpacity(0.05);
      fgColor = AppColors.text.withOpacity(0.45);
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
                  offset: Offset(0, 6),
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
                SizedBox(width: 10),
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

  _SecaoCard({required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            titulo,
            style: TextStyle(
              color: AppColors.text.withOpacity(0.45),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.text.withOpacity(0.08)),
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

  _DetalheItem({
    required this.icon,
    required this.cor,
    required this.rotulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
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
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rotulo,
                  style: TextStyle(
                    color: AppColors.text.withOpacity(0.45),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  valor,
                  style: TextStyle(
                    color: AppColors.text,
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
      color: AppColors.text.withOpacity(0.08),
      indent: 66,
    );
  }
}

