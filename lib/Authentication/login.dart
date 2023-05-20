import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihapp/firebase/auth.dart';
import 'package:ihapp/Authentication/signup.dart';
import 'package:ihapp/consts/paddings.dart';
import 'package:ihapp/functions/custom_functions.dart';
import 'package:ihapp/widgets/custom_outlinedbuton.dart';
import 'package:ihapp/widgets/custom_text.dart';
import 'package:ihapp/widgets/custom_textbutton.dart';

import '../consts/strings.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/error_message.dart';
import 'forget_password/password_bottomsheet.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  final User? user = Auth().currentUser;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  IconData suffixIconData = Icons.remove_red_eye_outlined;
  bool obsocureText = true;

  Future<void> signInWithEmailAndPassword() async {
    try {
      String? userUid = await Auth().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: horizantalPadding20 * 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                '${imageSource}iha.png',
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
              customText(
                text: 'Hoşgeldin,',
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    ),
                context: context,
              ),
              const SizedBox(height: 10),
              customText(
                text: 'Kolay, hızlı, kullanışlı şekilde takip et.',
                textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                context: context,
              ),
              Padding(
                padding: topPadding20 * 1.5,
                child: customTextField(
                  title: 'E-mail',
                  controller: emailController,
                  prefixIconData: Icons.mail_outline_outlined,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: topPadding20 * 1,
                child: customTextField(
                  controller: passwordController,
                  title: 'Şifre',
                  prefixIconData: Icons.password_outlined,
                  obscureText: obsocureText,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsocureText = !obsocureText;
                      });
                    },
                    icon: Icon(obsocureText == true
                        ? suffixIconData = Icons.visibility_outlined
                        : suffixIconData = Icons.visibility_off_outlined),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
              customErrorMessage(errorMessage: errorMessage),
              Padding(
                padding: verticalPadding20,
                child: Row(
                  children: [
                    const Spacer(),
                    customTextButton(
                        onpressed: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0))),
                            context: context,
                            builder: (BuildContext context) {
                              return customBottomSheet(context);
                            },
                          );
                        },
                        text: 'Forget Password?')
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: customOutlinedButton(
                      onPressed: () {
                        signInWithEmailAndPassword();
                      },
                      title: 'Giriş Yap',
                      context: context,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: verticalPadding20,
                child: Row(
                  children: [
                    const Spacer(),
                    customText(
                      text: 'Henüz bir hesabın yok mu?',
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      context: context,
                    ),
                    customTextButton(
                        onpressed: () {
                          GoPagePush(
                              widget: const SignupPage(), context: context);
                        },
                        text: 'Kayıt Ol'),
                    const Spacer()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
