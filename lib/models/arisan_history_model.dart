import 'package:arisan_digital/models/member_model.dart';

class ArisanHistoryModel {
  int? id;
  String? date, notes;
  MemberModel? winner;
  List<ArisanHistoryDetail>? arisanHistoryDetails;

  ArisanHistoryModel(
      {this.id, this.date, this.notes, this.winner, this.arisanHistoryDetails});

  factory ArisanHistoryModel.fromJson(Map<String, dynamic> json) {
    return ArisanHistoryModel(
        id: json['id'],
        date: json['date'],
        notes: json['notes'],
        winner: json['winner'] != null
            ? MemberModel.fromJson(json['winner'])
            : null,
        arisanHistoryDetails: json['arisan_history_details'] != null
            ? List<ArisanHistoryDetail>.from(json["arisan_history_details"]
                .map((e) => ArisanHistoryDetail.fromJson(e)))
            : null);
  }
}

class ArisanHistoryDetail {
  int? id;
  String? statusPaid, nominalPaid, datePaid;
  MemberModel? member;

  ArisanHistoryDetail(
      {this.id, this.statusPaid, this.nominalPaid, this.datePaid, this.member});

  factory ArisanHistoryDetail.fromJson(Map<String, dynamic> json) {
    return ArisanHistoryDetail(
        id: json['id'],
        statusPaid: json['status_paid'],
        nominalPaid: json['nominal_paid'],
        datePaid: json['date_paid'],
        member: json['member'] != null
            ? MemberModel.fromJson(json['member'])
            : null);
  }
}
