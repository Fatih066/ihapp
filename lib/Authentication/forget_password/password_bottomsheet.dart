import 'package:flutter/material.dart';
import 'package:ihapp/consts/paddings.dart';
import 'package:ihapp/widgets/custom_text.dart';

import '../../functions/custom_functions.dart';
import 'forget_password.dart';

Widget customBottomSheet(BuildContext context) {
  return Padding(
    padding: horizantalPadding20,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: topPadding20 * 2,
          child: customText(
            context: context,
            text: 'Bir Seçim Yap',
            textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
          ),
        ),
        const SizedBox(height: 5),
        customText(
          context: context,
          text:
              'Şifreni sıfırlayabilmek için aşağıdaki seçeneklerden birisini seç.',
          textStyle:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 30),
        Card(
          color: Colors.transparent,
          child: Padding(
            padding: verticalPadding20 / 1.5,
            child: ListTile(
              onTap: () {
                GoPagePushReplacement(
                    widget: const ForgetPassword(), context: context);
              },
              autofocus: false,
              iconColor: Colors.black,
              leading: const Icon(Icons.email_outlined, size: 60),
              title: customText(
                  context: context,
                  text: 'E-mail',
                  textStyle: Theme.of(context).textTheme.titleLarge),
              subtitle: customText(
                  context: context,
                  text: 'E-mailin ile şifreni sıfırla',
                  textStyle: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ),
        Card(
          color: Colors.transparent,
          child: Padding(
            padding: verticalPadding20 / 1.5,
            child: ListTile(
              autofocus: false,
              iconColor: Colors.black,
              leading: const Icon(Icons.mobile_friendly_outlined, size: 60),
              title: customText(
                  context: context,
                  text: 'Telefon Numarası',
                  textStyle: Theme.of(context).textTheme.titleLarge),
              subtitle: customText(
                  context: context,
                  text: 'Telefon numarası ile şifreni sıfırla (Coming Soon)',
                  textStyle: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ),
      ],
    ),
  );
}
