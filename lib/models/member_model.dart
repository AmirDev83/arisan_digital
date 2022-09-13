import 'package:arisan_digital/models/group_model.dart';

class MemberModel {
  int? id, nominalPaid;
  String? name, noTelp, noWhatsapp, email, datePaid, statusPaid, statusActive;
  bool? canDelete, isGetReward;
  GroupModel? group;

  MemberModel(
      {this.id,
      this.name,
      this.group,
      this.noTelp,
      this.noWhatsapp,
      this.email,
      this.datePaid,
      this.canDelete,
      this.statusPaid,
      this.isGetReward,
      this.nominalPaid,
      this.statusActive});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
        id: json['id'],
        name: json['name'],
        group:
            json['group'] != null ? GroupModel.fromJson(json['group']) : null,
        noTelp: json['no_telp'],
        noWhatsapp: json['no_whatsapp'],
        email: json['email'],
        isGetReward: json['is_get_reward'] == 1 ? true : false,
        canDelete: json['can_delete'],
        datePaid: json['date_paid'],
        statusPaid: json['status_paid'],
        nominalPaid: json['nominal_paid'],
        statusActive: json['status_active']);
  }
}
