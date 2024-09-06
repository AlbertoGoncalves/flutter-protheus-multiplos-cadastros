
import 'package:flutter/material.dart';

class AppNavGlobalKey {
  static AppNavGlobalKey? _instance;
  final navKey = GlobalKey<NavigatorState>();

  AppNavGlobalKey._();
  
  static AppNavGlobalKey get instance =>
    _instance ??= AppNavGlobalKey._();
}