import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracer/components/action_button.dart';
import 'package:tracer/components/speed_selector.dart';
import 'package:tracer/components/vehicle_selector.dart';
import 'package:tracer/models/vehicle_type.dart';

class BottomPanel extends StatelessWidget {
  final VehicleType selectedVehicle;
  final int selectedSpeedIndex;
  final bool isAnimating;
  final ValueChanged<VehicleType> onVehicleChanged;
  final ValueChanged<int> onSpeedChanged;
  final VoidCallback onClear;
  final VoidCallback onPlayStop;

  const BottomPanel({
    super.key,
    required this.selectedVehicle,
    required this.selectedSpeedIndex,
    required this.isAnimating,
    required this.onVehicleChanged,
    required this.onSpeedChanged,
    required this.onClear,
    required this.onPlayStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 12,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            const Color(0xFF0D0F1A),
            const Color(0xFF0D0F1A).withValues(alpha: 0.95),
            const Color(0xFF0D0F1A).withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VEHICLE SELECTION',
            style: GoogleFonts.orbitron(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white38,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          VehicleSelector(
            selectedVehicle: selectedVehicle,
            onVehicleChanged: onVehicleChanged,
          ),
          const SizedBox(height: 18),
          Text(
            'PLAYBACK SPEED',
            style: GoogleFonts.orbitron(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white38,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SpeedSelector(
                selectedSpeedIndex: selectedSpeedIndex,
                onSpeedChanged: onSpeedChanged,
              ),
              const Spacer(),
              ActionButton(
                icon: Icons.delete_outline_rounded,
                label: 'CLEAR',
                color: const Color(0xFFFF3B5C),
                onTap: onClear,
              ),
              const SizedBox(width: 8),
              ActionButton(
                icon: isAnimating ? Icons.stop_rounded : Icons.play_arrow_rounded,
                label: isAnimating ? 'STOP' : 'GO',
                color: const Color(0xFF00E5FF),
                onTap: onPlayStop,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
