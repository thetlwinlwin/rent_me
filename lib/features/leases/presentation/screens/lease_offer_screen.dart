import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rent_me/core/constants/app_constants.dart';
import 'package:rent_me/features/leases/data/models/lease.dart';
import 'package:rent_me/features/leases/presentation/providers/lease_provider.dart';

class LeaseOfferScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const LeaseOfferScreen({super.key, required this.propertyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LeaseOfferScreenState();
}

class _LeaseOfferScreenState extends ConsumerState<LeaseOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthlyRentController = TextEditingController();
  final _depositAmountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _startDateError;
  String? _endDateError;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    bool hasError = false;

    setState(() {
      _startDateError = null;
      _endDateError = null;
    });

    if (_startDate == null) {
      setState(() => _startDateError = 'Start date is required');
      hasError = true;
    }
    if (_endDate == null) {
      setState(() => _endDateError = 'End date is required');
      hasError = true;
    } else if (_startDate != null && _endDate!.isBefore(_startDate!)) {
      setState(() => _endDateError = 'End date must be after start date');
      hasError = true;
    }

    if (!isValid || hasError) return;

    try {
      final createLease = CreateLease(
        propertyId: int.parse(widget.propertyId),
        monthlyRentAtSigning: double.parse(_monthlyRentController.text.trim()),
        depositPaidAmount: double.parse(_depositAmountController.text.trim()),
        startDate: _startDate!,
        endDate: _endDate!,
      );
      final result = await ref.read(leaseOfferProvider(createLease).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully Offer'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            context.go(
              AppConstants.leaseDetailRoute.replaceAll(
                '{id}',
                result.id.toString(),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offer")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _monthlyRentController,
                decoration: const InputDecoration(
                  labelText: "Monthly Rent Fee",
                ),
                keyboardType: TextInputType.number,
                validator:
                    (val) => val == null || val.isEmpty ? 'Enter rent' : null,
              ),
              TextFormField(
                controller: _depositAmountController,
                decoration: const InputDecoration(labelText: "Deposit Amount"),
                keyboardType: TextInputType.number,
                validator:
                    (val) =>
                        val == null || val.isEmpty ? 'Enter deposit' : null,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(
                context,
                label: 'Start Date',
                selectedDate: _startDate,
                onPick: (date) => setState(() => _startDate = date),
                errorText: _startDateError,
              ),
              _buildDatePicker(
                context,
                label: 'End Date',
                selectedDate: _endDate,
                onPick: (date) => setState(() => _endDate = date),
                errorText: _endDateError,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: const Text("Offer")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required String label,
    required DateTime? selectedDate,
    required void Function(DateTime date) onPick,
    required String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label),
          subtitle: Text(
            selectedDate != null
                ? DateFormat.yMMMd().format(selectedDate)
                : 'No date selected',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                onPick(picked);
                setState(() {
                  if (label == 'Start Date') _startDateError = null;
                  if (label == 'End Date') _endDateError = null;
                });
              }
            },
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
