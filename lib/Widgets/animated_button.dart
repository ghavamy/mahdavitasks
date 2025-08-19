import 'dart:ui';

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
    const borderRadius = BorderRadius.all(Radius.circular(30));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Maindatewindow()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: const LinearGradient(
            colors: [Color(0xFF007B83), Color(0xFF00C2BA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            width: 1.5,
            color: Colors.white.withOpacity(0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            color: Colors.white.withOpacity(0.06),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center, // center horizontally
              crossAxisAlignment: CrossAxisAlignment.center, // center vertically
              textDirection: TextDirection.rtl,
              children: [
                const Text(
                  'رفتن به تقویم',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFFFAF9F6),
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SlideTransition(
                  position: _slideAnim,
                  child: SvgPicture.asset(
                    'assets/icons/arrow_left.svg',
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFAF9F6),
                      BlendMode.srcIn,
                    ),
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