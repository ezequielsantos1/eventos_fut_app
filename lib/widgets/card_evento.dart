import '../theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../models/modalidade.dart';
import '../screens/detalhe_evento_screen.dart';

class CardEvento extends StatelessWidget {
  final Evento evento;
  final String userId;
  final VoidCallback onConfirmar;

  CardEvento({
    super.key,
    required this.evento,
    required this.userId,
    required this.onConfirmar,
  });

  String _formatarData(DateTime d) {
    final dias = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    final meses = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return '${dias[d.weekday % 7]}, ${d.day} ${meses[d.month - 1]} · '
        '${d.hour.toString().padLeft(2, '0')}h${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final confirmado = evento.confirmados.contains(userId);
    final cor = evento.modalidade.cor;
    final pct = evento.ocupacao.clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, anim, __) => DetalheEventoScreen(
            evento: evento,
            userId: userId,
            onConfirmar: onConfirmar,
          ),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: child,
          ),
          transitionDuration: Duration(milliseconds: 220),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: confirmado
                ? cor.withOpacity(0.4)
                : AppColors.text.withOpacity(0.08),
            width: confirmado ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: confirmado
                  ? cor.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colored accent bar at top
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cor.withOpacity(0.8), cor.withOpacity(0.0)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(cor),
                  SizedBox(height: 10),
                  Text(
                    evento.titulo,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  _buildInfoGrid(),
                  SizedBox(height: 14),
                  _buildProgressBar(cor, pct),
                  SizedBox(height: 12),
                  _buildBotao(confirmado, cor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color cor) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: cor.withOpacity(0.14),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: cor.withOpacity(0.28), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(evento.modalidade.emoji,
                  style: TextStyle(fontSize: 12)),
              SizedBox(width: 5),
              Text(
                evento.modalidade.label,
                style: TextStyle(
                  color: cor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        if (evento.cheio)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
            ),
            child: Text(
              'LOTADO',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoGrid() {
    return Column(
      children: [
        _InfoRow(
          icon: Icons.calendar_today_rounded,
          text: _formatarData(evento.dataHora),
        ),
        SizedBox(height: 5),
        _InfoRow(
          icon: Icons.location_on_rounded,
          text: evento.local,
        ),
        SizedBox(height: 5),
        _InfoRow(
          icon: Icons.person_outline_rounded,
          text: evento.organizador,
        ),
      ],
    );
  }

  Widget _buildProgressBar(Color cor, double pct) {
    final vagasCor = evento.cheio ? Colors.redAccent : Color(0xFF2979FF);
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.group_outlined,
                size: 13, color: AppColors.text.withOpacity(0.4)),
            SizedBox(width: 5),
            Text(
              '${evento.confirmados.length}/${evento.maxJogadores} jogadores',
              style: TextStyle(
                color: AppColors.text.withOpacity(0.55),
                fontSize: 12,
              ),
            ),
            Spacer(),
            Text(
              evento.cheio ? 'Sem vagas' : '${evento.vagasRestantes} vagas',
              style: TextStyle(
                color: vagasCor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: AppColors.text.withOpacity(0.07),
            valueColor: AlwaysStoppedAnimation<Color>(
              evento.cheio ? Colors.redAccent : cor,
            ),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildBotao(bool confirmado, Color cor) {
    final bloqueado = evento.cheio && !confirmado;

    Color bgColor;
    if (confirmado) {
      bgColor = Color(0xFF2979FF).withOpacity(0.15);
    } else if (bloqueado) {
      bgColor = AppColors.text.withOpacity(0.05);
    } else {
      bgColor = cor.withOpacity(0.18);
    }

    Color fgColor;
    if (confirmado) {
      fgColor = Color(0xFF2979FF);
    } else if (bloqueado) {
      fgColor = AppColors.text.withOpacity(0.45);
    } else {
      fgColor = cor;
    }

    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: confirmado
              ? Color(0xFF2979FF).withOpacity(0.3)
              : bloqueado
                  ? AppColors.text.withOpacity(0.08)
                  : cor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: bloqueado ? null : onConfirmar,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  confirmado
                      ? Icons.check_circle_rounded
                      : bloqueado
                          ? Icons.lock_rounded
                          : Icons.sports_soccer_rounded,
                  size: 16,
                  color: fgColor,
                ),
                SizedBox(width: 8),
                Text(
                  confirmado
                      ? 'Presença Confirmada'
                      : bloqueado
                          ? 'Evento Lotado'
                          : 'Confirmar Presença',
                  style: TextStyle(
                    color: fgColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.text.withOpacity(0.45)),
        SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.text.withOpacity(0.6),
              fontSize: 12,
              height: 1.3,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
