import 'package:frontend/features/authentication/domain/entities/sutdent_rfid_entity.dart';

class StudentRfidModel extends StudentRfidEntity {
  StudentRfidModel({
    required super.id,
    required super.name,
    required super.email,
    required super.imageUrl,
  });

  factory StudentRfidModel.fromJson(Map<String, dynamic> json) {
    return StudentRfidModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      imageUrl: json["image_url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "image_url": imageUrl
    };
  }
}
