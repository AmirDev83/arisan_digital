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

  GroupModel(
      {this.id,
      this.dues,
      this.target,
      this.name,
      this.code,
      this.periodsDate,
      this.periodsDateEn,
      this.periodsType,
      this.notes,
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
        periodsType: json['periods_type'],
        notes: json['notes'],
        status: json['status'],
        dues: json['dues'],
        target: json['target'],
        createdBy: json['created_by'],
        totalBalance: json['total_balance'],
        totalNotDues: json['total_not_dues'],
        lastPaidMembers: json['last_paid_members'] != null
            ? List<MemberModel>.from(
                json["last_paid_members"].map((e) => MemberModel.fromJson(e)))
            : null,
        createdAt: json['created_at']);
  }
}

enum StatusGroup { active, inactive }
