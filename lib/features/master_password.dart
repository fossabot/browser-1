// SPDX-License-Identifier: MIT
//
// Copyright 2026 bniladridas. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import '../constants.dart';

class MasterPasswordService {
  final LocalAuthentication _localAuth;

  MasterPasswordService({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> canUseBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      print('canCheckBiometrics: $canCheck, isDeviceSupported: $isSupported');
      return canCheck && isSupported;
    } catch (e) {
      print('Error checking biometrics: $e');
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      print('Attempting biometric authentication...');
      final result = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your passwords',
      );
      print('Biometric authentication result: $result');
      return result;
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }

  Future<bool> hasMasterPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final hash = prefs.getString(masterPasswordHashKey);
    return hash != null;
  }

  Future<void> setMasterPassword(String password) async {
    final hash = _hashPassword(password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(masterPasswordHashKey, hash);
  }

  Future<bool> verifyMasterPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedHash = prefs.getString(masterPasswordHashKey);
    if (storedHash == null) return false;
    final inputHash = _hashPassword(password);
    return storedHash == inputHash;
  }

  Future<void> removeMasterPassword() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(masterPasswordHashKey);
  }
}
