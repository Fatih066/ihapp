import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihapp/enums/enums.dart';
import 'package:ihapp/pages/kullanici/kullanici_page.dart';
import 'package:ihapp/widgets/custom_text.dart';
import 'package:ihapp/widgets/custom_textfield.dart';

import '../../../consts/paddings.dart';
import '../../../firebase/auth.dart';
import '../../../firebase/firestore.dart';
import '../../../widgets/custom_outlinedbuton.dart';
import '../../../widgets/error_message.dart';

class IhaEklemeWidget extends StatefulWidget {
  final String userIid;
  const IhaEklemeWidget({super.key, required this.userIid});

  @override
  State<IhaEklemeWidget> createState() => _IhaEklemeWidgetState();
}

class _IhaEklemeWidgetState extends State<IhaEklemeWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  bool obsocureText = true;
  String? errorMessage = '';

  IconData suffixIconData = Icons.remove_red_eye_outlined;

  Future<void> signIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final info = await _firestore
        .collection(Collections.Users.name)
        .doc(user?.uid)
        .get();

    await Auth().signInWithEmailAndPassword(email: info[0], password: info[3]);
  }

  Future<String?> createUserWithEmailAndPassword() async {
    try {
      String? uid = await Auth().createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => KullaniciHomePage()));
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          customText(
            context: context,
            text: 'İHA KAYDET',
            textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
          ),
          customTextField(
            controller: nameController,
            title: 'Name',
            prefixIconData: Icons.near_me_outlined,
            textInputAction: TextInputAction.next,
          ),
          customTextField(
            controller: modelController,
            title: 'Model',
            prefixIconData: Icons.type_specimen_outlined,
            textInputAction: TextInputAction.next,
          ),
          customTextField(
            controller: emailController,
            title: 'E-mail',
            prefixIconData: Icons.email_outlined,
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.emailAddress,
          ),
          customTextField(
            controller: passwordController,
            title: 'Password',
            prefixIconData: Icons.password_outlined,
            textInputAction: TextInputAction.done,
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
                      User? user = Auth().currentUser;

                      if (user!.uid.isNotEmpty) {
                        await FireStore().addIha(
                          ihaName: nameController.text,
                          ihaUid: 'ihaUid',
                          userUid: widget.userIid,
                          ihaModel: modelController.text,
                          ihaOwnerUid: widget.userIid,
                        );
                      }
                      await Auth().signOut();
                    },
                    title: 'Kayıt Et',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
