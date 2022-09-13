import 'package:arisan_digital/models/member_model.dart';
import 'package:arisan_digital/models/response_model.dart';
import 'package:arisan_digital/repositories/group_repository.dart';
import 'package:arisan_digital/repositories/member_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'member_state.dart';

class MemberCubit extends Cubit<MemberState> {
  MemberCubit() : super(const MemberDataState());

  final GroupRepository _groupRepo = GroupRepository();
  final MemberRepository _memberRepo = MemberRepository();

  Future<void> getMembers(int groupId) async {
    emit(const MemberDataState(memberStatus: MemberStatus.loading));
    try {
      List<MemberModel>? data = await _groupRepo.getMemberGroups(groupId);
      if (data != null) {
        return emit(MemberDataState(
            listMembers: data, memberStatus: MemberStatus.success));
      }
      return emit(const MemberDataState().copyWith(
          memberStatus: MemberStatus.failure,
          message: "Member tidak ditemukan."));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(const MemberDataState(
          memberStatus: MemberStatus.failure,
          message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
    }
  }

  Future<void> createMember(MemberModel member) async {
    emit(const MemberDataState(memberStatus: MemberStatus.loading));
    try {
      ResponseModel? response = await _memberRepo.createMember(member);
      if (response == null) {
        return emit(const MemberDataState(
            memberStatus: MemberStatus.failure,
            message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
      }

      if (response.status == 'failure') {
        return emit(MemberDataState(
            memberStatus: MemberStatus.failure, message: response.message));
      }

      return emit(const MemberSuccessState(
          message: 'Anggota baru berhasil ditambahkan!'));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(const MemberDataState(
          memberStatus: MemberStatus.failure,
          message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
    }
  }

  Future<void> deleteMember(int id) async {
    emit(const MemberDataState(memberStatus: MemberStatus.loading));
    try {
      ResponseModel? response = await _memberRepo.deleteMember(id);
      if (response == null) {
        return emit(const MemberDataState(
            memberStatus: MemberStatus.failure,
            message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
      }

      if (response.status == 'failure') {
        return emit(MemberDataState(
            memberStatus: MemberStatus.failure, message: response.message));
      }

      return emit(
          const MemberSuccessState(message: 'Anggota berhasil dihapus!'));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(const MemberDataState(
          memberStatus: MemberStatus.failure,
          message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
    }
  }

  Future<void> updateMember(MemberModel member) async {
    emit(const MemberDataState(memberStatus: MemberStatus.loading));
    try {
      ResponseModel? response = await _memberRepo.updateMember(member);
      if (response == null) {
        return emit(const MemberDataState(
            memberStatus: MemberStatus.failure,
            message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
      }

      if (response.status == 'failure') {
        return emit(MemberDataState(
            memberStatus: MemberStatus.failure, message: response.message));
      }

      return emit(MemberSuccessState(message: response.message));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(const MemberDataState(
          memberStatus: MemberStatus.failure,
          message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
    }
  }

  Future<void> updateStatusActive(MemberModel member) async {
    emit(const MemberDataState(memberStatus: MemberStatus.loading));
    try {
      ResponseModel? response = await _memberRepo.updateStatusActive(member);
      if (response == null) {
        return emit(const MemberDataState(
            memberStatus: MemberStatus.failure,
            message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
      }

      if (response.status == 'failure') {
        return emit(MemberDataState(
            memberStatus: MemberStatus.failure, message: response.message));
      }

      return emit(MemberSuccessState(message: response.message));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(const MemberDataState(
          memberStatus: MemberStatus.failure,
          message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
    }
  }

  Future<void> updateStatusPaid(MemberModel member) async {
    emit(const MemberDataState(memberStatus: MemberStatus.loading));
    try {
      ResponseModel? response = await _memberRepo.updateStatusPaid(member);
      if (response == null) {
        return emit(const MemberDataState(
            memberStatus: MemberStatus.failure,
            message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
      }

      if (response.status == 'failure') {
        return emit(MemberDataState(
            memberStatus: MemberStatus.failure, message: response.message));
      }

      return emit(MemberSuccessState(message: response.message));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(const MemberDataState(
          memberStatus: MemberStatus.failure,
          message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
    }
  }

  Future<void> resetStatusPaid(MemberModel member) async {
    emit(const MemberDataState(memberStatus: MemberStatus.loading));
    try {
      ResponseModel? response = await _memberRepo.resetStatusPaid(member);
      if (response == null) {
        return emit(const MemberDataState(
            memberStatus: MemberStatus.failure,
            message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
      }

      if (response.status == 'failure') {
        return emit(MemberDataState(
            memberStatus: MemberStatus.failure, message: response.message));
      }

      return emit(MemberSuccessState(message: response.message));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return emit(const MemberDataState(
          memberStatus: MemberStatus.failure,
          message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
    }
  }
}
