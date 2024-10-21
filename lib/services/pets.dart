import 'dart:typed_data'; // For handling image bytes in web
import 'package:adopt_app/models/pet.dart';
import 'package:dio/dio.dart';
import 'dart:io'; // Import File for handling image files

class DioClient {
  final Dio _dio = Dio();

  // Method to get the list of pets
  Future<List<Pet>> getPets() async {
    List<Pet> pets = [];
    try {
      Response response =
          await _dio.get("https://coded-pets-api-crud.eapi.joincoded.com/pets");
      pets = (response.data as List).map((pet) => Pet.fromJson(pet)).toList();
    } on DioError catch (error) {
      print(error);
    }
    return pets;
  }

  // Method to create a new pet (mobile)
  Future<Pet?> createPet(Pet pet, File imageFile) async {
    try {
      // Prepare the data to be sent
      FormData formData = FormData.fromMap({
        'name': pet.name,
        'age': pet.age,
        'gender': pet.gender,
        'adopted': pet.adopted,
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      // Make the POST request
      Response response = await _dio.post(
        "https://coded-pets-api-crud.eapi.joincoded.com/pets",
        data: formData,
      );

      // Return the created pet from the response
      return Pet.fromJson(response.data);
    } on DioError catch (error) {
      print(error);
      return null; // Return null in case of error
    }
  }

  // Method to create a new pet with image bytes (web)
  Future<Pet?> createPetWithBytes(Pet pet, Uint8List imageBytes) async {
    try {
      // Prepare the data to be sent
      FormData formData = FormData.fromMap({
        'name': pet.name,
        'age': pet.age,
        'gender': pet.gender,
        'adopted': pet.adopted,
        'image': MultipartFile.fromBytes(imageBytes, filename: 'pet_image.png'),
      });

      // Make the POST request
      Response response = await _dio.post(
        "https://coded-pets-api-crud.eapi.joincoded.com/pets",
        data: formData,
      );

      // Return the created pet from the response
      return Pet.fromJson(response.data);
    } on DioError catch (error) {
      print(error);
      return null; // Return null in case of error
    }
  }
}
