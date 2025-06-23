import 'dart:math';

import 'package:finance_tracker/screens/home/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, //4+ icons
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.graph_square_fill),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_pie_fill),
              label: 'Budgets',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.ellipsis),
              label: 'More',
            ),
            /*  BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar_circle),
            label: 'savings',
          ),
         BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book_fill),
            label: 'Budgets',
          ), */
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          mini: true,
          onPressed: () {
            // Action for the floating action button
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), //rounding effect on +
          ),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.tertiary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ],
                transform: const GradientRotation(pi / 4),
              ),
            ),
            child: const Icon(CupertinoIcons.add),
          ),
        ),
        body: const MainScreen());
  }
}
