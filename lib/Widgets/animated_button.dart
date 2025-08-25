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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Maindatewindow()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              'رفتن به تقویم',
              style: TextStyle(
                fontFamily: 'Vazir',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            SlideTransition(
              position: _slideAnim,
              child: SvgPicture.asset(
                'assets/icons/arrow_left.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}