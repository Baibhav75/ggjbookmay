class UpdateOrderStatusModel {
  String? status;
  String? message;

  UpdateOrderStatusModel({
    this.status,
    this.message,
  });

  UpdateOrderStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Status'] = status;
    data['Message'] = message;
    return data;
  }
}