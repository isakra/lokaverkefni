import 'dart:io';
import 'package:flutter/material.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
      ),
      body: Center(
        child: ElevatedButton(
            child: Text("Go back"),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
