import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracer/constants/app_constants.dart';
import 'package:tracer/models/vehicle_type.dart';

class VehicleSelector extends StatelessWidget {
  final VehicleType selectedVehicle;
  final ValueChanged<VehicleType> onVehicleChanged;

  const VehicleSelector({
    super.key,
    required this.selectedVehicle,
    required this.onVehicleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(VehicleType.values.length, (i) {
        final vt = VehicleType.values[i];
        final selected = vt == selectedVehicle;
        return Expanded(
          child: GestureDetector(
            onTap: () => onVehicleChanged(vt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF6C63FF).withValues(alpha: 0.25)
                    : const Color(0xFF1A1E35).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? const Color(0xFF6C63FF) : Colors.white10,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      kVehicleAssets[i],
                      height: 28,
                      width: 42,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kVehicleLabels[i],
                    style: GoogleFonts.orbitron(
                      fontSize: 8,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? Colors.white : Colors.white38,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
