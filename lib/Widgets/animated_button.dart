import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mahdavitasks/DatesWindow/mainDateWindow.dart';

class AnimatedCalendarButton extends StatefulWidget {
  const AnimatedCalendarButton({super.key});

  @override
  State<AnimatedCalendarButton> createState() => _AnimatedCalendarButtonState();
}

class _AnimatedCalendarButtonState extends State<AnimatedCalendarButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // ✅ This is where _slideAnim must be assigned
    _slideAnim = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.15, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // sharper corners
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Maindatewindow()),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          const Text('رفتن به تقویم', style: TextStyle(fontFamily: 'Vazir')),
          const SizedBox(width: 8),
          SlideTransition(
            position: _slideAnim,
            child: SvgPicture.asset(
              'assets/icons/arrow_left.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(Color.fromARGB(255, 0, 0, 0), BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}