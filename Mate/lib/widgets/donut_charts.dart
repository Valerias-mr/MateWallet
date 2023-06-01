import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DataPerItem {
  final String name;
  final int percent;
  final charts.Color color;

  DataPerItem(this.name, this.percent, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class DonutPieChart extends StatelessWidget {
  final List<charts.Series<DataPerItem, String>> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {required this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.ArcRendererConfig(arcWidth: 35),
      defaultInteractions: true,
    );
  }
}
