import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineBannerWrapper extends StatefulWidget {
  final Widget child;

  const OfflineBannerWrapper({super.key, required this.child});

  @override
  State<OfflineBannerWrapper> createState() => _OfflineBannerWrapperState();
}

class _OfflineBannerWrapperState extends State<OfflineBannerWrapper> {
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // The connectivity_plus plugin returns a list of results in v7+
      final isOffline = results.every((result) => result == ConnectivityResult.none);
      if (mounted) {
        setState(() {
          _isOffline = isOffline;
        });
      }
    });
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    final isOffline = results.every((result) => result == ConnectivityResult.none);
    if (mounted) {
      setState(() {
        _isOffline = isOffline;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isOffline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Theme.of(context).colorScheme.error,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, color: Theme.of(context).colorScheme.onError, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'You are offline. Showing cached data.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
