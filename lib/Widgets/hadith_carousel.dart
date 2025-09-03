import 'dart:math';
import 'package:flutter/material.dart';

class HadithCarousel extends StatefulWidget {
  const HadithCarousel({super.key});

  @override
  State<HadithCarousel> createState() => _HadithCarouselState();
}

class _HadithCarouselState extends State<HadithCarousel> {
  // List of famous hadiths from Imam Mahdi (aj)
  final List<String> _ahadith = [
    'إِنَّ اللّهَ مَعَنا فَلا فاقَةَ بِنا إِلى غَيرِهِ — خدا با ماست و نیازی به غیر او نداریم.',
    'إِنَّ الأَرضَ لا تَخلُو مِن حُجَّةٍ إِمّا ظاهِراً و إِمّا مَغمُوراً — زمین هیچ‌گاه از حجت خدا خالی نمی‌ماند، چه آشکار و چه پنهان.',
    'لِيَعمَل كُلُّ امرِئٍ مِنكُم بِما يُقرِّبُهُ مِن مَحَبَّتِنا — هر یک از شما باید کاری کند که او را به محبت ما نزدیک سازد.'
  ];

  late String _currentHadith;

  @override
  void initState() {
    super.initState();
    _shuffleHadith();
  }

  // Shuffle the list and pick the first hadith
  void _shuffleHadith() {
    _ahadith.shuffle(Random());
    _currentHadith = _ahadith.first;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Low height banner
      width: double.infinity, // Full width of the screen
      child: Row(
        children: [
          // White section for the hadith text
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerRight,
              child: Text(
                _currentHadith,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl, // Keep Arabic/Persian RTL
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Vazir', // Make sure this font is added to your project
                  color: Colors.black, // Explicit text color
                  decoration: TextDecoration.none, // Remove any underline
                ),
              ),
            ),
          ),

          // Image section on the right
          Container(
            height: 100,
            width: 100, // Fixed width for the image
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hadith_bg.png'),
                fit: BoxFit.cover, // Fill only this container
              ),
            ),
          ),
        ],
      ),
    );
  }
}