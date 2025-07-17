import 'package:bloc/bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_transactions_event.dart';
part 'get_transactions_state.dart';

class GetTransactionsBloc
    extends Bloc<GetTransactionsEvent, GetTransactionsState> {
  final ExpenseRepository _expenseRepository;

  GetTransactionsBloc(this._expenseRepository)
      : super(GetTransactionsInitial()) {
    on<GetTransactions>((event, emit) async {
      emit(GetTransactionsLoading());
      try {
        List<Expense> expenses = await _expenseRepository.getExpenses();
        emit(GetTransactionsSuccess(expenses));
      } catch (e) {
        emit(GetTransactionsFailure());
      }
    });
  }
}
