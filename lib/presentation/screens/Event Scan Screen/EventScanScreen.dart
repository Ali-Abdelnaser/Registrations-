import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:registration/Logic/cubit/event_cubit.dart';
import 'package:registration/Logic/cubit/event_state.dart';
import 'package:registration/presentation/screens/Event%20Info%20Screen/EventInfoScreen.dart';

class EventScanScreen extends StatefulWidget {
  const EventScanScreen({super.key});

  @override
  State<EventScanScreen> createState() => _EventScanScreenState();
}

class _EventScanScreenState extends State<EventScanScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;
  double zoom = 0.0;

  void _showDialog(String title, String content, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isError ? Icons.warning_amber_rounded : Icons.check_circle,
                color: isError ? Colors.orange : Colors.green,
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff016da6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff016da6),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 300));
                    controller.start();
                    setState(() => isScanned = false);
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerOverlay(BuildContext context, double boxSize) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final boxLeft = (screenWidth - boxSize) / 2;
    final boxTop = (screenHeight - boxSize) / 2;

    return Stack(
      children: [
        Positioned(
          bottom: 40,
          left: 30,
          right: 30,
          child: Column(
            children: [
              const Text("Zoom", style: TextStyle(color: Colors.white70)),
              Slider(
                value: zoom,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                onChanged: (value) {
                  setState(() => zoom = value);
                  controller.setZoomScale(value);
                },
              ),
            ],
          ),
        ),
        Positioned(
          left: boxLeft,
          top: boxTop,
          width: boxSize,
          height: boxSize,
          child: CustomPaint(painter: CornerPainter()),
        ),
        _AnimatedScannerLine(
          boxTop: boxTop,
          boxLeft: boxLeft,
          boxSize: boxSize,
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxSize = screenWidth * 0.6;

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<EventCubit, EventState>(
        listener: (context, state) async {
          if (state is EventParticipantNotFound) {
            _showDialog(
              "Not Found",
              "No participant found with this QR.",
              isError: true,
            );
          } else if (state is EventAlreadyCheckedIn) {
            _showDialog(
              "Already Checked In",
              "${state.participant.name} is already marked present.",
              isError: true,
            );
          } else if (state is EventParticipantFound) {
            final participant = state.participant;
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventInfoScreen(
                  participant: participant,
                  onConfirm: () async {
                    await context.read<EventCubit>().confirmAttendance(
                      participant,
                    );
                  },
                ),
              ),
            );
            if (result == true) {
              _showDialog(
                "Success",
                "${participant.name} has been checked in.",
              );
              context.read<EventCubit>().reset();
            }

            setState(() => isScanned = false);
            // } else if (state is EventCheckInSuccess) {
            //   Navigator.pop(context, true);
          } else if (state is EventError) {
            _showDialog("Error", state.message, isError: true);
          }
        },
        child: Stack(
          children: [
            MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final code = capture.barcodes.first.rawValue;
                if (code != null && !isScanned) {
                  setState(() => isScanned = true);
                  context.read<EventCubit>().scanParticipant(code);
                }
              },
            ),
            _buildScannerOverlay(context, boxSize),
          ],
        ),
      ),
    );
  }
}

/// ✅ نفس الـ CornerPainter بتاعك
class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const cornerLength = 20.0;

    // Top-left
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);

    // Top-right
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// ✅ خط المسح الأحمر
class _AnimatedScannerLine extends StatefulWidget {
  final double boxTop;
  final double boxLeft;
  final double boxSize;

  const _AnimatedScannerLine({
    required this.boxTop,
    required this.boxLeft,
    required this.boxSize,
  });

  @override
  State<_AnimatedScannerLine> createState() => _AnimatedScannerLineState();
}

class _AnimatedScannerLineState extends State<_AnimatedScannerLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: widget.boxSize,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: widget.boxTop + _animation.value,
          left: widget.boxLeft,
          width: widget.boxSize,
          child: Container(height: 2, color: Colors.redAccent),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
