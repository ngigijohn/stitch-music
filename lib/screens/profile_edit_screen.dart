import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/profile_preferences_service.dart';
import '../theme/app_theme.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final ProfilePreferencesService _profile = ProfilePreferencesService.instance;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _profile.init();
    _nameController = TextEditingController(text: _profile.displayName);
    _emailController = TextEditingController(text: _profile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.epilogue(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile details',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'This first-pass screen lets users review and update visible identity fields locally.',
              style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Display name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () async {
                await _profile.saveProfile(
                  displayName: _nameController.text,
                  email: _emailController.text,
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile changes saved.')),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}