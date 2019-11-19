import 'package:flutter/widgets.dart';
import 'package:flutter_coding_challenge/main_test.dart';
import 'package:flutter_coding_challenge/src/suburban_spoon_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await registerDependencies();
  });
  group(
    'Suburban Spoon Widget Tests',
    () {
      testWidgets(
        'Renders Slot Machine',
        (WidgetTester tester) async {
          // Build our app and trigger a frame.
          await tester.pumpWidget(SuburbanSpoonApp());
          await tester.pump();
          expect(find.byKey(Key('noLocation')), findsOneWidget);
          await tester.pump();
          await tester.tap(find.byKey(Key('locationButton')));
          await tester.pump();
          await tester.pump();
          expect(find.byKey(Key('slotMachine')), findsOneWidget);
        },
      );
    },
  );
}
