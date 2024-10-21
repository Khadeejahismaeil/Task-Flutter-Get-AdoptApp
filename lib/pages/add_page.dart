import 'package:flutter/material.dart';
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
