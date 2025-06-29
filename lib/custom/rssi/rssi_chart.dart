import 'package:flutter/material.dart';
import 'package:hex_ble_scan/constants/app_constants.dart';
import 'package:hex_ble_scan/model/rssi_data_point.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RssiChart extends StatelessWidget {
  final List<RssiDataPoint> data;

  const RssiChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      tooltipBehavior:
          TooltipBehavior(enable: true, format: 'point.x : point.y dBm'),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.seconds,
        visibleMinimum: data.isNotEmpty
            ? data.last.time.subtract(
                const Duration(
                  seconds: AppConstants.chartInterval,
                ),
              )
            : null,
        visibleMaximum: data.isNotEmpty ? data.last.time : null,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        minimum: -100,
        maximum: 0,
        interval: 20,
        title: AxisTitle(text: 'RSSI (dBm)'),
      ),
      series: <ChartSeries>[
        SplineAreaSeries<RssiDataPoint, DateTime>(
          dataSource: data,
          xValueMapper: (d, _) => d.time,
          yValueMapper: (d, _) => d.rssi,
          animationDuration: 800,
          gradient: LinearGradient(
            colors: [
              Colors.green.withOpacity(0.6),
              Colors.green.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderColor: Colors.white,
          borderWidth: 2,
          markerSettings: const MarkerSettings(
            isVisible: true,
            width: 6,
            height: 6,
            shape: DataMarkerType.circle,
          ),
        ),
      ],
    );
  }
}
