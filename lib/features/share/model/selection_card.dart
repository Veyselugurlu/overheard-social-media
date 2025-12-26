import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart' show IconData;

final class SelectionCard extends Equatable {
  final String title;
  final String subtitle;
  final bool isSelected;
  final IconData icon;
  final String id;

  const SelectionCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, title, subtitle, isSelected, icon];
}
