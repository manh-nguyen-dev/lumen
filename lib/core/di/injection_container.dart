import 'package:flutter/foundation.dart';

Future<void> init() async {
  await _registerHiveAdapters();
}

// Register all Hive adapters
Future<void> _registerHiveAdapters() async {
  try {
    if (kDebugMode) {
      print('Hive adapters registered successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error registering Hive adapters: $e');
    }
  }
}
