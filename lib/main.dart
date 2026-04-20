import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  await Purchases.setLogLevel(LogLevel.debug);
  await Purchases.configure(
    PurchasesConfiguration(
      Platform.isIOS
          ? dotenv.env['REVENUECAT_IOS_KEY']!
          : dotenv.env['REVENUECAT_ANDROID_KEY']!,
    ),
  );

  runApp(const ProviderScope(child: App()));
}
