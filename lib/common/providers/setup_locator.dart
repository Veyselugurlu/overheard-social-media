import 'package:get_it/get_it.dart';
import 'package:overheard/common/cache/cache_manager.dart';
import 'package:overheard/data/service/notification_service.dart';
import 'package:overheard/features/filter/cubit/filter_cubit.dart';
import 'package:overheard/features/filter/repo/filter_repository.dart';
import 'package:overheard/features/post_detail/cubit/post_detail_cubit.dart';
import 'package:overheard/features/home/repo/home_repository.dart';
import 'package:overheard/common/repositories/login_repositories.dart';
import 'package:overheard/common/repositories/sign_up_repository.dart';
import 'package:overheard/data/service/base_service.dart';
import 'package:overheard/features/home/cubit/home_cubit.dart';
import 'package:overheard/features/login/cubit/login_cubit.dart';
import 'package:overheard/features/navigation/cubit/navigation_cubit.dart';
import 'package:overheard/features/profile/cubit/profile_cubit.dart';
import 'package:overheard/features/profile/repo/profile_repository.dart';
import 'package:overheard/features/search/cubit/search_cubit.dart';
import 'package:overheard/features/search/repo/search_repository.dart';
import 'package:overheard/features/settings/cubit/settings_cubit.dart';
import 'package:overheard/features/settings/repo/setting_repositories.dart';
import 'package:overheard/features/share/cubit/share_creation_cubit.dart';
import 'package:overheard/features/share/repo/share_repo.dart';
import 'package:overheard/features/sign_up/cubit/sign_up_cubit.dart';
import 'package:overheard/features/splash/cubit/splash_cubit.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator
    ..registerLazySingleton<CacheManager>(CacheManager.new)
    ..registerLazySingleton<FirebaseDataSource>(FirebaseDataSource.new)
    ..registerLazySingleton<LoginRepository>(
      () => LoginRepository(firebaseDataSource: locator<FirebaseDataSource>()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () =>
          ProfileRepository(firebaseDataSource: locator<FirebaseDataSource>()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () =>
          SettingsRepository(firebaseDataSource: locator<FirebaseDataSource>()),
    )
    ..registerLazySingleton<NotificationService>(NotificationService.new)
    ..registerFactory<ProfileCubit>(
      () => ProfileCubit(repository: locator<ProfileRepository>()),
    )
    ..registerLazySingleton<LoginCubit>(
      () => LoginCubit(repository: locator<LoginRepository>()),
    )
    ..registerLazySingleton<ShareRepository>(
      () => ShareRepository(firebaseDataSource: locator<FirebaseDataSource>()),
    )
    ..registerLazySingleton<SignUpRepository>(
      () => SignUpRepository(firebaseDataSource: locator<FirebaseDataSource>()),
    )
    ..registerLazySingleton<FilterRepository>(
      () => FilterRepository(firebaseDataSource: locator<FirebaseDataSource>()),
    )
    ..registerFactory<ShareCreationCubit>(
      () => ShareCreationCubit(locator<ShareRepository>()),
    )
    ..registerFactory<SplashCubit>(
      () => SplashCubit(repository: locator<LoginRepository>()),
    )
    ..registerLazySingleton<NavigationCubit>(NavigationCubit.new)
    ..registerFactory<SignUpCubit>(
      () => SignUpCubit(repository: locator<SignUpRepository>()),
    )
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepository(firebaseDataSource: locator<FirebaseDataSource>()),
    )
    ..registerFactory<HomeCubit>(
      () => HomeCubit(repository: locator<HomeRepository>()),
    )
    ..registerLazySingleton<SearchRepository>(
      () => SearchRepository(firebaseDataSource: locator<FirebaseDataSource>()),
    )
    ..registerFactory<SearchCubit>(
      () => SearchCubit(repository: locator<SearchRepository>()),
    )
    ..registerFactory<PostDetailCubit>(
      () => PostDetailCubit(locator<ShareRepository>()),
    )
    ..registerFactory<FilterCubit>(
      () => FilterCubit(repository: locator<FilterRepository>()),
    )
    ..registerFactory<SettingsCubit>(
      () => SettingsCubit(locator<SettingsRepository>()),
    );
}
