import 'package:flutter/material.dart';
import 'package:mahdavitasks/BasicFiles/PersianFormats.dart';
import 'package:shamsi_date/shamsi_date.dart';

Future<int?> showYearSelectorDialog(BuildContext context) {
  final years = List.generate(50, (i) => Jalali.now().year - 25 + i);
  return showDialog<int>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Text('انتخاب سال', textAlign: TextAlign.center),
        children: years
            .map((y) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, y),
                  child: Center(
                      child: Text(PersianUtils.toPersianDigits(y.toString()))),
                ))
            .toList(),
      );
    },
  );
}
