import 'package:flutter/material.dart';

import 'package:moodiary/utils/constants/sizes.dart';

class TBottomDialog extends StatelessWidget {
  const TBottomDialog({
    super.key,
    required this.title,
    required this.controller,
    required this.onConfirm,
    required this.formKey,
    this.buttonText = "Save Changes",
    this.hintText = "Enter a name",
    this.maxLength = 14,
  });
  final String title;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final VoidCallback onConfirm;
  final String buttonText;
  final String hintText;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: controller,
                maxLength: maxLength,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? "Please enter a name"
                    : null,
                decoration: InputDecoration(
                  labelText: hintText,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
