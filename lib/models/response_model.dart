class ResponseModel {
  String? status, message;

  ResponseModel({this.status, this.message});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(status: json['status'], message: json['message']);
  }
}
