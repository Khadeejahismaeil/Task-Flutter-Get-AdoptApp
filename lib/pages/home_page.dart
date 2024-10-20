// import 'package:adopt_app/models/pet.dart';
// import 'package:adopt_app/providers/pets_provider.dart';
// import 'package:adopt_app/widgets/pet_card.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     List<Pet> pets = Provider.of<PetsProvider>(context).pets;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Pet Adopt"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: const Padding(
//                   padding: EdgeInsets.all(12.0),
//                   child: Text("Add a new Pet"),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Provider.of<PetsProvider>(context, listen: false).getPets();
//               },
//               child: const Text("GET"),
//             ),
//             GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: MediaQuery.of(context).size.width /
//                       (MediaQuery.of(context).size.height),
//                 ),
//                 physics: const NeverScrollableScrollPhysics(), // <- Here
//                 itemCount: pets.length,
//                 itemBuilder: (context, index) => PetCard(pet: pets[index])),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
        title: const Text("Pet Adopt"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Add a new Pet"),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<PetsProvider>(context, listen: false).getPets();
              },
              child: const Text("GET"),
            ),
            // 1. In your `pages/home_page.dart`, Wrap your grid view builder with a `FutureBuilder` widget.
            FutureBuilder<List<Pet>>(
              future: Provider.of<PetsProvider>(context).getPets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('An error occurred: ${snapshot.error}'));
                } else {
                  // Access the list of pets from the snapshot data
                  final pets = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height),
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pets.length,
                    itemBuilder: (context, index) => PetCard(pet: pets[index]),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
/*
Explanation of the changes:

000 We've wrapped the GridView.builder with a FutureBuilder widget.

The future property of the FutureBuilder is set to the getPets function 
called on the PetsProvider obtained using Provider.of.
The builder callback function of the FutureBuilder takes a snapshot argument that contains information about the state of the asynchronous operation.
We check the connection state using snapshot.connectionState:
If it's ConnectionState.waiting, we display a circular progress indicator.
If there's an error, we display an error message using snapshot.error.
If the data is successfully fetched, we access the list of pets from snapshot.data!. Note the exclamation mark (!) to indicate that we are sure the data is available at this point.
Finally, we build the GridView.builder with the retrieved list of pets.
This approach ensures that the UI displays a spinner while data is being fetched and handles potential errors gracefully.*/