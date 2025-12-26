import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kartal/kartal.dart';
import 'package:lottie/lottie.dart';
import 'package:overheard/features/profile/cubit/profile_cubit.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/extension/lottie_extension.dart';
import 'package:overheard/product/util/custom_sized_box.dart';

class CustomDialogs {
  static const dialogDurationMS = 1250;

  static showLoadingDialog({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            backgroundColor: ProductColors.instance.white.withValues(
              alpha: 0.15,
            ),
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: SizedBox(
              width: context.sized.dynamicWidth(1),
              height: context.sized.dynamicHeight(1),
              child: Center(
                child: Container(
                  width: context.sized.dynamicWidth(0.6),
                  height: context.sized.dynamicWidth(0.6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ProductColors.instance.white,
                  ),
                  child: Center(
                    child: Lottie.asset(
                      Lotties.loadingLottie.getPath,
                      width: context.sized.dynamicWidth(0.8),
                      height: context.sized.dynamicHeight(0.2),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  static showSuccessDialog({
    required BuildContext context,
    required String message,
    bool isSecondCloseActive = false,
    VoidCallback? onConfirm,
  }) {
    Future.delayed(const Duration(milliseconds: dialogDurationMS), () {
      if (context.mounted) {
        Navigator.pop(context);

        if (isSecondCloseActive) {
          Navigator.pop(context);
        }
      }
    });
    final AlertDialog successDialog = AlertDialog(
      elevation: 10,
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ProductColors.instance.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ProductColors.instance.emeraldGreen,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Lottie.asset(
                Lotties.success.getPath,
                width: context.sized.dynamicWidth(0.4),
                height: context.sized.dynamicHeight(0.2),
                repeat: false,
              ),
            ),
            CustomSizedBox.getSmall0005Seperator(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.titleMedium,
                  ).animate().slideY(begin: 1).fade(),
            ),
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => successDialog,
    );
  }

  static showErrorDialog({
    required BuildContext context,
    required String message,
  }) {
    Future.delayed(const Duration(milliseconds: dialogDurationMS), () {
      if (context.mounted) {
        Navigator.pop(context);
      }
    });

    final AlertDialog errorDialog = AlertDialog(
      elevation: 10,
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ProductColors.instance.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ProductColors.instance.firebrickRed,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Lottie.asset(
                Lotties.error.getPath,
                width: context.sized.dynamicWidth(0.3),
                height: context.sized.dynamicHeight(0.4),
                repeat: false,
              ),
            ),
            CustomSizedBox.getSmall0005Seperator(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.titleMedium,
                  ).animate().slideY(begin: 1).fade(),
            ),
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => errorDialog,
    );
  }

  static showErrorDialogAndNavigate({
    required BuildContext context,
    required String message,
    required String route,
  }) {
    Future.delayed(const Duration(milliseconds: dialogDurationMS), () {
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
      }
    });

    final AlertDialog errorDialog = AlertDialog(
      elevation: 10,
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ProductColors.instance.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ProductColors.instance.firebrickRed,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Lottie.asset(
                Lotties.error.getPath,
                width: context.sized.dynamicWidth(0.4),
                height: context.sized.dynamicHeight(0.2),
                repeat: false,
              ),
            ),
            CustomSizedBox.getSmall0005Seperator(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.titleMedium,
                  ).animate().slideY(begin: 1).fade(),
            ),
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => errorDialog,
    );
  }

  static showWarningDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onConfirm,
    required Null Function() voidCallback,
  }) {
    showDialog(
      builder: (context) {
        return AlertDialog(
          elevation: 10,
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ProductColors.instance.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Koyu sarı arka plan
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ProductColors.instance.yellow,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Lottie.asset(
                    Lotties.warning.getPath,
                    width: context.sized.dynamicWidth(0.4),
                    height: context.sized.dynamicHeight(0.2),
                    repeat: false,
                  ),
                ),
                CustomSizedBox.getSmall0005Seperator(context),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child:
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: context.general.textTheme.titleMedium,
                      ).animate().slideY(begin: 1).fade(),
                ),
                CustomSizedBox.getSmall0005Seperator(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: ProductColors.instance.grey,
                      ),
                      child: const Text("İptal"),
                    ),
                    FilledButton(
                      onPressed: onConfirm,
                      style: TextButton.styleFrom(
                        foregroundColor: ProductColors.instance.white,
                      ),
                      child: const Row(
                        children: [
                          Text("Devam Et"),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ],
                ),
                CustomSizedBox.getSmall0005Seperator(context),
              ],
            ),
          ),
        );
      },
      context: context,
    );
  }

  static showImageConfirmDialog(
    BuildContext context,
    File imageFile,
    ProfileCubit profileCubit,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text("Profil Fotoğrafı"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Bu resmi profil fotoğrafı olarak ayarlamak istiyor musunuz?",
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    imageFile,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Vazgeç",
                  style: TextStyle(color: ProductColors.instance.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  profileCubit.updateProfileImage(imageFile);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ProductColors.instance.tynantBlue,
                  foregroundColor: ProductColors.instance.white,
                ),
                child: const Text("Ayarla"),
              ),
            ],
          ),
    );
  }
}
