import 'package:equatable/equatable.dart';
import 'package:overheard/data/models/user_model.dart';

enum ActionTyes { error, warring, success }

class SettingsState extends Equatable {
  const SettingsState({
    this.user,
    this.actionMessage,
    this.actionTye,
    this.errorMessage,
    this.isLoading = false,
  });

  final UserModel? user;
  final bool isLoading;
  final String? actionMessage;
  final ActionTyes? actionTye;
  final String? errorMessage;

  // 🏆 copyWith Metodu
  SettingsState copyWith({
    UserModel? user,
    bool? isLoading,
    String? actionMessage,
    ActionTyes? actionTye,
    String? errorMessage,
  }) {
    return SettingsState(
      user: user ?? this.user,
      actionMessage: actionMessage ?? this.actionMessage,
      actionTye: actionTye ?? this.actionTye,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    user,
    actionMessage,
    actionTye,
    errorMessage,
    isLoading,
  ];
}
