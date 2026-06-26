import '../theme/app_colors.dart';
import 'package:flutter/material.dart';

class ChipFiltro extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selecionado;
  final Color cor;
  final VoidCallback onTap;

  ChipFiltro({
    super.key,
    required this.label,
    required this.emoji,
    required this.selecionado,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? cor : AppColors.text.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selecionado ? cor : AppColors.text.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: selecionado
              ? [
                  BoxShadow(
                    color: cor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 13)),
            SizedBox(width: 6),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 180),
              style: TextStyle(
                color: selecionado ? Colors.white : AppColors.text.withOpacity(0.6),
                fontWeight: selecionado ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
                letterSpacing: 0.1,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
