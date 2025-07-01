import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:finance_tracker/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:finance_tracker/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:finance_tracker/screens/add_expense/views/add_expense.dart';
import 'package:finance_tracker/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:finance_tracker/screens/home/views/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import '../../stats/stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = Colors.blue;
  Color unselectedItem = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
        builder: (context, state) {
      if (state is GetExpensesSuccess) {
        return Scaffold(
            bottomNavigationBar: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              child: BottomNavigationBar(
                  onTap: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  elevation: 3,
                  selectedItemColor: selectedItem, //Highlight selected icon
                  unselectedItemColor:
                      unselectedItem, //Gray out unselected items

                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.home,
                            color: index == 0 ? selectedItem : unselectedItem),
                        label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.graph_square_fill,
                            color: index == 1 ? selectedItem : unselectedItem),
                        label: 'Stats'),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.chart_pie_fill,
                            color: index == 2 ? selectedItem : unselectedItem),
                        label: 'Budgets'),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.ellipsis,
                            color: index == 3 ? selectedItem : unselectedItem),
                        label: 'More')
                  ]),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              mini: true,
              onPressed: () async {
                Expense? newExpense = await Navigator.push(
                  context,
                  MaterialPageRoute<Expense>(
                    builder: (BuildContext context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              CreateCategoryBloc(FirebaseExpenseRepo()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              GetCategoriesBloc(FirebaseExpenseRepo())
                                ..add(GetCategories()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              CreateExpenseBloc(FirebaseExpenseRepo()),
                        ),
                      ],
                      child: const AddExpense(),
                    ),
                  ),
                );

                if (newExpense != null) {
                  setState(() {
                    state.expenses.insert(0, newExpense);
                  });
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), //rounding effect on +
              ),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    //  shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.tertiary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary,
                      ],
                      transform: const GradientRotation(pi / 4),
                    )),
                child: const Icon(CupertinoIcons.add),
              ),
            ),
            body: index == 0 ? MainScreen(state.expenses) : const StatScreen());
      } else {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
