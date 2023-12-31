import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernland_signflow/bloc/compare/compare_event.dart';
import 'package:modernland_signflow/bloc/compare/compare_state.dart';
import 'package:modernland_signflow/repos/compare_repository.dart';

class CompareDetailBloc extends Bloc<CompareEvent, CompareState> {
  final CompareRepository repo;

  CompareDetailBloc(this.repo) : super(CompareStateInitial()) {
    on<GetCompareDetailEvent>((event, emit) async {
      try {
        final request = await repo.getCompareDetail(event.idCompare);
        if (request.data != null) {
          emit(CompareDetailSuccess(data: request.data!));
          print("success bloc approval_detail_pbj");
        } else {
          emit(CompareStateFailure(
              message: request.message ?? "",
              type: CompareEActionType.LOAD_DETAIL));
        }
      } catch (e) {
        print("error occured on approval pbj detail bloc" + e.toString());
        emit(CompareStateFailure(
            message: e.toString() ?? "", type: CompareEActionType.LOAD_DETAIL));
      }
    });

  }
}
