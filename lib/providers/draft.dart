/*



im in the middle of a flutter coding task and
i might need a bit of a help,
ill provide you with the files that im working on and pleas try not to change unnessury stuff

1)lib/models/pet.dart(import 'package:flutter/material.dart';
import 'package:adopt_app/widgets/add_form.dart'; 

class AddPage extends StatelessWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a New Pet"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: AddForm(), 
      ),
    );
  }
}
)

2)lib/models/pet.g.dart(// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pet _$PetFromJson(Map<String, dynamic> json) => Pet(
      id: json['id'] as int?,
      name: json['name'] as String,
      image: json['image'] as String,
      adopted: json['adopted'] as bool? ?? false,
      age: json['age'] as int,
      gender: json['gender'] as String,
    );

Map<String, dynamic> _$PetToJson(Pet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'age': instance.age,
      'adopted': instance.adopted,
      'gender': instance.gender,
    };
)
3)lib/pages/add_page.dart(import 'package:flutter/material.dart';
import 'package:adopt_app/widgets/add_form.dart'; 

class AddPage extends StatelessWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a New Pet"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: AddForm(), 
      ),
    );
  }
}
)
4)lib/pages/home_page.dart(import 'package:adopt_app/models/pet.dart';
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
        title: const Text("Pet"),
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
                      '/add'); //Navigate to AddPage when this button is pressed
                },
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
            FutureBuilder<List<Pet>>(
              future: Provider.of<PetsProvider>(context).getPets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('An error occurred: ${snapshot.error}'));
                } else {
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
)
5)lib/providers/pets_provider.dart(import 'package:adopt_app/models/pet.dart';
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
)
6)lib/services/pets.dart(import 'package:adopt_app/models/pet.dart';
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

  // Method to create a new pet
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
    } on DioException catch (error) {
      print(error);
      return null; // Return null in case of error
    }
  }
}
)
7)lib/widgets/add_form.dart(import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For handling file operations

class AddForm extends StatefulWidget {
  const AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();

  // Variables to hold the form data
  String _name = '';
  String _age = '';
  String _gender = '';

  // Image picker variables
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Pet Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a pet name';
              }
              return null;
            },
            onSaved: (value) {
              _name = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Pet Age'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an age';
              }
              if (int.tryParse(value) == null) {
                return 'Age must be a number';
              }
              return null;
            },
            onSaved: (value) {
              _age = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Gender'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a gender';
              }
              if (value != 'male' && value != 'female') {
                return 'Gender must be either male or female';
              }
              return null;
            },
            onSaved: (value) {
              _gender = value!;
            },
          ),
          const SizedBox(height: 20),
          // Row for image picker
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.image, size: 30),
                      const SizedBox(width: 10),
                      Text(_image == null
                          ? 'Select an Image'
                          : 'Image Selected')
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Display the image
          if (_image != null)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Image.file(_image!),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // TODO: Submit form and image data
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
)
8)lib/widgets/pet_card.dart(
import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/providers/pets_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  const PetCard({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              pet.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(pet.name),
                  Text("Age: ${pet.age}"),
                  Text("Gender: ${pet.gender}"),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Adopt"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
)
9)lib/main.dart(import 'package:adopt_app/pages/home_page.dart';
import 'package:adopt_app/providers/pets_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:adopt_app/pages/add_page.dart'; 


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PetsProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/', 
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add', // Define the route for AddPage
      builder: (context, state) => const AddPage(),
    ),
  ],
);
)
10)pubspec.yaml(name: adopt_app
description: A new Flutter project.

# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: "none" # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
version: 1.0.0+1

environment:
  sdk: ">=2.16.1 <3.0.0"

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2
  go_router: ^14.3.0
  provider: ^6.0.5
  dio: ^5.1.1
  image_picker: ^0.8.4
  build_runner: ^2.1.8
  json_serializable: ^6.1.5

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^5.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter.
flutter:
  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/assets-and-images/#resolution-aware.

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/assets-and-images/#from-packages

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/custom-fonts/#from-packages
)


this is the taskfrom the biggining, ill mark to you where i reached 
(### Part 2: Post Data

1. In `pages` folder, create a new page called `add_page.dart`.
2. Include this page within your routes in `main.dart`.
3. In your `home_page.dart` point the `add a new pet` button to the page we just created.
4. In your widgets folder, create `add_form.dart` widget and inside it initialize a stateFul widget.
5. Create a global key for your form.
6. Create a `Form` widget and assign it the key we just created.
7. Create `TextFormField`s for our properties except `adopted`, `image` and `id`.
8. Create a button to submit our data.
9. Import your widget in the `add_page.dart` and render it.
10. Back to `add_form.dart`, add a validator to each field as following:
All fields should not be empty.
Age should be of type int.
Gender should be either female or male
1. In your submit button `onPressed`, run your `_formKey.currentState!.validate()` and test your form.
2. On top of your form widget, create variables to hold our data.
3. In your `TextFormField`s `onSaved` property, assign each value to a the variable you created for it.
4. In your submit button `onPressed` check if the return of `_formKey.currentState!.validate()` is `true`, and if so, run `_formKey.currentState!.save()`.
5. Install the `image_picker` package.
flutter pub add image_picker
1. Import the package in `add_form.dart`.
2. On the top of your widget, create a variable to hold our image, and initialize an `ImagePicker` instance.
3. Within your rm after the text fields, Create a `Row` with a `GestureDetector` widget inside and a `Text` widget.
4. Within the `onTap` method, change it to `async` and call the `ImagePicker` instance to pick an image from the gallery.
5. Call `setState` and assign the result of the image picker to your `_image` variable your created earlier.
6. Inside your `Container` check if the user selected an image and if so, display this image using the `Image.File` widget.
7. Back to `services/pets.dart`, create a new function that returns a future `Pet` object and takes a `Pet` argument.
8. Inside, Create a variable of type `Pet` and mark it as `late`.
9. Create variable `data` of type `FormData` and assign it to `FormData.fromMap` and map your pet data inside it.
10. Create a request of type post to your endpoint and pass it the `data` variable we created:
Post, <https://coded-pets-api-crud.eapi.joincoded.com/pets>
1. Assign the `late` variable we created to the response, and return that variable.
2. Don't forget to wrap your call with a `try-catch` block.
i reached this point ==>>3. Back to your `providers/pets.dart`, create a void function called `createPet` that takes an argument of type `Pet`.
4. Inside it, call `PetsServices().createPet()` and pass to it the argument.
5. Store the result in a variable called `newPet`.
6. Insert this `newPet` in your `List` of pets in the provider.
7. Don't forget to call `notifyListeners`.
8. Lastly, Go to your submit button, and call the provider `createPet` function with `listen` set to `false` and pass it the data of our form.
9. Pop the screen so the user get's back to the home page.

### Part 3: Put Data

1. As you did with the `add_page.dart`, create a page for updating a pet, as well as a form for that, both expects a `Pet` argument.
2. Add your new page to your routes in `main.dart`, this time create a route param called `petId`.
3. Call your provider, look for the pet using the `petId` param, and pass it to the update page.
4. In the `pet_card.dart` you have an edit icon, clicking on it should take the user to the update page and pass the pet id with it.
5. In your form, access the pet argument using `widget.pet`.
6. Using this, add an initial value to your field.
7. Back to `services/pets.dart`, create a function that returns future `Pet`, requires an argument of type `Pet` and complete this function similarly to the `createPet` function you did.
8. Your endpoint is:

```
Put, <https://coded-pets-api-crud.eapi.joincoded.com/pets/{petId}>

```

1. Using string interpolation, inject the `pet.id` value within the url, and pass the `data` as a second argument.
2. In your provider, create a function `updatePet` that takes a `Pet` argument and call the `PetsServices().updatePet(pet: pet)`
3. Finally, find the index of the pet we want to replace, and replace the pet with the response we got and call `notifyListeners`.
4. In your update form submit button, call the provider function we just created and pass the form data.
5. Pop your screen so the user gets back to the `home_page`

)
take me step by step in every point like youre explaining it to a biggenar and writ a comments on the code itself, also when youre writing the code,
 write the wole code not part of it, 
and if its possible be spicific where to write each function keep in mind that im running this code on chrome




*/