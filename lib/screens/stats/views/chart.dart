import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_repository/expense_repository.dart';

class MyChart extends StatefulWidget {
  final List<Expense> expenses;

  const MyChart({
    super.key,
    required this.expenses,
  });

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: showingSections(),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    // Group expenses by category
    final expensesByCategory = <String, double>{};

    // Process only expense transactions (negative amounts)
    for (var expense in widget.expenses) {
      if (expense.amount < 0) {
        // Only expenses
        final category = expense.category.name;
        final amount = expense.amount.abs().toDouble();

        if (expensesByCategory.containsKey(category)) {
          expensesByCategory[category] = expensesByCategory[category]! + amount;
        } else {
          expensesByCategory[category] = amount;
        }
      }
    }

    // If no expenses, return empty list
    if (expensesByCategory.isEmpty) {
      return [];
    }

    // Convert to list format needed for pie chart
    final data =
        expensesByCategory.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final categoryName = entry.value.key;
      final amount = entry.value.value;
      final title = '0${index + 1}';

      // Get the actual category object to access color
      final category = widget.expenses
          .firstWhere((e) => e.category.name == categoryName)
          .category;

      return {
        'title': title,
        'category': categoryName,
        'value': amount,
        'color': Color(category.color),
      };
    }).toList();

    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      return PieChartSectionData(
        color: data[i]['color'] as Color,
        value: data[i]['value'] as double,
        title: data[i]['title'] as String,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
        badgeWidget: _Badge(
          data[i]['title'] as String,
          size: widgetSize,
          borderColor: data[i]['color'] as Color,
          category: data[i]['category'] as String,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.text, {
    required this.size,
    required this.borderColor,
    required this.category,
  });

  final String text;
  final String category;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).toInt()),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.bold,
            color: borderColor,
          ),
        ),
      ),
    );
  }
}
