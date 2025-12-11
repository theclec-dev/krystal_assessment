import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krystal_assessment/core/components/empty_state_widget.dart';
import 'package:krystal_assessment/core/components/error_widget.dart';
import 'package:krystal_assessment/core/components/loading_widget.dart';
import 'package:krystal_assessment/core/components/search_field.dart';
import 'package:krystal_assessment/core/components/labeled_text_field.dart';

void main() {
  testWidgets('EmptyStateWidget shows message and optional action', (
    tester,
  ) async {
    var called = false;
    await tester.pumpWidget(
      MaterialApp(
        home: EmptyStateWidget(
          message: 'No items',
          actionText: 'Add',
          onAction: () {
            called = true;
          },
        ),
      ),
    );

    expect(find.text('No items'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
    await tester.tap(find.text('Add'));
    expect(called, isTrue);
  });

  testWidgets('ErrorDisplayWidget shows message and retry', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ErrorDisplayWidget(
          message: 'Oops',
          onRetry: () {
            retried = true;
          },
        ),
      ),
    );

    expect(find.text('Oops'), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    await tester.tap(find.byIcon(Icons.refresh));
    expect(retried, isTrue);
  });

  testWidgets('LoadingWidget shows progress and optional message', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: LoadingWidget(message: 'Loading...')),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);
  });

  testWidgets('SearchField displays text and calls callbacks', (tester) async {
    final controller = TextEditingController();
    String? changed;
    var cleared = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchField(
            controller: controller,
            hintText: 'Search',
            showClear: true,
            onClear: () {
              cleared = true;
            },
            onChanged: (v) {
              changed = v;
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'hello');
    expect(changed, 'hello');
    await tester.tap(find.byIcon(Icons.clear));
    expect(cleared, isTrue);
  });

  testWidgets('LabeledTextField shows label and supports input', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'init');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabeledTextField(controller: controller, labelText: 'Title'),
        ),
      ),
    );

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('init'), findsOneWidget);
  });
}
