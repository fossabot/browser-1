// SPDX-License-Identifier: MIT
//
// Copyright 2026 bniladridas. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import '../features/master_password.dart';

class MasterPasswordDialog extends StatefulWidget {
  final bool isSetup;

  const MasterPasswordDialog({super.key, this.isSetup = false});

  @override
  State<MasterPasswordDialog> createState() => _MasterPasswordDialogState();
}

class _MasterPasswordDialogState extends State<MasterPasswordDialog> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _errorText;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _passwordController.text;

    if (password.isEmpty) {
      setState(() => _errorText = 'Password cannot be empty');
      return;
    }

    if (widget.isSetup) {
      if (password != _confirmController.text) {
        setState(() => _errorText = 'Passwords do not match');
        return;
      }
      if (password.length < 4) {
        setState(() => _errorText = 'Password must be at least 4 characters');
        return;
      }
      final service = MasterPasswordService();
      await service.setMasterPassword(password);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } else {
      final service = MasterPasswordService();
      final isValid = await service.verifyMasterPassword(password);
      if (!mounted) return;
      if (isValid) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _errorText = 'Incorrect password');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isSetup ? 'Set Master Password' : 'Enter Master Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isSetup)
            const Text('Protect your passwords with a master password'),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: _errorText,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            onSubmitted: (_) => widget.isSetup ? null : _submit(),
          ),
          if (widget.isSetup) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _confirmController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          child: Text(widget.isSetup ? 'Set Password' : 'Unlock'),
        ),
      ],
    );
  }
}
