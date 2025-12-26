import 'package:equatable/equatable.dart';
import 'package:overheard/features/share/model/district_model.dart';

final class CityModel extends Equatable {
  final String id;
  final String name;
  final List<DistrictModel> districts;

  const CityModel({
    required this.id,
    required this.name,
    required this.districts,
  });

  @override
  List<Object> get props => [id, name, districts];
}
