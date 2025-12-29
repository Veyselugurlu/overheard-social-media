import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/features/settings/cubit/setting_state.dart';
import 'package:overheard/features/settings/cubit/settings_cubit.dart';
import 'package:overheard/features/settings/widgets/profile_info_card.dart';
import 'package:overheard/features/settings/widgets/settings_cards.dart';
import 'package:overheard/features/settings/widgets/update_profile_bottom_sheet.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/util/custom_dialogs.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SettingsCubit>();
      // Eğer içindeki kullanıcı o anki giriş yapanla eşleşmiyorsa veya null ise yükle
      cubit.loadSettings();
    });
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.actionTye == ActionTyes.success &&
            state.actionMessage != null) {
          CustomDialogs.showSuccessDialog(
            context: context,
            message: state.actionMessage!,
          );

          if (state.actionMessage!.contains("Oturum") ||
              state.actionMessage!.contains("Hesabınız")) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (context.mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
              }
            });
          }
        }

        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Hata: ${state.errorMessage}"),
              backgroundColor: ProductColors.instance.red,
            ),
          );
        }
      },
      builder: (context, state) {
        //  Yükleme ve Başlangıç Durumu
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.user != null) {
          final user = state.user;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              centerTitle: true,
              backgroundColor: ProductColors.instance.white,
              elevation: 0.5,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: ProductColors.instance.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            backgroundColor: ProductColors.instance.white,
            body: SingleChildScrollView(
              padding: const ProductPadding.allMedium(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profil Kartı
                  ProfileInfoCard(
                    name: user!.name,
                    age: user.age.toString(),
                    onViewProfile: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 30),

                  // Hesap Yönetimi
                  _buildSectionTitle(context, 'Account Management'),
                  ActionTile(
                    icon: Icons.edit,
                    title: 'Hesap Bilgilerini Güncelle',
                    subtitle: 'Ad, Soyad, Şehir ve diğer bilgileri düzenle',
                    onTap:
                        () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: ProductColors.instance.white,
                          builder: (context) => UpdateProfileSheet(user: user),
                        ),
                  ),
                  const SizedBox(height: 30),

                  // Destek Bölümü
                  _buildSectionTitle(context, 'Support & Legal'),
                  ActionTile(
                    icon: Icons.lock_outline,
                    title: 'Gizlilik Politikası',
                    subtitle: 'Verilerinizin nasıl kullanıldığını öğrenin',
                    onTap:
                        () =>
                            Navigator.pushNamed(context, Routes.privacyPolicy),
                  ),
                  const SizedBox(height: 30),

                  // Oturum İşlemleri
                  _buildSectionTitle(context, 'Session Actions'),
                  ActionTile(
                    icon: Icons.logout,
                    title: 'Oturumu Kapat',
                    color: ProductColors.instance.customBlue1,
                    onTap: () {
                      CustomDialogs.showWarningDialog(
                        context: context,
                        message: "Çıkış yapmak istediğinize emin misiniz?",
                        onConfirm: () {
                          context.read<SettingsCubit>().signOut();
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, Routes.login);
                        },
                        voidCallback: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  ActionTile(
                    icon: Icons.delete_forever_outlined,
                    title: 'Hesabı Sil',
                    color: ProductColors.instance.red,
                    onTap: () {
                      CustomDialogs.showWarningDialog(
                        context: context,
                        message: "hesabı silmek istediğinize emin misiniz?",
                        onConfirm: () {
                          context.read<SettingsCubit>().deleteAccount();
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, Routes.login);
                        },
                        voidCallback: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: ProductColors.instance.grey600,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
