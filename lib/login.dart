import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'account_details.dart';
import 'singleton_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'single_firestore.dart';


// ignore_for_file: must_be_immutable
class Login extends StatelessWidget {
  Login({super.key});

  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
    final FirebaseAuth _auth = AuthenticationService().firebaseAuth;
  final FirebaseFirestore _firestore = FirestoreService().firestore;

  void showEnteredDetails()
  {
    print(emailInputController.text);
    print(passwordInputController.text);
  }

  Future<void> emailLogIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailInputController.text,
        password: passwordInputController.text,
      );
      print('User signed in');
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.5, 0),
              end: Alignment(0.5, 1),
              colors: [Color(0XFF66D2CC), Color(0XFF3062F3)],
            ),
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 62),
                    Container(
                      width: double.maxFinite,
                      margin: const EdgeInsets.only(
                        left: 8,
                        right: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "TeamView",
                              style: TextStyle(
                                color: Color(0XFFFFFFFF),
                                fontSize: 40,
                                fontFamily: 'Arimo',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 96),
                          const Text(
                            "Login Account",
                            style: TextStyle(
                              color: Color(0XFF130C0C),
                              fontSize: 24,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            "Hello, you must login first to be able to use the application and enjoy all the features in TeamView",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0XFF120404),
                              fontSize: 14,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 50),
                          _buildLoginForm(context)
                        ],
                      ),
                    ),
                    const SizedBox(height: 52),
                    _buildLoginButton(context),
                    const SizedBox(height: 34),
                    _buildAlternativeSigninOptions(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailInput(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        focusNode: FocusNode(),
        autofocus: true,
        controller: emailInputController,
        style: const TextStyle(
          color: Color(0X7F000000),
          fontSize: 17.44186019897461,
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: "Email Address",
          hintStyle: const TextStyle(
            color: Color(0X7F000000),
            fontSize: 17.44186019897461,
            fontFamily: 'Work Sans',
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 8, 16),
            child: SvgPicture.asset(
              "assets/images/img_mailfill0wght400grad0opsz48_1_1.svg",
              height: 18,
              width: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            maxHeight: 52,
          ),
          filled: true,
          fillColor: const Color(0XFFFFFFFF),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPasswordInput(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        focusNode: FocusNode(),
        autofocus: true,
        controller: passwordInputController,
        style: const TextStyle(
          color: Color(0X7F000000),
          fontSize: 17.44186019897461,
          fontFamily: 'Work Sans',
          fontWeight: FontWeight.w400,
        ),
        textInputAction: TextInputAction.done,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: const TextStyle(
            color: Color(0X7F000000),
            fontSize: 17.44186019897461,
            fontFamily: 'Work Sans',
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 8, 16),
            child: SvgPicture.asset(
              "assets/images/img_lockfill0wght400grad0opsz48_1.svg",
              height: 18,
              width: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            maxHeight: 52,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              "assets/images/img_vector.svg",
              height: 18,
              width: 20,
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            maxHeight: 52,
          ),
          filled: true,
          fillColor: const Color(0XFFFFFFFF),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildLoginForm(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmailInput(context),
          const SizedBox(height: 14),
          _buildPasswordInput(context),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Text(
              "Forgot password?",
              style: TextStyle(
                color: Color(0XFF000000),
                fontSize: 13.95348834991455,
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 58,
      margin: const EdgeInsets.only(left: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0XFF5E9EE8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 18,
          ),
        ),
        onPressed: () 
        {
          emailLogIn();
          showEnteredDetails();
          Navigator.push
          (
            context,
            MaterialPageRoute(builder: (context) => const AccountDetails())
          );
        },
        child: const Text(
          "Log in",
          style: TextStyle(
            color: Color(0XFFFFFFFF),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildGoogleSigninButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 44,
      margin: const EdgeInsets.only(
        left: 70,
        right: 64,
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0XFFFFFFFF),
          side: const BorderSide(
            color: Color(0XFFD8DADC),
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: const EdgeInsets.only(
            top: 12,
            right: 6,
            bottom: 12,
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              child: SvgPicture.asset(
                "assets/images/img_google_logo.svg",
                height: 18,
                width: 18,
              ),
            ),
            const Text(
              "Sign in with Google",
              style: TextStyle(
                color: Color(0XFF000000),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppleSigninButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 42,
      margin: const EdgeInsets.only(
        left: 70,
        right: 64,
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0XFFFFFFFF),
          side: const BorderSide(
            color: Color(0XFFD8DADC),
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: const EdgeInsets.only(
            top: 10,
            right: 10,
            bottom: 10,
          ),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: SvgPicture.asset(
                "assets/images/img_social_icon_apple.svg",
                height: 20,
                width: 20,
              ),
            ),
            const Text(
              "Sign in with Apple",
              style: TextStyle(
                color: Color(0XFF000000),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAlternativeSigninOptions(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(
        left: 8,
        right: 20,
      ),
      child: Column(
        children: [
          const SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0XFFF2F2F2),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Or Sign In With",
                    style: TextStyle(
                      color: Color(0XFF250505),
                      fontSize: 12,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0XFFF2F2F2),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildGoogleSigninButton(context),
          const SizedBox(height: 14),
          _buildAppleSigninButton(context),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 46),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Don’t have an account?",
                      style: TextStyle(
                        color: Color(0XB2000000),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: " ",
                    ),
                    TextSpan(
                      text: "Sign up",
                      style: TextStyle(
                        color: Color(0XFF000000),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
          )
        ],
      ),
    );
  }
}
