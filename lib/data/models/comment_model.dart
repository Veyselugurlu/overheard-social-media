import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentModel extends Equatable {
  final String id;
  final String name;
  final String postId;
  final String userId;
  final String text;
  final DateTime timestamp;
  final List<String> likedUsers;
  final int likesCount;

  const CommentModel({
    required this.id,
    required this.name,
    required this.postId,
    required this.userId,
    required this.text,
    required this.timestamp,
    this.likedUsers = const [],
    this.likesCount = 0,
  });
  factory CommentModel.fromMap(String id, Map<String, dynamic> map) {
    final Timestamp? timestamp = map['timestamp'] as Timestamp?;

    return CommentModel(
      id: id,
      name: map['name'] as String? ?? "bilinmeyen kullanıcı",
      postId: map['postId'] as String,
      userId: map['userId'] as String,
      text: map['text'] as String,
      timestamp: timestamp?.toDate() ?? DateTime.now(),
      likedUsers: List<String>.from(map['likedUsers'] as List<dynamic>? ?? []),
      likesCount: map['likesCount'] as int? ?? 0,
    );
  }
  CommentModel copyWith({
    String? id,
    String? name,
    String? postId,
    String? userId,
    String? text,
    DateTime? timestamp,
    List<String>? likedUsers,
    int? likesCount,
  }) {
    return CommentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      likedUsers: likedUsers ?? this.likedUsers,
      likesCount: likesCount ?? this.likesCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    postId,
    userId,
    text,
    timestamp,
    likedUsers,
    likesCount,
  ];
}
