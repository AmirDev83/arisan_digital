import 'package:arisan_digital/models/member_model.dart';

class GroupModel {
  int? id, dues, target, totalBalance, totalNotDues;
  String? name, code, periodsType, periodsDate, notes, status, createdAt;
  List<MemberModel>? lastPaidMembers;

  GroupModel(
      {this.id,
      this.dues,
      this.target,
      this.name,
      this.code,
      this.periodsDate,
      this.periodsType,
      this.notes,
      this.status,
      this.totalBalance,
      this.totalNotDues,
      this.lastPaidMembers,
      this.createdAt});

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        periodsDate: json['periods_date'],
        periodsType: json['periods_type'],
        notes: json['notes'],
        status: json['status'],
        dues: json['dues'],
        target: json['target'],
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
