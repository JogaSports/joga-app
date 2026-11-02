import 'package:flutter/material.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'core/di/app_services.dart';
import 'data/supabase/supabase_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Demo (default): dummy data for Ray, no backend. This is what the demo
  // site builds.
  // Real: the Supabase backend, with --dart-define USE_FAKE=false and the
  // project's URL and publishable key (see core/config/env.dart).
  final services =
      Env.useFake ? AppServices.fake() : await buildSupabaseServices();

  runApp(JogaApp(services: services));
}
