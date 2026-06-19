import 'package:flutter/material.dart';

class ChipFiltro extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selecionado;
  final Color cor;
  final VoidCallback onTap;

  const ChipFiltro({
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
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? cor : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selecionado ? cor : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: selecionado
              ? [
                  BoxShadow(
                    color: cor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                color: selecionado ? Colors.white : Colors.white.withOpacity(0.5),
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
