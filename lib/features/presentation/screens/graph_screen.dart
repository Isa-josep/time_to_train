import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso de Ejercicios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            title: AxisTitle(text: 'Ejercicio'), // Eje X con nombres de ejercicios
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Peso (kg)'),
            minimum: 0,  // Ajuste mínimo del eje Y para un rango adecuado
          ),
          title: ChartTitle(text: 'Progreso de Peso por Ejercicio'),
          legend: Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries>[
            // Gráfico de barras para mostrar el peso mínimo
            BarSeries<PRData, String>(
              name: 'Peso Mínimo',
              dataSource: prData,
              xValueMapper: (PRData data, _) => data.exercise, // Nombre del ejercicio en el eje X
              yValueMapper: (PRData data, _) => data.minWeight, // Peso mínimo en el eje Y
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              color: const Color.fromARGB(255, 98, 196, 241),
            ),
            // Gráfico de barras para mostrar el peso máximo
            BarSeries<PRData, String>(
              name: 'Peso Máximo',
              dataSource: prData,
              xValueMapper: (PRData data, _) => data.exercise, // Nombre del ejercicio en el eje X
              yValueMapper: (PRData data, _) => data.maxWeight, // Peso máximo en el eje Y
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              color: const Color.fromARGB(255, 0, 140, 255).withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}

class PRData {
  PRData(this.exercise, this.minWeight, this.maxWeight);

  final String exercise; // Nombre del ejercicio
  final double minWeight; // Peso mínimo
  final double maxWeight; // Peso máximo
}

// Datos de ejemplo para el gráfico
final List<PRData> prData = [
  PRData('Sentadilla', 80, 120),
  PRData('Peso Muerto', 90, 140),
  PRData('Press Banca', 70, 110),
  PRData('Dominadas', 60, 95),
  PRData('Press Militar', 65, 105),
];
