import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernland_signflow/bloc/stream/stream_state.dart';
import 'package:modernland_signflow/repos/stream/stream_repository.dart';

class OrderbookCubit extends Cubit<StreamState> {
  final StreamRepository repository;

  OrderbookCubit(this.repository) : super(StreamStateInitial());

  Future<void> fetchPrice() async {
    try {
      emit(StreamStateLoading());
      final stopwatch = Stopwatch()
        ..start(); // Create a stopwatch to measure elapsed time

      final approvals = await repository.getMDLNPrice();

      if (stopwatch.elapsed < Duration(seconds: 1)) {
        await Future.delayed(Duration(seconds: 1)); // Add a delay of 3 seconds
      }

      if (approvals.data != null) {
        emit(StreamStateOrderbookSuccess(datas: approvals.data!));
      }
    } catch (e) {
      emit(StreamStateFailure(message: 'Failed to load approvals: $e'));
    }
  }
}
