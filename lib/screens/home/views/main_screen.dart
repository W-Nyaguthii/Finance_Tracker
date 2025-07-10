import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:finance_tracker/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:finance_tracker/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';

class MainScreen extends StatelessWidget {
  final List<Expense> expenses;
  const MainScreen(this.expenses, {super.key});

  // Calculate total income (positive amounts)
  double get totalIncome {
    return expenses
        .where((expense) => expense.amount > 0 || expense.type == "Income")
        .fold(0, (sum, expense) => sum + expense.amount.abs());
  }

  // Calculate total expenses (negative amounts)
  double get totalExpenses {
    return expenses
        .where((expense) => expense.amount < 0 || expense.type == "Expense")
        .fold(0, (sum, expense) => sum + expense.amount.abs());
  }

  // Calculate total balance
  double get totalBalance {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Group expenses by date
  Map<String, List<Expense>> get groupedExpenses {
    Map<String, List<Expense>> grouped = {};

    for (var expense in expenses) {
      String dateKey = DateFormat('dd/MM/yyyy').format(expense.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(expense);
    }

    // Sort the map by date (most recent first)
    var sortedEntries = grouped.entries.toList()
      ..sort((a, b) {
        DateTime dateA = DateFormat('dd/MM/yyyy').parse(a.key);
        DateTime dateB = DateFormat('dd/MM/yyyy').parse(b.key);
        return dateB.compareTo(dateA);
      });

    return Map.fromEntries(sortedEntries);
  }

  // Calculate daily total for a group of expenses
  double getDailyTotal(List<Expense> dayExpenses) {
    return dayExpenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Get day name (Today, Yesterday, or day of week)
  String getDayLabel(String dateString) {
    DateTime date = DateFormat('dd/MM/yyyy').parse(dateString);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime expenseDate = DateTime(date.year, date.month, date.day);

    if (expenseDate == today) {
      return 'Today';
    } else if (expenseDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow[700]),
                        ),
                        Icon(
                          CupertinoIcons.person_fill,
                          color: Colors.yellow[800],
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome!",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.outline),
                        ),
                        Text(
                          "User_Name",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface),
                        )
                      ],
                    ),
                  ],
                ),
                /*     IconButton(
                    onPressed: () {}, icon: const Icon(CupertinoIcons.settings)) */
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                    transform: const GradientRotation(pi / 4),
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4,
                        color: Colors.grey.shade300,
                        offset: const Offset(5, 5))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ksh ${totalBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                  color: Colors.white30,
                                  shape: BoxShape.circle),
                              child: const Center(
                                  child: Icon(
                                CupertinoIcons.arrow_down,
                                size: 12,
                                color: Colors.greenAccent,
                              )),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Income',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  'Ksh ${totalIncome.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                  color: Colors.white30,
                                  shape: BoxShape.circle),
                              child: const Center(
                                  child: Icon(
                                CupertinoIcons.arrow_up,
                                size: 12,
                                color: Colors.red,
                              )),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Expenses',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  'Ksh ${totalExpenses.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Transactions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            // Grouped Expense List with BlocConsumer
            Expanded(
              child: BlocConsumer<CreateExpenseBloc, CreateExpenseState>(
                listener: (context, state) {
                  if (state is DeleteExpenseSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Expense deleted successfully!')),
                    );
                    // Automatically refresh the expense list
                    context.read<GetExpensesBloc>().add(GetExpenses());
                  } else if (state is DeleteExpenseFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Failed to delete expense!')),
                    );
                  }
                },
                builder: (context, state) {
                  if (expenses.isEmpty) {
                    return const Center(
                      child: Text(
                        'No transactions yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: groupedExpenses.length,
                    itemBuilder: (context, index) {
                      String dateKey = groupedExpenses.keys.elementAt(index);
                      List<Expense> dayExpenses = groupedExpenses[dateKey]!;
                      double dailyTotal = getDailyTotal(dayExpenses);
                      String dayLabel = getDayLabel(dateKey);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Header
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 12.0, top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dayLabel,
                                      style: TextStyle(
                                        fontSize: 16,
                                        //  fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    if (dayLabel != 'Today' &&
                                        dayLabel != 'Yesterday')
                                      Text(
                                        dateKey,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                      ),
                                  ],
                                ),
                                Text(
                                  'Ksh ${dailyTotal.abs().toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: dailyTotal < 0
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Expenses for this day
                          ...dayExpenses.map((expense) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Color(
                                                        expense.category.color),
                                                    shape: BoxShape.circle),
                                              ),
                                              Image.asset(
                                                'assets/${expense.category.icon}.png',
                                                scale: 2,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                expense.category.name,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                expense.type,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Ksh ${expense.amount.abs().toStringAsFixed(2)}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: expense.amount < 0
                                                    ? Colors.red
                                                    : Colors.green,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: const Color.fromARGB(
                                                  255, 22, 22, 22),
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<CreateExpenseBloc>()
                                                  .add(DeleteExpense(
                                                      expense.expenseId));
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
