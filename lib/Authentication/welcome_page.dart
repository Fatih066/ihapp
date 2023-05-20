import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ihapp/Authentication/login.dart';
import 'package:ihapp/Authentication/signup.dart';

import '../consts/paddings.dart';
import '../consts/strings.dart';
import '../functions/custom_functions.dart';
import '../widgets/custom_outlinedbuton.dart';
import '../widgets/custom_text.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Padding(
        padding: horizantalPadding20 * 1.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('$imageSource' 'iha.png'),
            Column(
              children: [
                CustomTextWidget(
                  text: 'Araçlarını Kolayca Takip Et',
                  textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                      ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: horizantalPadding20 * 2,
                  child: CustomTextWidget(
                    text:
                        'Araçlarını kolay bir şekilde takip etmek için sen de aramıza katıl',
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 10,
                    child: CustomOutlinedButton(
                      onPressed: () {
                        GoPagePush(context: context, widget: const LoginPage());
                      },
                      title: 'Giriş Yap',
                    )),
                const Spacer(flex: 1),
                Expanded(
                    flex: 10,
                    child: CustomOutlinedButton(
                      onPressed: () {
                        GoPagePush(
                            context: context, widget: const SignupPage());
                      },
                      title: 'Kayıt Ol',
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
