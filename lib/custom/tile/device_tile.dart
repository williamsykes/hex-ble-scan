import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:hex_ble_scan/theme/text_styles.dart';

class DeviceTile extends StatelessWidget {
  final DiscoveredDevice device;
  final String Function(List<int>) parseManufacturerData;
  final double Function(int) normalizedRssi;
  final VoidCallback onConnectPressed;

  const DeviceTile({
    super.key,
    required this.device,
    required this.parseManufacturerData,
    required this.normalizedRssi,
    required this.onConnectPressed,
  });

  Widget _buildSignalIcon(int rssi) {
    final normalized = normalizedRssi(rssi);
    final color = normalized > 0.7
        ? Colors.green
        : normalized > 0.4
            ? Colors.orange
            : Colors.red;

    final bars = (normalized * 4).clamp(0, 4).round();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (i) {
        return Container(
          width: 4,
          height: (i + 1) * 6,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: i < bars ? color : Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyles.whiteBold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              softWrap: true,
              style: TextStyles.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSignalIcon(device.rssi),
          Text(
            '${device.rssi} dBm',
            style: TextStyles.white10Medium,
          ),
        ],
      ),
      title: Text(
        device.name.isEmpty ? '(unknown)' : device.name,
        style: TextStyles.whiteBold,
      ),
      subtitle: Text(device.id),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(70, 30)),
            onPressed: onConnectPressed,
            child: const Text('Connect'),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.expand_more),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('MAC Address', device.id),
              _infoRow('RSSI', '${device.rssi} dBm'),
              _infoRow('Local Name', device.name.isEmpty ? 'N/A' : device.name),
              const SizedBox(height: 8),
              _infoRow(
                'Advertising Packet',
                device.manufacturerData.isNotEmpty
                    ? device.manufacturerData
                        .map((e) => e.toRadixString(16).padLeft(2, '0'))
                        .join(' ')
                    : 'N/A',
              ),
              const SizedBox(height: 8),
              _infoRow(
                'Adv. service UUIDs',
                device.serviceUuids.isNotEmpty
                    ? device.serviceUuids.join(", ")
                    : 'N/A',
              ),
              const SizedBox(height: 8),
              _infoRow(
                'Manufacturer Specific Data',
                device.manufacturerData.isNotEmpty
                    ? parseManufacturerData(device.manufacturerData)
                    : 'N/A',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
