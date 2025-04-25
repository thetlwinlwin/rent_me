import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_me/core/constants/app_constants.dart';
import 'package:rent_me/features/properties/data/models/property.dart';
import 'package:rent_me/features/properties/presentation/providers/property_provider.dart';

class PropertyAddScreen extends ConsumerStatefulWidget {
  const PropertyAddScreen({super.key});

  @override
  ConsumerState<PropertyAddScreen> createState() => _PropertyAddScreenState();
}

class _PropertyAddScreenState extends ConsumerState<PropertyAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final priceController = TextEditingController();
  final depositController = TextEditingController();
  final bedroomsController = TextEditingController();
  final bathroomsController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  int? _selectedTownshipId;
  int selectedPropertyTypeId = 1;

  List<int> selectedAmenityIds = [];
  List<File?> selectedImgs = [];
  bool isSubmitting = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    depositController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    priceController.dispose();
    bedroomsController.dispose();
    bathroomsController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });

      try {
        final createProperty = CreateProperty(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          addressLine1: addressLine1Controller.text.trim(),
          addressLine2: addressLine2Controller.text.trim(),
          pricePerMonth: priceController.text.trim(),
          depositAmount: depositController.text.trim(),
          amenityIds: selectedAmenityIds,
          propertyTypeid: selectedPropertyTypeId,
          townshipId: _selectedTownshipId!,
          bedrooms: int.parse(bedroomsController.text.trim()),
          bathrooms: double.parse(bathroomsController.text.trim()),
          latitude: double.parse(latitudeController.text.trim()),
          longitude: double.parse(longitudeController.text.trim()),
        );

        final details = CreatePropertyAttributes(
          property: createProperty,
          imgs: selectedImgs,
        );

        final data = await ref.read(createPropertyProvider(details).future);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New Property is created.'),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              ref.invalidate(propertiesProvider);
              context.go(
                AppConstants.propertyDetailsRoute.replaceAll(
                  '{id}',
                  data.id.toString(),
                ),
              );
            }
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isSubmitting = false;
          });
        }
      }
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(limit: 5);
    if (images.isNotEmpty) {
      for (var img in images) {
        selectedImgs.add(File(img.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyDetails = ref.watch(propertyAttributesProvider);
    return propertyDetails.when(
      skipLoadingOnRefresh: true,
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
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      data: (details) {
        return Scaffold(
          appBar: AppBar(title: const Text("Add Property")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) => value!.isEmpty ? 'Enter title' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator:
                        (value) => value!.isEmpty ? 'Enter description' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: addressLine1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Address Line 1',
                    ),
                    validator:
                        (value) => value!.isEmpty ? 'Enter address' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: addressLine2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Address Line 2',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price per month',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Enter price' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: depositController,
                    decoration: const InputDecoration(
                      labelText: 'Deposit Amount',
                    ),
                    keyboardType: TextInputType.number,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Enter deposit amount' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: bedroomsController,
                    decoration: const InputDecoration(labelText: 'Bedrooms'),
                    keyboardType: TextInputType.number,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Enter number of bedrooms' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: bathroomsController,
                    decoration: const InputDecoration(labelText: 'Bathrooms'),
                    keyboardType: TextInputType.number,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Enter number of bathrooms' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: latitudeController,
                    decoration: const InputDecoration(labelText: 'Latitude'),
                    validator:
                        (value) => value!.isEmpty ? 'Enter latitude' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: longitudeController,
                    decoration: const InputDecoration(labelText: 'Longitude'),
                    validator:
                        (value) => value!.isEmpty ? 'Enter longitude' : null,
                  ),
                  const SizedBox(height: 15),
                  Autocomplete<Township>(
                    initialValue: TextEditingValue(
                      text:
                          _selectedTownshipId != null
                              ? details.townships
                                  .firstWhere(
                                    (element) =>
                                        element.townshipId ==
                                        _selectedTownshipId,
                                  )
                                  .name
                              : '',
                    ),
                    fieldViewBuilder:
                        (
                          context,
                          textEditingController,
                          focusNode,
                          onFieldSubmitted,
                        ) => TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Choose Township'
                                      : null,
                          onEditingComplete: onFieldSubmitted,
                          decoration: const InputDecoration(
                            labelText: 'Township',
                          ),
                          onTapOutside:
                              (_) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                        ),
                    onSelected: (option) {
                      _selectedTownshipId = option.townshipId;
                    },
                    optionsBuilder: (textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<Township>.empty();
                      }
                      final items = details.townships.where(
                        (element) => element.name.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                      );
                      return items;
                    },
                  ),
                  const SizedBox(height: 15),
                  DropdownButton<int>(
                    hint: Text('Property Types'),
                    value: selectedPropertyTypeId,
                    items:
                        details.propertyTypes
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.propertyId,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) =>
                            setState(() => selectedPropertyTypeId = value!),
                  ),
                  const SizedBox(height: 20),
                  Text('Amenities'),
                  const SizedBox(height: 15),
                  Wrap(
                    runSpacing: 5,
                    spacing: 5,
                    children:
                        details.amenities.map((e) {
                          return FilterChip.elevated(
                            label: Text(e.name),
                            selected: selectedAmenityIds.contains(e.amenityId),
                            onSelected: (value) {
                              setState(() {
                                if (!selectedAmenityIds.contains(e.amenityId)) {
                                  selectedAmenityIds.add(e.amenityId);
                                } else {
                                  selectedAmenityIds.remove(e.amenityId);
                                }
                              });
                            },
                          );
                        }).toList(),
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
                      _pickImages();
                    },
                    child: const Text("Add Images"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isSubmitting ? null : _submit,
                    child:
                        isSubmitting
                            ? const CircularProgressIndicator()
                            : const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
