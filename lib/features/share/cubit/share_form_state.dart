import 'package:equatable/equatable.dart';
import 'package:overheard/features/share/model/selection_card.dart';

class ShareFormState extends Equatable {
  final int stepIndex;
  final DateTime? postDateTime;
  final String? city;
  final String? district;
  final String description;
  final List<SelectionCard> selectcards;
  final SelectionCard selectedCard;
  final String? localImagePath;
  final String? uploadedImageUrl;
  final bool isUploading;
  final bool isSubmissionSuccessful;
  final double? latitude;
  final double? longitude;

  const ShareFormState({
    required this.selectcards,
    required this.selectedCard,
    required this.stepIndex,
    this.postDateTime,
    this.city,
    this.district,
    this.description = '',
    this.localImagePath,
    this.uploadedImageUrl,
    this.isUploading = false,
    this.isSubmissionSuccessful = false,
    this.latitude,
    this.longitude,
  });

  ShareFormState copyWith({
    int? stepIndex,
    DateTime? postDateTime,
    String? city,
    String? district,
    String? description,
    List<SelectionCard>? selectcards,
    SelectionCard? selectedCard,
    String? localImagePath,
    String? uploadedImageUrl,
    bool? isUploading,
    bool? isSubmissionSuccessful,
    double? latitude,
    double? longitude,
  }) {
    return ShareFormState(
      stepIndex: stepIndex ?? this.stepIndex,
      postDateTime: postDateTime ?? this.postDateTime,
      city: city ?? this.city,
      district: district ?? this.district,
      description: description ?? this.description,
      selectcards: selectcards ?? this.selectcards,
      selectedCard: selectedCard ?? this.selectedCard,
      localImagePath: localImagePath ?? this.localImagePath,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      isUploading: isUploading ?? this.isUploading,
      isSubmissionSuccessful:
          isSubmissionSuccessful ?? this.isSubmissionSuccessful,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
    stepIndex,
    selectcards,
    selectedCard,
    postDateTime,
    city,
    district,
    description,
    localImagePath,
    uploadedImageUrl,
    isUploading,
    isSubmissionSuccessful,
    latitude,
    longitude,
  ];
}
