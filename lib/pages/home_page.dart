import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/providers/pets_provider.dart';
import 'package:adopt_app/widgets/pet_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Adoption"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  context.go(
                      '/add'); // Navigate to AddPage when this button is pressed
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Add a New Pet"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<PetsProvider>(context, listen: false)
                      .getPets(); // Fetch pets on button press
                },
                child: const Text("Fetch Pets"),
              ),
            ),
            const SizedBox(height: 20),
            // Consumer for PetsProvider to listen to changes in pets list
            Consumer<PetsProvider>(
              builder: (context, petsProvider, child) {
                if (petsProvider.pets == null) {
                  return const Center(
                      child: Text('Press "Fetch Pets" to load data'));
                } else if (petsProvider.pets!.isEmpty) {
                  return const Center(child: Text('No pets available'));
                }

                // Display the grid of pets once data is fetched
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two items per row
                    childAspectRatio:
                        0.75, // Adjust the aspect ratio for proper layout
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: petsProvider.pets!.length,
                  itemBuilder: (context, index) {
                    final pet = petsProvider.pets![index];
                    return PetCard(pet: pet);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
