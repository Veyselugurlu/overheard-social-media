import 'package:equatable/equatable.dart';

final class DistrictModel extends Equatable {
  final String id;
  final String name;

  const DistrictModel({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}
