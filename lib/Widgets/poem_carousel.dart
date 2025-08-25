import 'package:flutter/material.dart';
import 'dart:async';

class PoemCarousel extends StatefulWidget {
  const PoemCarousel({super.key});

  @override
  State<PoemCarousel> createState() => _PoemCarouselState();
}

class _PoemCarouselState extends State<PoemCarousel> {
  final List<String> poems = [
    'ای بهار آرزوها، ای امامِ دلنشین\nبیا که دل شکسته شود ز فراق غمین',
    'شب فراق تو را ماه و ستاره گریند\nدعا کنند به درگاه، دل‌های پاک و یقین',
    'نسیم صبح به نامت، سلام گوید هر آن\nکه چشم ماست به راهت، ای موعودِ نهان',
    'دل از غروب تو گیرد، به نور صبح امید\nبیا که جان شود از مهر تو دوباره پدید',
    'ای امامِ زمان، ای نگارِ پنهان\nبیا که جان و جهان گردد از تو جوان',
  ];

  int currentPoemIndex = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        currentPoemIndex = (currentPoemIndex + 1) % poems.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Container(
        key: ValueKey(currentPoemIndex),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          poems[currentPoemIndex],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontFamily: 'IranNastaliq',
            color: Theme.of(context).colorScheme.onPrimary,
            height: 1.6,
            shadows: [
              Shadow(
                offset: const Offset(0, 1),
                blurRadius: 3,
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}