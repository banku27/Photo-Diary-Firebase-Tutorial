import 'dart:developer';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_diary_firebase/common/cnt_etx.dart';
import 'package:photo_diary_firebase/constants/app_colors.dart';
import 'package:photo_diary_firebase/constants/custom_button.dart';
import 'package:photo_diary_firebase/constants/height_spacer.dart';
import 'package:photo_diary_firebase/constants/width_spacer.dart';
import 'package:photo_diary_firebase/modules/auth/views/otp_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future<void> loginWithPhoneNumber(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    _auth.verifyPhoneNumber(
      phoneNumber: "+91${controller.text.trim()}",
      verificationCompleted: (auth.PhoneAuthCredential credential) async {},
      verificationFailed: (auth.FirebaseAuthException e) {
        log(e.message ?? "");
        context.showSnackBar(e.message!, isError: true);
      },
      codeSent: (String verificationId, int? resendCode) async {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OptView(
              phoneNumber: controller.text,
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const HeightSpacer(height: 100),
            Image.asset(
              "assets/login_image.png",
              scale: 4,
            ),
            const HeightSpacer(height: 40),
            const Text(
              "Enter your mobile number",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const HeightSpacer(height: 20),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  const CountryCodeWidget(),
                  const WidthSpacer(width: 10),
                  Expanded(
                      child: TextFormFieldWidget(
                    focusNode: _focusNode,
                    controller: controller,
                    formKey: _formKey,
                  ))
                ],
              ),
            ),
            const HeightSpacer(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: 'Login',
                    color: AppColor.kPrimaryColor,
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        loginWithPhoneNumber(context);
                      }
                    },
                  ),
          ],
        ),
      ),
    ));
  }
}

class CountryCodeWidget extends StatefulWidget {
  const CountryCodeWidget({super.key});

  @override
  State<CountryCodeWidget> createState() => _CountryCodeWidgetState();
}

class _CountryCodeWidgetState extends State<CountryCodeWidget> {
  late String _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = "+91";
  }

  @override
  Widget build(BuildContext context) {
    return CountryCodePicker(
      initialSelection: 'IN',
      onChanged: (value) {
        setState(() {
          _selectedCode = value.dialCode ?? "+91";
        });
      },
      favorite: const ['IN', '+91'],
      builder: (countryCode) => Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage(countryCode?.flagUri ?? "",
                package: 'country_code_picker'),
          ),
          Text(
            _selectedCode,
            style: const TextStyle(
              color: AppColor.kBlackColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final GlobalKey<FormState> formKey;
  const TextFormFieldWidget(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.formKey});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      focusNode: focusNode,
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: AppColor.kWhiteColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColor.kGrey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColor.kGrey,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        } else if (value.length != 10) {
          return "Phone number must be at least 10 digits";
        }
        return null;
      },
    );
  }
}
