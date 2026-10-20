import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joga_sports/app.dart';
import 'package:joga_sports/core/di/app_services.dart';

void main() {
  testWidgets('app opens on the welcome screen', (tester) async {
    await tester.pumpWidget(
      JogaApp(services: AppServices.fake(latency: Duration.zero)),
    );
    await tester.pumpAndSettle();

    expect(find.text('GET STARTED'), findsOneWidget);
  });

  testWidgets('works at phone size without the presenter frame',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      JogaApp(services: AppServices.fake(latency: Duration.zero)),
    );
    await tester.pumpAndSettle();

    expect(find.text('GET STARTED'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
