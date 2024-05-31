import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_flutter_project/main.dart';

void main() {
  testWidgets('Recipe list displays correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the main screen title is displayed.
    expect(find.text('Recipes'), findsOneWidget);

    // Load the recipes from the JSON file (you can mock this for testing).
    await tester.pumpAndSettle(); // Wait for async operations to complete.

    // Check that at least one recipe is displayed in the list.
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ElevatedButton),
        findsWidgets); // Assuming each recipe has a 'View' button.
  });

  testWidgets('Add Recipe button navigates to AddRecipeScreen',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the 'Add Recipe' button.
    final addRecipeButtonFinder =
        find.widgetWithText(ElevatedButton, 'Add Recipe');
    expect(addRecipeButtonFinder, findsOneWidget);

    await tester.tap(addRecipeButtonFinder);
    await tester.pumpAndSettle(); // Wait for navigation animation to complete.

    // Verify that we have navigated to the AddRecipeScreen.
    expect(find.text('Add Recipe'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets); // Check for input fields.
  });

  testWidgets('Search functionality filters recipe list',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Load the recipes from the JSON file (you can mock this for testing).
    await tester.pumpAndSettle(); // Wait for async operations to complete.

    // Enter text in the search field.
    await tester.enterText(find.byType(TextField), 'Pancakes');
    await tester.pump(); // Rebuild the widget with the new search query.

    // Verify that the filtered list shows the expected result.
    expect(find.text('Pancakes'), findsOneWidget);
  });

  testWidgets('Timer button sets a timer and shows alert',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Load the recipes from the JSON file (you can mock this for testing).
    await tester.pumpAndSettle(); // Wait for async operations to complete.

    // Tap the 'View' button for a recipe to navigate to its details screen.
    final viewButtonFinder = find.widgetWithText(ElevatedButton, 'View').first;
    await tester.tap(viewButtonFinder);
    await tester.pumpAndSettle(); // Wait for navigation animation to complete.

    // Tap the 'Start Timer' button.
    final timerButtonFinder =
        find.widgetWithText(ElevatedButton, 'Start Timer');
    await tester.tap(timerButtonFinder);

    // Fast forward time to simulate the timer completion.
    await tester.pump(
        Duration(minutes: 15)); // Assuming the timer is set for 15 minutes.

    // Verify that an alert dialog is shown.
    expect(find.text('Timer'), findsOneWidget);
    expect(find.text('Cooking time for Pancakes is up!'), findsOneWidget);
  });
}
