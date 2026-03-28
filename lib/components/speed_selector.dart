import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracer/constants/app_constants.dart';

class SpeedSelector extends StatelessWidget {
  final int selectedSpeedIndex;
  final ValueChanged<int> onSpeedChanged;

  const SpeedSelector({
    super.key,
    required this.selectedSpeedIndex,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(kSpeedLabels.length, (i) {
        final selected = i == selectedSpeedIndex;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onSpeedChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFF1A1E35).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? const Color(0xFF6C63FF) : Colors.white10,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                kSpeedLabels[i],
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : Colors.white38,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
