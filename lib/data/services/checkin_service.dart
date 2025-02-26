import 'dart:convert';
import 'package:checkin_app/constants.dart';
import 'package:checkin_app/data/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CheckinService {
  static final CheckinService instance = CheckinService._internal();

  factory CheckinService() => instance;

  CheckinService._internal();

  Future<http.Response> checkIn({
    required int qrCodeId,
    required String qrCodeNonce,
    required int locationId,
    required double longitude,
    required double latitude,
  }) async {
    final Uri url = Uri.parse("$baseUrl/api/checkin");

    final Map<String, dynamic> requestBody = {
      "qrCodeId": qrCodeId,
      "qrCodeNonce": qrCodeNonce,
      "locationId": locationId,
      "longitude": longitude,
      "latitude": latitude,
    };

    final String accessToken = await AuthService.instance.getAccessToken();

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(requestBody),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
