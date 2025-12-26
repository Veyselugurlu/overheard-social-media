import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:overheard/common/cache/cache_manager.dart';
import 'package:overheard/common/providers/setup_locator.dart';
import 'package:overheard/common/routes/router.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/core/theme/custom_theme.dart';
import 'package:overheard/data/service/notification_service.dart';
import 'package:overheard/features/filter/cubit/filter_cubit.dart';
import 'package:overheard/features/home/cubit/home_cubit.dart';
import 'package:overheard/features/navigation/cubit/navigation_cubit.dart';
import 'package:overheard/features/profile/cubit/profile_cubit.dart';
import 'package:overheard/features/search/cubit/search_cubit.dart';
import 'package:overheard/features/settings/cubit/settings_cubit.dart';
import 'package:overheard/features/share/cubit/share_creation_cubit.dart';
import 'package:overheard/features/sign_up/cubit/sign_up_cubit.dart';
import 'package:overheard/features/splash/cubit/splash_cubit.dart';
import 'package:overheard/firebase_options.dart';
import 'package:overheard/features/login/cubit/login_cubit.dart';

final locator = GetIt.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupLocator();
  await locator<NotificationService>().initNotifications();
  await locator<CacheManager>().init();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder:
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => locator<SplashCubit>()),
              BlocProvider(create: (_) => locator<LoginCubit>()),
              BlocProvider(create: (_) => locator<SignUpCubit>()),
              BlocProvider(create: (_) => locator<NavigationCubit>()),
              BlocProvider(create: (_) => locator<ProfileCubit>()),
              BlocProvider(create: (_) => locator<HomeCubit>()),
              BlocProvider(create: (_) => locator<SearchCubit>()),
              BlocProvider(create: (_) => locator<ShareCreationCubit>()),
              BlocProvider(create: (_) => locator<FilterCubit>()),
              BlocProvider(
                create: (_) => locator<SettingsCubit>()..loadSettings(),
              ),
            ],
            child: const MyApp(),
          ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Over Heard',
      theme: CustomTheme.instance.apptheme,
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: Routes.splash,
    );
  }
}
