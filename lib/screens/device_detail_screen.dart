import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:hex_ble_scan/constants/app_constants.dart';
import 'package:hex_ble_scan/model/rssi_data_point.dart';
import 'package:hex_ble_scan/custom/rssi/rssi_chart.dart';
import 'package:hex_ble_scan/theme/text_styles.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceDetailScreen extends StatefulWidget {
  final String deviceId;
  final String deviceName;

  const DeviceDetailScreen({
    super.key,
    required this.deviceId,
    required this.deviceName,
  });

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  final _ble = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? _scanSubscription;

  List<RssiDataPoint> _rssiData = [];
  Timer? _disconnectTimer;

  // null = still checking, true = connected, false = disconnected
  bool? _deviceConnected;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    final granted = await _requestPermissions();
    if (!granted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please grant Bluetooth and Location permissions')),
      );
      if (mounted) Navigator.of(context).pop();
      return;
    }

    _scanSubscription = _ble.scanForDevices(withServices: []).listen((device) {
      if (device.id == widget.deviceId) {
        final now = DateTime.now();

        if (_deviceConnected != true) {
          if (mounted) {
            setState(() {
              _deviceConnected = true;
            });
          }
        }

        if (mounted) {
          setState(() {
            _rssiData.add(RssiDataPoint(time: now, rssi: device.rssi));
            _rssiData = _rssiData
                .where(
                  (point) =>
                      now.difference(point.time).inSeconds <=
                      AppConstants.chartInterval + 5,
                ) // 5 padding on our interval to make graph a bit less "jumpy"
                .toList();
          });
        }

        _resetDisconnectTimer();
      }
    }, onError: (error) {
      debugPrint('Scan error: $error');
    });

    // Check if connection has timed out/terminated
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _deviceConnected == null) {
        setState(() {
          _deviceConnected = false;
        });
      }
    });
  }

  void _resetDisconnectTimer() {
    _disconnectTimer?.cancel();
    _disconnectTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _deviceConnected = false;
          _rssiData.clear();
        });
      }
    });
  }

  Future<bool> _requestPermissions() async {
    final statuses = await [
      Permission.bluetoothScan,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _disconnectTimer?.cancel();
    _ble.deinitialize();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (_deviceConnected == null) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_deviceConnected == true) {
      bodyContent = RssiChart(data: _rssiData);
    } else {
      bodyContent = const Center(
        child: Text(
          'Device not connected',
          style: TextStyles.white16Bold,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.deviceName.isEmpty ? 'Unknown Device' : widget.deviceName),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Live RSSI',
              style: TextStyles.white18Medium,
            ),
          ),
          Expanded(child: bodyContent),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Tracking device ID:\n${widget.deviceId}',
              textAlign: TextAlign.center,
              style: TextStyles.grey14Medium,
            ),
          ),
        ],
      ),
    );
  }
}
