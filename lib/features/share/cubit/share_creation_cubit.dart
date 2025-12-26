import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/features/share/cubit/share_form_state.dart';
import 'package:overheard/features/share/model/selection_card.dart';
import 'package:overheard/features/share/repo/share_repo.dart';

final List<SelectionCard> _selectCards = [
  const SelectionCard(
    id: 'myself',
    title: 'Myself',
    subtitle: 'Share your own profile',
    isSelected: true,
    icon: Icons.person,
  ),
  const SelectionCard(
    id: 'someone_else',
    title: 'Someone else',
    subtitle: 'Post about another person',
    isSelected: false,
    icon: Icons.people_alt,
  ),
];

class ShareCreationCubit extends Cubit<ShareFormState> {
  final int totalSteps = 4;
  final ShareRepository _shareRepository;

  ShareCreationCubit(this._shareRepository)
    : super(
        ShareFormState(
          stepIndex: 0,
          selectcards: _selectCards,
          selectedCard: _selectCards.first,
        ),
      );

  void nextStep() {
    if (state.stepIndex < totalSteps - 1) {
      emit(state.copyWith(stepIndex: state.stepIndex + 1));
    }
  }

  void clearProgressAppbar() {
    emit(state.copyWith(stepIndex: 0));
  }

  void previousStep() {
    if (state.stepIndex > 0) {
      emit(state.copyWith(stepIndex: state.stepIndex - 1));
    }
  }

  void updatePostTarget(SelectionCard targetCard) {
    emit(state.copyWith(selectedCard: targetCard));
  }

  void updatePostDateTime(DateTime? dateTime) {
    emit(state.copyWith(postDateTime: dateTime));
  }

  void updateCity(String cityName) async {
    emit(state.copyWith(city: cityName, district: null));
    await _resolveCoordinates(cityName, null);
  }

  void updateDistrict(String? districtName) async {
    emit(state.copyWith(district: districtName));
    await _resolveCoordinates(state.city ?? '', districtName);
  }

  Future<void> _resolveCoordinates(String city, String? district) async {
    try {
      final String fullAddress = "$city ${district ?? ""}, Turkey";
      final List<Location> locations = await locationFromAddress(fullAddress);

      if (locations.isNotEmpty) {
        emit(
          state.copyWith(
            latitude: locations.first.latitude,
            longitude: locations.first.longitude,
          ),
        );
        //   print("Konum Başarıyla Belirlendi: ${locations.first.latitude}");
      }
    } catch (e) {
      debugPrint("Koordinat dönüştürme hatası: $e");
    }
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      emit(state.copyWith(localImagePath: pickedFile.path));
    } else {
      emit(state.copyWith(localImagePath: null));
    }
  }

  Future<String?> uploadImageToFirebase() async {
    final localPath = state.localImagePath;
    if (localPath == null) return null;

    try {
      emit(state.copyWith(isUploading: true));

      final imageUrl = await _shareRepository.uploadImageFile(File(localPath));

      emit(state.copyWith(uploadedImageUrl: imageUrl, isUploading: false));

      return imageUrl;
    } catch (e) {
      emit(state.copyWith(isUploading: false));
      return null;
    }
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  String _getAuthenticatedUserId() {
    return _shareRepository.getCurrentUserId();
  }

  void submitForm() async {
    if (state.isUploading) return;

    emit(state.copyWith(isUploading: true));

    try {
      final imageUrl = await uploadImageToFirebase();

      if (imageUrl == null) {
        emit(state.copyWith(isUploading: false));
        return;
      }

      final String currentUserId = _getAuthenticatedUserId();

      final PostModel newPost = PostModel.fromShareState(
        state,
        imageUrl,
        currentUserId,
      );

      await _shareRepository.savePost(newPost);

      emit(state.copyWith(isUploading: false, isSubmissionSuccessful: true));
    } catch (e) {
      emit(state.copyWith(isUploading: false));
    } finally {
      resetForm();
    }
  }

  void resetForm() {
    emit(
      ShareFormState(
        stepIndex: 0,
        selectcards: _selectCards,
        selectedCard: _selectCards.first,
        description: '',
        city: null,
        district: null,
        localImagePath: null,
        uploadedImageUrl: null,
        postDateTime: null,
        isUploading: false,
        isSubmissionSuccessful: false,
        latitude: null,
        longitude: null,
      ),
    );
  }
}
