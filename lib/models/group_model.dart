class GroupModel {
  int? id, dues, target;
  String? name, code, periodsType, periodsDate, notes, status, createdAt;

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
        createdAt: json['created_at']);
  }
}
