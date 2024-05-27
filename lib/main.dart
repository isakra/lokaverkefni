import 'dart:io';
import 'package:flutter/material.dart';
import 'recipes.dart';

class Category {
  String id;
  String title;

  Category(this.id, this.title);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      json['id'],
      json['title'],
    );
  }
}

class Tag {
  String id;
  String title;

  Tag(this.id, this.title);

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      json['id'],
      json['title'],
    );
  }
}

class Ingredient {
  String id;
  String title;

  Ingredient(this.id, this.title);

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      json['id'],
      json['title'],
    );
  }
}

class Recipe {
  String id;
  String title;
  String image;
  List<Ingredient> ingredients;
  List<Tag> tags;
  Category category;
  String instructions;

  Recipe(this.id, this.title, this.image, this.instructions, this.ingredients,
      this.tags, this.category);

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      json['id'],
      json['title'],
      json['image'],
      json['instructions'],
      (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      (json['tags'] as List<dynamic>).map((e) => Tag.fromJson(e)).toList(),
      Category.fromJson(json['category']),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: MainScreen(),
      ),
      routes: {'/recipes': (context) => RecipesScreen()},
    ),
  );
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 173, 58, 183),
              Color.fromARGB(255, 58, 58, 183),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "BestRecipes!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
            new ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipesScreen()),
                );
              },
              child: Text('Go to Recipes'),
            ),
          ],
        ));
  }
}
