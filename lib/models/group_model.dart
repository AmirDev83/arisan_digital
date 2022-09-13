import 'package:arisan_digital/models/member_model.dart';

class GroupModel {
  int? id, dues, target, totalBalance, totalNotDues, createdBy;
  String? name,
      code,
      periodsType,
      periodsDate,
      periodsDateEn,
      notes,
      status,
      createdAt;
  List<MemberModel>? lastPaidMembers;
  List<MemberModel>? members;
  bool? isShuffle;

  GroupModel(
      {this.id,
      this.dues,
      this.isShuffle,
      this.target,
      this.name,
      this.code,
      this.periodsDate,
      this.periodsDateEn,
      this.periodsType,
      this.notes,
      this.members,
      this.status,
      this.totalBalance,
      this.totalNotDues,
      this.lastPaidMembers,
      this.createdBy,
      this.createdAt});

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        periodsDate: json['periods_date'],
        periodsDateEn: json['periods_date_en'],
        isShuffle: json['is_shuffle'],
        periodsType: json['periods_type'],
        notes: json['notes'],
        status: json['status'],
        dues: json['dues'],
        target: json['target'],
        createdBy: json['created_by'],
        totalBalance: json['total_balance'],
        totalNotDues: json['total_not_dues'],
        members: json['members'] != null
            ? List<MemberModel>.from(
                json["members"].map((e) => MemberModel.fromJson(e)))
            : null,
        lastPaidMembers: json['last_paid_members'] != null
            ? List<MemberModel>.from(
                json["last_paid_members"].map((e) => MemberModel.fromJson(e)))
            : null,
        createdAt: json['created_at']);
  }
}

enum StatusGroup { active, inactive }
