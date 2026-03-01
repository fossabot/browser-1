// SPDX-License-Identifier: MIT
//
// Copyright 2026 bniladridas. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:browser/ux/password_vault_screen.dart';

void main() {
  group('PasswordVaultScreen', () {
    testWidgets('should display title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordVaultScreen(),
        ),
      );

      expect(find.text('Password Vault'), findsOneWidget);
    });

    testWidgets('should display search field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordVaultScreen(),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('should show loading indicator initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PasswordVaultScreen(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
