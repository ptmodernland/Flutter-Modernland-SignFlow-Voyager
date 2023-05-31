import 'package:bwa_cozy/bloc/all_approval/dto/detail_pbj_dto.dart';
import 'package:bwa_cozy/bloc/all_approval/dto/list_all_compare_dto.dart';
import 'package:bwa_cozy/bloc/all_approval/dto/list_all_pbj_kasbon_dto.dart';
import 'package:bwa_cozy/bloc/pbj/dto/ListPBJDTO.dart';

abstract class ApprovalMainPageState {}

class ApprovalMainPageStateInitial extends ApprovalMainPageState {}

class ApprovalMainPageStateLoading extends ApprovalMainPageState {}

class ApprovalMainPageStateSuccess extends ApprovalMainPageState {
  final String message;

  ApprovalMainPageStateSuccess(
      {this.message = "Selamat menggunakan aplikasi Modernland Approval"});
}

class ApprovalMainPageStateSuccessListPBJ extends ApprovalMainPageState {
  final List<ListPbjdto> datas;

  ApprovalMainPageStateSuccessListPBJ({this.datas = const []});
}

class ApprovalDetailPBJSuccess extends ApprovalMainPageState {
  final DetailPBJDTO data;

  ApprovalDetailPBJSuccess({required this.data});
}

class ApprovalMainPageStateSuccessListCompare extends ApprovalMainPageState {
  final List<ListAllCompareDTO> datas;

  ApprovalMainPageStateSuccessListCompare({this.datas = const []});
}

class ApprovalMainPageStateSuccessListKasbon extends ApprovalMainPageState {
  final List<ListAllKasbonDTO> datas;

  ApprovalMainPageStateSuccessListKasbon({this.datas = const []});
}

class ApprovalMainPageStateFailure extends ApprovalMainPageState {
  final String error;

  ApprovalMainPageStateFailure({required this.error});
}