import 'dart:io';
import 'package:flutter/material.dart';

class Category {
  int id;
  String title;

  Category(this.id, this.title);
}

class Tag {
  int id;
  String title;

  Tag(this.id, this.title);
}

class Ingredient {
  int id;
  String title;

  Ingredient(this.id, this.title);
}

class Recipe {
  int id;
  String title;
  String image;
  List<Ingredient> ingredients;
  List<Tag> tags;
  Category category;
  String instructions;

  Recipe(this.id, this.title, this.image, this.instructions, this.ingredients,
      this.tags, this.category);
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GradientContainer(),
      ),
    ),
  );
}

class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key});

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
      child: const Center(
        child: Text(
          "BestRecipes!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
