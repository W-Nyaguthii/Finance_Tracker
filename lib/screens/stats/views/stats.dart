import 'package:finance_tracker/screens/stats/get_transactions_bloc/get_transactions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker/screens/stats/views/chart.dart';
import 'package:expense_repository/expense_repository.dart';

class StatScreen extends StatefulWidget {
  const StatScreen({super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch transactions when screen loads
    context.read<GetTransactionsBloc>().add(GetTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetTransactionsBloc, GetTransactionsState>(
      listener: (context, state) {
        if (state is GetTransactionsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load transactions'),
            ),
          );
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All Spending',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: BlocBuilder<GetTransactionsBloc, GetTransactionsState>(
                  builder: (context, state) {
                    if (state is GetTransactionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetTransactionsSuccess) {
                      final expenses =
                          state.expenses.where((e) => e.amount < 0).toList();

                      if (expenses.isEmpty) {
                        return const Center(
                            child: Text('No expense transactions found'));
                      }

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: MyChart(expenses: expenses),
                      );
                    } else {
                      return const Center(child: Text('Failed to load data'));
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<GetTransactionsBloc, GetTransactionsState>(
                  builder: (context, state) {
                    if (state is GetTransactionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetTransactionsSuccess) {
                      final expenses =
                          state.expenses.where((e) => e.amount < 0).toList();

                      if (expenses.isEmpty) {
                        return const Center(child: Text('No categories found'));
                      }

                      return buildCategoriesList(expenses);
                    } else {
                      return const Center(
                          child: Text('Failed to load categories'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoriesList(List<Expense> expenses) {
    // Group expenses by category and calculate totals
    final categoryTotals = <String, double>{};
    final categoryExpenses = <String, Category>{};

    for (var expense in expenses) {
      final categoryName = expense.category.name;
      final amount = expense.amount.abs().toDouble();

      if (categoryTotals.containsKey(categoryName)) {
        categoryTotals[categoryName] = categoryTotals[categoryName]! + amount;
      } else {
        categoryTotals[categoryName] = amount;
        categoryExpenses[categoryName] = expense.category;
      }
    }

    // Convert to list and sort by amount
    final categories = categoryTotals.entries.toList();
    categories.sort((a, b) => b.value.compareTo(a.value));

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final categoryName = categories[index].key;
        final amount = categories[index].value;
        final category = categoryExpenses[categoryName]!;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(category.color),
              child: category.icon.isNotEmpty
                  ? Image.asset(
                      'assets/${category.icon}.png',
                      width: 24,
                      height: 24,
                    )
                  : Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            title: Text(
              categoryName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              getCategoryTransactionCount(categoryName, expenses),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing: Text(
              'Ksh ${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }

  String getCategoryTransactionCount(
      String categoryName, List<Expense> expenses) {
    final count = expenses.where((e) => e.category.name == categoryName).length;
    return '$count transaction${count == 1 ? '' : 's'}';
  }
}
