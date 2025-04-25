import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_me/core/constants/constants.dart';
import 'package:rent_me/features/properties/presentation/widgets/property_item_card.dart';
import 'package:rent_me/features/properties/data/models/property.dart';
import 'package:rent_me/features/properties/data/models/property_filter.dart';
import 'package:rent_me/features/properties/presentation/providers/property_provider.dart';
import 'package:rent_me/shared/providers/is_landlord.dart';

class PropertyListScreen extends ConsumerStatefulWidget {
  const PropertyListScreen({super.key});

  @override
  ConsumerState<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends ConsumerState<PropertyListScreen> {
  final _bedroomsController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _propertyTypeController = TextEditingController();

  String? _selectedTownship;
  bool _ascending = true;
  bool _isFurnished = false;
  PropertyFilter? _currentFilter;

  void _applyFilter() {
    setState(() {
      _currentFilter = PropertyFilter(
        township: _selectedTownship,
        bedrooms: int.tryParse(_bedroomsController.text),
        propertyType: _propertyTypeController.text,
        minPrice: _minPriceController.text,
        maxPrice: _maxPriceController.text,
        acsendingPrice: _ascending,
        isFurnished: _isFurnished,
      );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bedroomsController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _propertyTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final propertyAsync = ref.watch(propertiesProvider(_currentFilter));
    final isLandLord = ref.watch(isLandLordProvider);
    final townships = ref.watch(townshipProvider);

    return townships.when(
      skipLoadingOnRefresh: true,
      data:
          (townships) => Scaffold(
            appBar: AppBar(
              title: const Text('Properties'),
              actions: [
                if (isLandLord)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => context.go(AppConstants.propertyAddRoute),
                  ),
                _currentFilter == null
                    ? IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => _showFilterDialog(context, townships),
                    )
                    : IconButton(
                      icon: const Icon(
                        Icons.filter_list_off,
                        color: Colors.red,
                      ),
                      onPressed:
                          () => setState(() {
                            _bedroomsController.clear();
                            _minPriceController.clear();
                            _maxPriceController.clear();
                            _selectedTownship = null;
                            _propertyTypeController.clear();
                            _currentFilter = null;
                          }),
                    ),
              ],
            ),
            body: propertyAsync.when(
              skipLoadingOnRefresh: true,
              loading:
                  () =>
                      const Center(child: CircularProgressIndicator.adaptive()),
              error:
                  (error, stackTrace) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(
                        AppConstants.defaultPadding,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Error loading leases: $error')],
                      ),
                    ),
                  ),
              data: (properties) {
                if (properties.isEmpty) {
                  return const Center(child: Text('No properties found.'));
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppConstants.defaultPadding),
                    itemCount: properties.length,
                    itemBuilder: (context, leaseIndex) {
                      final property = properties[leaseIndex];
                      return PropertyItemCard(
                        property: property,
                        onTap: () {
                          context.go(
                            AppConstants.propertyDetailsRoute.replaceAll(
                              '{id}',
                              property.id.toString(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
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
    );
  }

  void _showFilterDialog(BuildContext context, List<Township> tsp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Autocomplete<String>(
                  initialValue: TextEditingValue(text: _selectedTownship ?? ''),
                  fieldViewBuilder:
                      (
                        context,
                        textEditingController,
                        focusNode,
                        onFieldSubmitted,
                      ) => TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        onEditingComplete: onFieldSubmitted,
                        decoration: const InputDecoration(
                          labelText: 'Township',
                        ),

                        onTapOutside:
                            (_) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                      ),
                  onSelected:
                      (option) => _selectedTownship = option.split(',').first,
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    final items = tsp.where(
                      (element) => element.name.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    );
                    return items.map((e) => e.toString());
                  },
                ),
                TextField(
                  controller: _bedroomsController,
                  decoration: const InputDecoration(labelText: 'Bedrooms'),
                  keyboardType: TextInputType.number,
                  onTapOutside:
                      (_) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
                TextField(
                  controller: _minPriceController,
                  decoration: const InputDecoration(labelText: 'Min Price'),
                  keyboardType: TextInputType.number,
                  onTapOutside:
                      (_) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
                TextField(
                  controller: _maxPriceController,
                  decoration: const InputDecoration(labelText: 'Max Price'),
                  keyboardType: TextInputType.number,
                  onTapOutside:
                      (_) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
                TextField(
                  controller: _propertyTypeController,
                  decoration: const InputDecoration(labelText: 'Property Type'),
                  onTapOutside:
                      (_) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Ascending Price"),
                    Switch(
                      value: _ascending,
                      onChanged: (val) {
                        setState(() {
                          _ascending = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Is Furnished"),
                    Switch(
                      value: _isFurnished,
                      onChanged: (val) {
                        setState(() {
                          _isFurnished = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _applyFilter();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply Filter'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
