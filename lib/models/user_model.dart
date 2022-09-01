class UserModel {
  int? id, googleId;
  String? name, email;

  UserModel({this.id, this.googleId, this.name, this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        googleId: json['google_id'],
        name: json['name'],
        email: json['email']);
  }
}
