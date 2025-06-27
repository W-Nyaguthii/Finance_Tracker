import 'package:flutter/material.dart';

class AddExpense extends StatelessWidget {
  const AddExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Add Expenses",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          TextFormField(),
          SizedBox(height: 16),
          TextFormField(),
          SizedBox(height: 16),
          TextFormField(),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {},
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
