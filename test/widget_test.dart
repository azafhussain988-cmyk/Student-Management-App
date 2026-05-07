import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_task_app/main.dart';

void main() {
  testWidgets('loads saved tasks from local storage', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'tasks': ['{"title":"Saved homework","isCompleted":false}'],
    });

    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Saved homework'), findsOneWidget);
  });

  testWidgets('saves newly added tasks to local storage',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Finish assignment');
    await tester.tap(find.text('Submit Task'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getStringList('tasks'),
      contains('{"title":"Finish assignment","isCompleted":false}'),
    );
  });
}
