import 'package:bwa_cozy/bloc/login/login_event.dart';
import 'package:bwa_cozy/bloc/login/login_response.dart';
import 'package:bwa_cozy/bloc/login/login_state.dart';
import 'package:bwa_cozy/bloc/notif/notif_event.dart';
import 'package:bwa_cozy/bloc/notif/notif_state.dart';
import 'package:bwa_cozy/repos/login_repository.dart';
import 'package:bwa_cozy/repos/notif_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotifCoreBloc extends Bloc<NotifCoreEvent, NotifCoreState> {
  final NotifRepository _repo;

  NotifCoreBloc(this._repo) : super(NotifStateInitial()) {
    on<NotifEventCount>((event, emit) async {
      emit(NotifStateLoading());
      print("fetching notif counter");
      try {
        final request = await _repo.countNotif();
        if (request.data != null) {
          emit(NotifStateSuccess(
            totalCompare: request.data?.totalCompare??"",
            totalKasbon: request.data?.totalKasbon??"",
            totalRealisasi: request.data?.totalRealisasi??'',
            totalSemua: request.data?.totalSemua??"",
            totalPermohonan: request.data?.totalPermohonan??"",
            totalIom: request.data?.totalIom??"",
          ));
        } else {
          emit(NotifStateFailure(error: request.message ?? ""));
        }
      } catch (e) {
        emit(NotifStateFailure(error: e.toString() ?? ""));
      }
    });
  }
}