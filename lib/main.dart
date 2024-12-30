import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_sphere_vendor/provider/vendor_provider.dart';
import 'package:market_sphere_vendor/views/screens/main_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/screens/authentication_screens/login_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> checkTokenAndSetUser(WidgetRef ref) async {
      //OBTAIN AN INSTANCE OF SHARED PREFERENCES
      SharedPreferences prefs = await SharedPreferences.getInstance();

      //RETRIVE THE DATA STORED LOCALLY
      String? token = prefs.getString('auth_token');
      String? vendorJson = prefs.getString('vendor');

      if (token != null && vendorJson != null) {
        ref.read(vendorProvider.notifier).setVendor(vendorJson);
      } else {
        ref.read(vendorProvider.notifier).signOut();
      }
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: checkTokenAndSetUser(ref),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final vendor = ref.watch(vendorProvider);
            return vendor != null ? MainScreen() : LoginScreen();
          }),
    );
  }
}
