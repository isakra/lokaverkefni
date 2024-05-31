import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:universal_io/io.dart';

void main() {
  runApp(const MyApp());
}

class Category {
  String id;
  String title;

  Category(this.id, this.title);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(json['id'], json['title']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class Tag {
  String id;
  String title;

  Tag(this.id, this.title);

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(json['id'], json['title']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class Ingredient {
  String id;
  String title;

  Ingredient(this.id, this.title);

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(json['id'], json['title']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
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
  int cookingTime;

  Recipe(this.id, this.title, this.image, this.instructions, this.ingredients,
      this.tags, this.category, this.cookingTime);

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      json['id'],
      json['title'],
      json['image'],
      json['instructions'],
      (json['ingredients'] as List).map((e) => Ingredient.fromJson(e)).toList(),
      (json['tags'] as List).map((e) => Tag.fromJson(e)).toList(),
      Category.fromJson(json['category']),
      json['cookingTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'instructions': instructions,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'tags': tags.map((e) => e.toJson()).toList(),
      'category': category.toJson(),
      'cookingTime': cookingTime,
    };
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RecipesScreen(title: 'Recipes'),
    );
  }
}

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key, required this.title});
  final String title;

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  String _searchQuery = '';

  Future<void> _loadRecipes() async {
    print('Loading recipes');
    String jsonString = await rootBundle.loadString('assets/data/recipes.json');
    List<dynamic> json = jsonDecode(jsonString);
    for (var item in json) {
      try {
        final id = item['id'];
        final title = item['title'];
        final image = item['image'];
        final instructions = item['instructions'];
        Category category =
            Category(item['category']['id'], item['category']['title']);
        List<Ingredient> ingredients =
            (item['ingredients'] as List).map((ingredient) {
          return Ingredient(ingredient['id'], ingredient['title']);
        }).toList();
        List<Tag> tags = (item['tags'] as List).map((tag) {
          return Tag(tag['id'], tag['title']);
        }).toList();
        final cookingTime = item['cookingTime'];

        Recipe recipe = Recipe(id, title, image, instructions, ingredients,
            tags, category, cookingTime);
        _recipes.add(recipe);
      } catch (e) {
        print(e);
      }
    }

    setState(() {
      _filteredRecipes = _recipes;
    });

    print('Recipes loaded');
  }

  void _filterRecipes(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _filteredRecipes = _recipes;
      } else {
        _filteredRecipes = _recipes.where((recipe) {
          return recipe.title.toLowerCase().contains(query.toLowerCase()) ||
              recipe.ingredients.any((ingredient) =>
                  ingredient.title.toLowerCase().contains(query.toLowerCase()));
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterRecipes,
            ),
            Expanded(
              child: ListView(
                children: _filteredRecipes.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.image.isNotEmpty)
                          Image.asset(
                            'assets/images/${item.image}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailsScreen(recipe: item),
                              ),
                            );
                          },
                          child: const Text('View'),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddRecipeScreen(),
                  ),
                );
              },
              child: const Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(recipe.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recipe.image.isNotEmpty)
                Image.asset('assets/images/${recipe.image}'),
              const SizedBox(height: 10),
              const Text(
                'Ingredients',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.ingredients.map((ingredient) {
                  return Text(ingredient.title);
                }).toList(),
              ),
              const SizedBox(height: 10),
              const Text(
                'Instructions',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(recipe.instructions),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  int cookingTime = recipe.cookingTime;
                  Timer(Duration(minutes: cookingTime), () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Timer'),
                          content:
                              Text('Cooking time for ${recipe.title} is up!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                child: Text('Start Timer (${recipe.cookingTime} minutes)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final List<Recipe> _recipes = [];
  final List<Ingredient> _ingredients = [];
  final List<Tag> _tags = [];
  final List<Category> _categories = [];
  final List<Ingredient> _selectedIngredients = [];
  final List<Tag> _selectedTags = [];
  Category? _selectedCategory;
  String _title = '';
  String _image = '';
  String _instructions = '';
  int _cookingTime = 0;
  late TextEditingController _titleController;
  late TextEditingController _imageController;
  late TextEditingController _instructionsController;
  late TextEditingController _cookingTimeController;

  var uuid = const Uuid();

  Future<void> _loadIngredients() async {
    print('Loading ingredients');
    String jsonString =
        await rootBundle.loadString('assets/data/ingredients.json');
    List<dynamic> json = jsonDecode(jsonString);
    for (var item in json) {
      try {
        final id = item['id'];
        final title = item['title'];

        Ingredient ingredient = Ingredient(id, title);
        _ingredients.add(ingredient);
      } catch (e) {
        print(e);
      }
    }

    setState(() {});

    print('Ingredients loaded');
  }

  Future<void> _loadTags() async {
    print('Loading tags');
    String jsonString = await rootBundle.loadString('assets/data/tags.json');
    List<dynamic> json = jsonDecode(jsonString);
    for (var item in json) {
      try {
        final id = item['id'];
        final title = item['title'];
        Tag tag = Tag(id, title);
        _tags.add(tag);
      } catch (e) {
        print(e);
      }
    }

    setState(() {});

    print('Tags loaded');
  }

  Future<void> _loadCategories() async {
    print('Loading categories');
    String jsonString =
        await rootBundle.loadString('assets/data/categories.json');
    List<dynamic> json = jsonDecode(jsonString);
    for (var item in json) {
      try {
        final id = item['id'];
        final title = item['title'];
        Category category = Category(id, title);
        _categories.add(category);
      } catch (e) {
        print(e);
      }
    }

    setState(() {});

    print('Categories loaded');
  }

  @override
  void initState() {
    super.initState();
    _loadIngredients();
    _loadTags();
    _loadCategories();
    _titleController = TextEditingController(text: _title);
    _imageController = TextEditingController(text: _image);
    _instructionsController = TextEditingController(text: _instructions);
    _cookingTimeController =
        TextEditingController(text: _cookingTime.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageController.dispose();
    _instructionsController.dispose();
    _cookingTimeController.dispose();
    super.dispose();
  }

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/recipes.json');
  }

  void _addRecipe() async {
    try {
      var id = const Uuid().v4();

      final newRecipe = Recipe(
          id,
          _title,
          _image,
          _instructions,
          _selectedIngredients,
          _selectedTags,
          _selectedCategory!,
          _cookingTime);

      _recipes.add(newRecipe);

      try {
        final file = await _getLocalFile();
        List<Recipe> currentRecipes = [];
        if (file.existsSync()) {
          String jsonString = await file.readAsString();
          List<dynamic> json = jsonDecode(jsonString);
          currentRecipes = json.map((e) => Recipe.fromJson(e)).toList();
        }
        currentRecipes.add(newRecipe);
        await file.writeAsString(
            jsonEncode(currentRecipes.map((e) => e.toJson()).toList()));
      } catch (e) {
        print(e);
        print('Failed to write to json file');
      }

      setState(() {
        _titleController.clear();
        _imageController.clear();
        _instructionsController.clear();
        _cookingTimeController.clear();
        _title = '';
        _image = '';
        _instructions = '';
        _cookingTime = 0;
        _selectedCategory = null;
        _selectedIngredients.clear();
        _selectedTags.clear();
      });

      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Add Recipe'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'New recipe Title'),
                  onChanged: (text) {
                    setState(() {
                      _title = text;
                    });
                  },
                  controller: _titleController,
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'New recipe image'),
                  onChanged: (text) {
                    setState(() {
                      _image = text;
                    });
                  },
                  controller: _imageController,
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'New recipe instructions'),
                  onChanged: (text) {
                    setState(() {
                      _instructions = text;
                    });
                  },
                  controller: _instructionsController,
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Cooking Time (minutes)'),
                  onChanged: (text) {
                    setState(() {
                      _cookingTime = int.tryParse(text) ?? 0;
                    });
                  },
                  controller: _cookingTimeController,
                ),
                DropdownButton<Category>(
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.title),
                    );
                  }).toList(),
                  onChanged: (Category? value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tags',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Column(
                  children: _tags.map((tag) {
                    return Row(
                      children: [
                        Checkbox(
                            value: _selectedTags.contains(tag),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedTags.add(tag);
                                } else {
                                  _selectedTags.remove(tag);
                                }
                              });
                            }),
                        Text(tag.title),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Column(
                  children: _ingredients.map((ingredient) {
                    return Row(
                      children: [
                        Checkbox(
                            value: _selectedIngredients.contains(ingredient),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedIngredients.add(ingredient);
                                } else {
                                  _selectedIngredients.remove(ingredient);
                                }
                              });
                            }),
                        Text(ingredient.title),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _addRecipe();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ));
  }
}
