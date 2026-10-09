import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dayaq/app/app.dart';

void main() {
  testWidgets('Home CTA opens campaigns and tabs return home', (tester) async {
    await tester.pumpWidget(const DayaqApp());
    expect(find.text('Birlikdə dayaq olaq'), findsOneWidget);
    await tester.tap(find.text('Kampaniyalara bax'));
    await tester.pumpAndSettle();
    expect(
      find.text('Xeyriyyə kampaniyaları burada göstəriləcək.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(
      find.text('Hesab məlumatlarınız burada göstəriləcək.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Ana səhifə'));
    await tester.pumpAndSettle();
    expect(find.text('Birlikdə dayaq olaq'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home accommodates enlarged text on narrow screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const DayaqApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
