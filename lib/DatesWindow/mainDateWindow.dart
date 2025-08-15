import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mahdavitasks/BasicFiles/PersianFormats.dart';
import 'note_store.dart';
import 'days_page.dart';

class Maindatewindow extends StatefulWidget {
  const Maindatewindow({super.key});

  @override
  State<Maindatewindow> createState() => _MaindatewindowState();
}

class _MaindatewindowState extends State<Maindatewindow> {
  // Decide the top bar color based on Jalali month number (1–12)
  Color _seasonColor(int month) {
    if (month >= 1 && month <= 3) {
      return Colors.green.shade400; // Spring
    } else if (month >= 4 && month <= 6) {
      return Colors.brown.shade400; // Summer
    } else if (month >= 7 && month <= 9) {
      return Colors.orange.shade400; // Autumn
    } else {
      return Colors.blue.shade400; // Winter
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<NotesStore>();
    final years = store.years;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سال‌ها و ماه‌ها'),
        centerTitle: true,
        flexibleSpace: const Image(
          image: AssetImage('assets/images/smooth_green_gradient.png'),
          fit: BoxFit.cover,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: years.length,
        itemBuilder: (context, yearIndex) {
          final year = years[yearIndex];
          final months = store.monthsIn(year);

          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Year title
                Text(
                  PersianUtils.toPersianDigits(year.toString()),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                //months grid
                Directionality(
                  textDirection: TextDirection.rtl, 
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: months.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, monthIndex) {
                      final m = months[monthIndex];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DaysPage(year: year, month: m),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Seasonal colored "binding"
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: _seasonColor(m),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(
                                      5,
                                      (i) => Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Month name
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 14),
                                  child: Text(
                                    PersianUtils.monthName(m),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}