class UserModel {
  int? id, googleId;
  String? name, email, photoUrl;

  UserModel({this.id, this.googleId, this.name, this.email, this.photoUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        googleId: json['google_id'],
        photoUrl: json['photo_url'],
        name: json['name'],
        email: json['email']);
  }

  @override
  String toString() {
    return '{id: $id, google_id: $googleId, name: $name, email: $email}';
  }
}
