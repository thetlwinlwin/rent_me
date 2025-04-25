import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_me/core/constants/app_constants.dart';
import 'package:rent_me/features/profile/presentation/providers/profile_provider.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _selectedImg;

  @override
  void dispose() {
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImg = File(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProfileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: state.when(
        skipLoadingOnRefresh: true,
        loading:
            () => const Center(child: CircularProgressIndicator.adaptive()),
        error:
            (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Error loading leases: $error')],
                ),
              ),
            ),
        data: (profile) {
          _bioController.text = profile.profile.bio ?? 'N/A';
          _phoneController.text = profile.profile.phoneNumber ?? 'N/A';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _bioController,
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                  ),
                  onPressed: () async {
                    _pickImage();
                  },
                  child: const Text("Pick An Image"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    ref
                        .read(userProfileProvider.notifier)
                        .updateProfile(
                          phoneNum: _phoneController.text,
                          bio: _bioController.text,
                          imageFile: _selectedImg,
                        );
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
