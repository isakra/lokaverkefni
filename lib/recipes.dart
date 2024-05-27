import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

Future<List<Recipe>> readRecipes() async {
  final String recipesJson = await rootBundle.loadString('assets/recipes.json');
  List<dynamic> decoded = jsonDecode(recipesJson);
  print(decoded);
  return decoded.map((json) => Recipe.fromJson(json)).toList();
}

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    List<Recipe> recipes = await readRecipes();
    setState(() {
      _recipes = recipes;
      print(recipes);
    });
  }

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
