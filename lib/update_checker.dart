import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> checkForForceUpdate(BuildContext context) async {
  try {
    // 1. Get current app version
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version; // e.g. "1.0.0"

    // 2. Fetch latest required version from GitHub Pages
    final response = await http.get(Uri.parse(
      'https://ghavamy.github.io/mahdavitasks/app_version.json',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final requiredVersion = data['required_version'];

      // 3. Compare versions
      if (_isVersionLower(currentVersion, requiredVersion)) {
        _showForceUpdateDialog(context);
      }
    }
  } catch (e) {
    debugPrint('Update check failed: $e');
  }
}

bool _isVersionLower(String current, String required) {
  final currentParts = current.split('.').map(int.parse).toList();
  final requiredParts = required.split('.').map(int.parse).toList();
  for (int i = 0; i < requiredParts.length; i++) {
    if (currentParts[i] < requiredParts[i]) return true;
    if (currentParts[i] > requiredParts[i]) return false;
  }
  return false;
}

void _showForceUpdateDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // 🚫 cannot close without updating
    builder: (_) => AlertDialog(
      title: const Center(child: Text('نسخه جدید موجود است')),
      content: const Directionality(
        textDirection: TextDirection.rtl,
        child: Text('برای ادامه استفاده، لطفاً برنامه را به‌روزرسانی کنید.'),
      ),
      actions: [
        Center(
          child: TextButton(
        onPressed: () async {
          final url = Uri.parse(
            'bazaar://details?id=com.your.package', // <-- change to your package name
          );
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            // fallback to web link
            await launchUrl(Uri.parse(
          'https://cafebazaar.ir/app/com.your.package',
            ));
          }
        },
        child: const Text('به‌روزرسانی'),
          ),
        ),
      ],
    ),
  );
}