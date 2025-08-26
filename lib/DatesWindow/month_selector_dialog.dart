import 'package:flutter/material.dart';
import 'package:mahdavitasks/BasicFiles/PersianFormats.dart';

Future<int?> showMonthSelectorDialog(BuildContext context) {
  final months = List.generate(12, (i) => i + 1);
  return showDialog<int>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Text('انتخاب ماه', textAlign: TextAlign.center),
        children: months
            .map((m) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, m),
                  child: Center(child: Text(PersianUtils.monthName(m))),
                ))
            .toList(),
      );
    },
  );
}
