// import 'package:json_annotation/json_annotation.dart';

// part 'pet.g.dart';

// @JsonSerializable()
// class Pet {
//   final int? id;
//   final String name;
//   final String image;
//   final int age;
//   final bool adopted;
//   final String gender;
//    String? imagePath; // Image path

//   Pet({
//       this.id,
//       required this.name,
//       required this.image,
//       this.adopted = false,
//       required this.age,
//       required this.gender
//       this.imagePath});

//   factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
//   Map<String, dynamic> toJson() => _$PetToJson(this);
// }
import 'package:json_annotation/json_annotation.dart';

part 'pet.g.dart';

@JsonSerializable()
class Pet {
  final int? id;
  final String name;
  final String image;
  final int age;
  final bool adopted;
  final String gender;
  final String? imagePath; // Image path

  Pet({
    this.id,
    required this.name,
    required this.image,
    this.adopted = false,
    required this.age,
    required this.gender,
    this.imagePath, // Added missing comma here
  });

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
  Map<String, dynamic> toJson() => _$PetToJson(this);
}
