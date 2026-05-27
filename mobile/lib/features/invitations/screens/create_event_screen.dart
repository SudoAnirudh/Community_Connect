import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../shared/widgets/primary_button.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Invitation', style: theme.textTheme.displayMedium),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.x),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Event Title',
                hintText: 'e.g. Ameen\'s Wedding',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      hintText: 'DD/MM/YYYY',
                      prefixIcon: Icon(PhosphorIconsRegular.calendar),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      hintText: '10:00 AM',
                      prefixIcon: Icon(PhosphorIconsRegular.clock),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Venue',
                prefixIcon: Icon(PhosphorIconsRegular.mapPin),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Continue to Guest List',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  context.push('/select-guests');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
