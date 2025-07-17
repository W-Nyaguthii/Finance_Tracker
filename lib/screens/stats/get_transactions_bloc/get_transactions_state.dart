part of 'get_transactions_bloc.dart';

sealed class GetTransactionsState extends Equatable {
  const GetTransactionsState();

  @override
  List<Object> get props => [];
}

final class GetTransactionsInitial extends GetTransactionsState {}

final class GetTransactionsLoading extends GetTransactionsState {}

final class GetTransactionsSuccess extends GetTransactionsState {
  final List<Expense> expenses;

  const GetTransactionsSuccess(this.expenses);

  @override
  List<Object> get props => [expenses];
}

final class GetTransactionsFailure extends GetTransactionsState {}
