import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/services/pets.dart';
import 'package:flutter/material.dart';

class PetsProvider extends ChangeNotifier {
  List<Pet> pets = [
    Pet(
        name: "Lucifurr",
        image: "https://i.ibb.co/P6VJ4pZ/smile-cat-1.png",
        age: 2,
        gender: "male")
  ];

  Future<List<Pet>> // the function will eventually return a list of Pet
      getPets() async {
    //This means it can perform operations that might take time without blocking the main thread of execution.
    pets = await DioClient().getPets();
    //notifyListeners();
    return pets; //returns the list as the result of the function
  }
}
