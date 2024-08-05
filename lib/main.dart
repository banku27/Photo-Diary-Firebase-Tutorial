import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_diary_firebase/data/api/auth_api.dart';
import 'package:photo_diary_firebase/data/prefs.dart';
import 'package:photo_diary_firebase/firebase_options.dart';
import 'package:photo_diary_firebase/modules/auth/provider/auth_provider.dart';
import 'package:photo_diary_firebase/modules/auth/views/login_view.dart';
import 'package:photo_diary_firebase/modules/home/views/home_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            AuthApi(
                firestore: FirebaseFirestore.instance,
                storage: FirebaseStorage.instance),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Photo Diary',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<AuthProvider>(context, listen: false)
            .isUserRegistered(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const HomeView();
          }
          return const LoginView();
        });
  }
}
