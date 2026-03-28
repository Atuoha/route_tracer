import 'package:flutter/material.dart';
import 'package:tracer/components/toolbar_button.dart';
import 'package:tracer/constants/app_constants.dart';

class DrawingToolbar extends StatelessWidget {
  final bool isDrawing;
  final Color selectedColor;
  final double brushWidth;
  final VoidCallback onToggleDrawing;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<double> onBrushWidthChanged;

  const DrawingToolbar({
    super.key,
    required this.isDrawing,
    required this.selectedColor,
    required this.brushWidth,
    required this.onToggleDrawing,
    required this.onColorChanged,
    required this.onBrushWidthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E35).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ToolbarButton(
            icon: Icons.edit_rounded,
            isActive: isDrawing,
            activeColor: const Color(0xFF00E5FF),
            onTap: onToggleDrawing,
          ),
          const SizedBox(height: 16),
          ...List.generate(kPaletteColors.length, (i) {
            final c = kPaletteColors[i];
            final selected = c == selectedColor;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => onColorChanged(c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: selected ? 30 : 24,
                  height: selected ? 30 : 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c,
                    border: selected
                        ? Border.all(color: Colors.white, width: 2.5)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: c.withValues(alpha: 0.5),
                        blurRadius: selected ? 10 : 4,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 4),
          RotatedBox(
            quarterTurns: 3,
            child: SizedBox(
              width: 100,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                  activeTrackColor: const Color(0xFF00E5FF),
                  inactiveTrackColor: Colors.white12,
                  thumbColor: Colors.white,
                  overlayColor: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                ),
                child: Slider(
                  value: brushWidth,
                  min: 1,
                  max: 14,
                  onChanged: onBrushWidthChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
