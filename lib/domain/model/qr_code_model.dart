import 'package:checkin_app/domain/model/location_model.dart';

class QrCodeModel {
  int id;
  String nonce;
  LocationModel location;
  String createdAt;
  String expiredAt;

  QrCodeModel(
      {required this.id,
      required this.nonce,
      required this.location,
      required this.createdAt,
      required this.expiredAt});

  factory QrCodeModel.fromJson(Map<String, dynamic> json) {
    return QrCodeModel(
      id: json['id'],
      nonce: json['nonce'],
      location: LocationModel.fromJson(json['location']),
      createdAt: json['createdAt'],
      expiredAt: json['expiredAt'],
    );
  }
}
