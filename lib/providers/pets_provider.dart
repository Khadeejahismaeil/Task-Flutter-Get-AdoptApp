import 'dart:typed_data'; // For handling image bytes in web
import 'package:adopt_app/models/pet.dart';
import 'package:flutter/material.dart';
import 'package:adopt_app/services/pets.dart'; // For accessing DioClient

class PetsProvider extends ChangeNotifier {
  List<Pet> pets = [
    Pet(
      name: "Lucifurr",
      image: "https://i.ibb.co/P6VJ4pZ/smile-cat-1.png",
      age: 2,
      gender: "male",
    ),
  ];

  // Function to fetch pets
  Future<List<Pet>> getPets() async {
    pets = await DioClient().getPets();
    notifyListeners();
    return pets;
  }

  // Function to create a new pet with web-compatible image bytes
  Future<void> createPetWithBytes(Pet pet, Uint8List imageBytes) async {
    // Use DioClient's method to create a new pet by sending image bytes
    Pet? newPet = await DioClient().createPetWithBytes(pet, imageBytes);

    if (newPet != null) {
      pets.add(newPet); // Add the new pet to the list
      notifyListeners(); // Notify listeners to rebuild UI
    }
  }
}
