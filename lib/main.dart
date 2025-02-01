import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://lmvcpsodnzjmomxlovhu.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtdmNwc29kbnpqbW9teGxvdmh1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczOTEyNTksImV4cCI6MjA1Mjk2NzI1OX0.kPbgkjriutGlvRnjnUQgcG7bJINbPD1r1hTTSA5ex_4'
  );

  runApp(const App());
}
