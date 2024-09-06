import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:multiplos_cadastros/src/app.dart';

void main() async {
  await initializeDateFormatting();
  runApp(const ProviderScope(child: App()));
}
