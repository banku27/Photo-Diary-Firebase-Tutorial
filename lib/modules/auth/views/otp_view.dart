import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:photo_diary_firebase/common/cnt_etx.dart';
import 'package:photo_diary_firebase/constants/app_colors.dart';
import 'package:photo_diary_firebase/constants/height_spacer.dart';
import 'package:photo_diary_firebase/data/prefs.dart';
import 'package:photo_diary_firebase/models/profile_model.dart';
import 'package:photo_diary_firebase/modules/auth/provider/auth_provider.dart';
import 'package:photo_diary_firebase/modules/auth/views/sign_up_view.dart';
import 'package:photo_diary_firebase/modules/home/views/home_view.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OptView extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const OptView(
      {super.key, required this.phoneNumber, required this.verificationId});

  @override
  State<OptView> createState() => _OptViewState();
}

class _OptViewState extends State<OptView> {
  late TextEditingController controller;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  Future<void> verifyOtp(
    String otp,
    BuildContext context,
  ) async {
    if (otp.length != 6) {
      context.showSnackBar("Otp must be 6 characters", isError: true);
      return;
    }
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    try {
      final auth.PhoneAuthCredential credential =
          auth.PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp.trim(),
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      print(userCredential.user?.uid);
      Prefs.setUserId(user?.uid ?? "");
      if (user != null) {
        final ProfileModel profile =
            await authProvider.getUserData(widget.phoneNumber);

        if (profile.isProfileCompleted()) {
          Prefs.setUserId(profile.uid);
          Prefs.setProfilePhoto(profile.profileUrl ?? "");
          Prefs.setUserName(profile.name);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeView(),
            ),
          );
          if (context.mounted) {
            context.showSnackBar("Welcome ${profile.name}");
          }
        } else {
          context.showSnackBar("Something went wrong! Try Again",
              isError: true);
        }
      }
    } catch (e) {
      if (context.mounted) {
        authProvider.updateNameAndPhone(
            "", widget.phoneNumber, Prefs.getUserId ?? "");
        log(e.toString());

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpView(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Verify your number ",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const HeightSpacer(height: 20),
            const Text(
              "A code was just sent to ",
              style: TextStyle(
                fontSize: 16,
                color: AppColor.kBlackColor,
              ),
            ),
            const HeightSpacer(height: 30),
            Text(
              "+91 ${widget.phoneNumber}",
              style: const TextStyle(
                  fontSize: 26,
                  color: AppColor.kBlackColor,
                  fontWeight: FontWeight.bold),
            ),
            const HeightSpacer(height: 30),
            Pinput(
              length: 6,
              controller: controller,
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const HeightSpacer(height: 20),
            ElevatedButton(
              onPressed: () {
                verifyOtp(controller.text, context);
              },
              child: const Text("Verify Otp"),
            )
          ],
        ),
      ),
    );
  }
}
