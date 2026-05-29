import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const MapPickerScreen({super.key, this.initialLocation});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _selectedLocation;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          if (_selectedLocation != null)
            TextButton(
              onPressed: () {
                context.pop(_selectedLocation);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialLocation ?? const LatLng(9.9312, 76.2673), // Default to Kochi, Kerala for example
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: (location) {
              setState(() {
                _selectedLocation = location;
              });
            },
            markers: _selectedLocation == null 
                ? {} 
                : {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLocation!,
                    ),
                  },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search venue (Mock)',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                onSubmitted: (value) {
                  // Mock jump to coordinates based on search
                  if (value.isNotEmpty) {
                    _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        const CameraPosition(
                          target: LatLng(9.9312, 76.2673),
                          zoom: 15,
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Map Jump (Mock Search)')),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
