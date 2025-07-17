import 'package:expense_repository/expense_repository.dart';
import 'package:finance_tracker/screens/savings/bloc/bloc/savings_bloc.dart';
import 'package:finance_tracker/screens/stats/get_transactions_bloc/get_transactions_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'screens/budgets/blocs/bloc/budget_bloc.dart';
import 'simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with your Firebase options i.e web or mobile options
    // For web option;
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => CreateExpenseBloc(FirebaseExpenseRepo()),
      ),
      BlocProvider(
        create: (context) => BudgetBloc(),
      ),
      BlocProvider(
        create: (context) => SavingsBloc(),
      ),
      BlocProvider(
        //for fetching transactions in stats screen
        create: (context) => GetTransactionsBloc(
          FirebaseExpenseRepo(),
        ),
      ),
    ],
    child: const MyApp(),
  ));
}
