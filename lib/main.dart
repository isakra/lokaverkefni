import 'dart:io';

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

void main() {}
