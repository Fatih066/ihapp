import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihapp/consts/paddings.dart';
import 'package:ihapp/functions/custom_functions.dart';
import 'package:ihapp/widgets/custom_textbutton.dart';
import 'package:ihapp/widgets/custom_textfield.dart';

import '../consts/strings.dart';
import '../firebase/firestore.dart';
import '../widgets/custom_outlinedbuton.dart';
import '../widgets/custom_text.dart';
import '../widgets/error_message.dart';
import '../firebase/auth.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? errorMessage = '';
  bool isUserValue = true;
  bool obsocureText = true;

  IconData suffixIconData = Icons.remove_red_eye_outlined;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<String?> createUserWithEmailAndPassword() async {
    try {
      String? uid = await Auth().createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      return uid;
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: horizantalPadding20,
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
                text: 'Hadi Başlayalım,',
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    ),
                context: context,
              ),
              const SizedBox(height: 10),
              customText(
                text: 'Kolaylık için kayıt ol',
                textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                context: context,
              ),
              Padding(
                padding: topPadding20 * 1.5,
                child: customTextField(
                  controller: nameController,
                  title: 'Kullanıcı Adı',
                  textInputAction: TextInputAction.next,
                  prefixIconData: Icons.person_outline_outlined,
                ),
              ),
              Padding(
                padding: topPadding20 / 2,
                child: customTextField(
                  controller: emailController,
                  title: 'Email',
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                  prefixIconData: Icons.mail_outline_outlined,
                ),
              ),
              Padding(
                padding: topPadding20 / 2,
                child: customTextField(
                  controller: numberController,
                  title: 'Telefon No',
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.phone,
                  prefixIconData: Icons.numbers_outlined,
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
                            : suffixIconData = Icons.visibility_off_outlined)),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Kullanıcı mısın?'),
                  Checkbox(
                    value: isUserValue,
                    onChanged: (value) {
                      setState(() {
                        isUserValue = !isUserValue;
                      });
                    },
                  ),
                ],
              ),
              customErrorMessage(errorMessage: errorMessage),
              Padding(
                padding: topPadding20,
                child: Row(
                  children: [
                    Expanded(
                      child: customOutlinedButton(
                        context: context,
                        onPressed: () async {
                          String? userUid =
                              await createUserWithEmailAndPassword();
                          if (userUid != null) {
                            FireStore().setUserInfos(
                              userUid: userUid,
                              name: nameController.text,
                              phoneNumber: numberController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              //true olmasının sebebi normal kullanıcı girişi
                              isUser: isUserValue,
                            );
                          }
                          await signOut();
                        },
                        title: 'Kayıt Ol',
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  customText(
                    text: 'Zaten bir hesabın var mı?',
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    context: context,
                  ),
                  customTextButton(
                      onpressed: () {
                        GoPagePush(widget: const LoginPage(), context: context);
                      },
                      text: 'Giriş Yap'),
                  const Spacer()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
