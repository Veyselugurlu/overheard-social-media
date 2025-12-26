import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overheard/features/share/cubit/share_form_state.dart';
import 'package:uuid/uuid.dart';

@immutable
class PostModel {
  final String id;
  final String userId;
  final String photoUrl;

  final String? city;
  final String? district;
  final DateTime? heardAt;
  final String targetProfileId; // myself/someone_else)

  final String description;
  final int greenFlagCount;
  final int redFlagCount;
  final List<String> commentIds;
  final DateTime? timestamp;

  final List<String> greenFlagUsers;
  final List<String> redFlagUsers;
  final double? latitude;
  final double? longitude;

  const PostModel({
    required this.id,
    required this.userId,
    required this.photoUrl,

    this.city,
    this.district,
    this.heardAt,
    required this.targetProfileId,
    this.description = '',
    this.greenFlagCount = 0,
    this.redFlagCount = 0,
    this.commentIds = const [],
    this.timestamp,
    this.greenFlagUsers = const [],
    this.redFlagUsers = const [],
    this.latitude,
    this.longitude,
  });
  PostModel copyWith({
    String? id,
    String? userId,
    String? photoUrl,
    String? city,
    String? district,
    DateTime? heardAt,
    String? targetProfileId,
    String? description,
    int? greenFlagCount,
    int? redFlagCount,
    List<String>? commentIds,
    DateTime? timestamp,
    List<String>? greenFlagUsers,
    List<String>? redFlagUsers,
    double? latitude,
    double? longitude,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      photoUrl: photoUrl ?? this.photoUrl,
      city: city ?? this.city,
      district: district ?? this.district,
      heardAt: heardAt ?? this.heardAt,
      targetProfileId: targetProfileId ?? this.targetProfileId,
      description: description ?? this.description,
      greenFlagCount: greenFlagCount ?? this.greenFlagCount,
      redFlagCount: redFlagCount ?? this.redFlagCount,
      commentIds: commentIds ?? this.commentIds,
      timestamp: timestamp ?? this.timestamp,
      greenFlagUsers: greenFlagUsers ?? this.greenFlagUsers,
      redFlagUsers: redFlagUsers ?? this.redFlagUsers,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'photoUrl': photoUrl,
      'description': description,
      'city': city,
      'district': district,
      'heardAt': heardAt != null ? Timestamp.fromDate(heardAt!) : null,
      'targetProfileId': targetProfileId,
      'greenFlagCount': greenFlagCount,
      'redFlagCount': redFlagCount,
      'commentIds': commentIds,
      'timestamp': FieldValue.serverTimestamp(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory PostModel.fromMap(String id, Map<String, dynamic> map) {
    final Timestamp? timestamp = map['timestamp'] as Timestamp?;
    final Timestamp? heardAtTimestamp = map['heardAt'] as Timestamp?;

    return PostModel(
      id: id,
      userId: map['userId'] as String,
      photoUrl: map['photoUrl'] as String,

      city: map['city'] as String?,
      district: map['district'] as String?,
      heardAt: heardAtTimestamp?.toDate(),
      targetProfileId: map['targetProfileId'] as String,

      description: map['description'] as String? ?? '',
      greenFlagCount: map['greenFlagCount'] as int? ?? 0,
      redFlagCount: map['redFlagCount'] as int? ?? 0,
      commentIds: List<String>.from((map['commentIds'] as List?) ?? []),
      timestamp: timestamp?.toDate(),
      greenFlagUsers: List<String>.from((map['greenFlagUsers'] as List?) ?? []),
      redFlagUsers: List<String>.from((map['redFlagUsers'] as List?) ?? []),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  //state-> model
  factory PostModel.fromShareState(
    ShareFormState state,
    String photoUrl,
    String userId,
  ) {
    return PostModel(
      id: const Uuid().v4(),
      userId: userId,
      photoUrl: photoUrl,
      description: state.description,

      city: state.city,
      district: state.district,
      latitude: state.latitude,
      longitude: state.longitude,
      heardAt: state.postDateTime,
      targetProfileId: state.selectedCard.id,

      greenFlagCount: 0,
      redFlagCount: 0,
      commentIds: const [],
    );
  }
}
