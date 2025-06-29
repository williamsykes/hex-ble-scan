import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:hex_ble_scan/constants/app_constants.dart';
import 'package:hex_ble_scan/custom/tile/device_tile.dart';
import 'package:hex_ble_scan/screens/device_detail_screen.dart';
import 'package:hex_ble_scan/services/company_ids.dart';
import 'package:hex_ble_scan/theme/text_styles.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  final List<DiscoveredDevice> _devices = [];
  StreamSubscription<DiscoveredDevice>? _scanStream;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<bool> _requestPermissions() async {
    final statuses = await [
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> _startScan() async {
    if (!mounted) return;
    final granted = await _requestPermissions();
    if (!mounted) return;

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please grant Bluetooth and Location permissions')),
      );
      return;
    }

    setState(() {
      _devices.clear();
      _scanning = true;
    });

    _scanStream?.cancel();

    _scanStream = _ble.scanForDevices(withServices: []).listen(
      (device) {
        if (!_devices.any((d) => d.id == device.id)) {
          if (!mounted) return;
          setState(() => _devices.add(device));
        }
      },
      onError: (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Scan error: $error')));
        setState(() => _scanning = false);
      },
    );

    // Automatically stop the scan after scan timeout constant
    Future.delayed(
        const Duration(
          seconds: AppConstants.scanTimeout,
        ), () {
      if (_scanning) {
        _stopScan();
      }
    });
  }

  void _stopScan() {
    _scanStream?.cancel();
    _scanStream = null;
    if (!mounted) return;
    setState(() {
      _scanning = false;
    });
  }

  @override
  void dispose() {
    _stopScan();
    super.dispose();
  }

  double _normalizedRssi(int rssi) => ((rssi + 100) / 70).clamp(0.0, 1.0);

  String _parseManufacturerData(List<int> data) {
    if (data.length >= 2) {
      int companyId = data[1] << 8 | data[0];
      String? companyName = companyIdMap[companyId];

      String payload = data
          .skip(2)
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join(' ');

      if (companyName != null) {
        return '$companyName\n(Company ID: 0x${companyId.toRadixString(16)})\nPayload: $payload';
      } else {
        return 'Unknown Company (0x${companyId.toRadixString(16)})\nPayload: $payload';
      }
    } else {
      return data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Scanner'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/about'),
            child: const Text(
              'About Me',
              style: TextStyles.white,
            ),
          ),
          TextButton.icon(
            onPressed: _scanning ? _stopScan : _startScan,
            icon: _scanning
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const SizedBox.shrink(),
            label: Text(
              _scanning ? 'Stop' : 'Scan',
              style: TextStyles.white,
            ),
          ),
        ],
      ),
      body: _devices.isEmpty
          ? Center(child: Text(_scanning ? 'Scanning...' : 'No devices found.'))
          : RefreshIndicator(
              onRefresh: _startScan,
              child: ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  final device = _devices[index];
                  return DeviceTile(
                    device: device,
                    parseManufacturerData: _parseManufacturerData,
                    normalizedRssi: _normalizedRssi,
                    onConnectPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DeviceDetailScreen(
                            deviceId: device.id,
                            deviceName: device.name,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
