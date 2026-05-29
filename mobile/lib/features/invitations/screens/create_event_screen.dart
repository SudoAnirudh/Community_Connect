import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/event_model.dart';
import '../../../../core/providers/event_providers.dart';
import '../../../../core/providers/family_providers.dart';
import '../../../../shared/widgets/primary_button.dart';
import 'map_picker_screen.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _venueController = TextEditingController();
  final _descController = TextEditingController();

  File? _selectedImage;
  List<File> _attachments = [];
  LatLng? _selectedLocation;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _attachments.addAll(result.paths.where((path) => path != null).map((path) => File(path!)));
      });
    }
  }

  Future<void> _pickLocation() async {
    final location = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(initialLocation: _selectedLocation),
      ),
    );

    if (location != null) {
      setState(() {
        _selectedLocation = location;
        _venueController.text = "Location Selected (${location.latitude.toStringAsFixed(2)}, ${location.longitude.toStringAsFixed(2)})";
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = await ref.read(currentUserModelProvider.future);
      if (user == null) return;

      // TODO: In a real app, upload _selectedImage and _attachments to Firebase Storage here
      // and get their download URLs. For now, we will just use dummy strings or local paths.
      
      final event = EventModel(
        id: Uuid().v4(),
        title: _titleController.text,
        description: _descController.text,
        date: DateTime.tryParse(_dateController.text) ?? DateTime.now(), // Real app would use a DatePicker
        time: _timeController.text,
        venue: _venueController.text,
        latitude: _selectedLocation?.latitude,
        longitude: _selectedLocation?.longitude,
        host: user.name, // or family name
        imageUrl: _selectedImage?.path, // mock upload
        attachments: _attachments.map((e) => e.path).toList(), // mock upload
        createdBy: user.uid,
      );

      await ref.read(eventCreationProvider.notifier).createEvent(event);
      
      if (mounted) {
        context.push('/select-guests');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final creationState = ref.watch(eventCreationProvider);

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
            // Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  image: _selectedImage != null 
                    ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)
                    : null,
                ),
                child: _selectedImage == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(PhosphorIconsRegular.image, size: 40),
                          SizedBox(height: 8),
                          Text('Add Event Photo'),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _titleController,
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
                    controller: _dateController,
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      hintText: 'YYYY-MM-DD',
                      prefixIcon: Icon(PhosphorIconsRegular.calendar),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _timeController,
                    readOnly: true,
                    onTap: _selectTime,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      hintText: '10:00 AM',
                      prefixIcon: Icon(PhosphorIconsRegular.clock),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Venue and Map Picker
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _venueController,
                    decoration: const InputDecoration(
                      labelText: 'Venue',
                      prefixIcon: Icon(PhosphorIconsRegular.mapPin),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: _pickLocation,
                  icon: Icon(
                    PhosphorIconsRegular.mapTrifold, 
                    color: _selectedLocation != null ? theme.colorScheme.primary : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),

            // Attachments
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(PhosphorIconsRegular.filePdf),
              title: const Text('Add Attachments (Invites/PDFs)'),
              subtitle: Text('${_attachments.length} files selected'),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _pickFiles,
              ),
            ),
            
            if (_attachments.isNotEmpty)
              Wrap(
                spacing: 8,
                children: _attachments.map((file) => Chip(
                  label: Text(file.path.split('/').last, style: const TextStyle(fontSize: 12)),
                  onDeleted: () {
                    setState(() {
                      _attachments.remove(file);
                    });
                  },
                )).toList(),
              ),

            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Continue to Guest List',
              isLoading: creationState.isLoading,
              onPressed: _handleSave,
            ),
            
            if (creationState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  creationState.error.toString(),
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
