enum Lotties { loadingLottie, success, error, warning }

extension LottieExtension on Lotties {
  String get getPath => "assets/lotties/$name.json";
}
