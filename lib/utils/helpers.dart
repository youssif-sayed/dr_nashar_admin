import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'constants.dart';

class Helpers {
  Helpers._();

  static Future<bool> sendFcmNotification({
    required String title,
    required String body,
    String? imageUrl,
    String? to,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=${Constants.fcmServerKey}',
        },
        body: jsonEncode({
          'to': to,
          "notification": {
            "title": title,
            "body": body,
            "image": imageUrl,
          }
        }),
      );

      return response.statusCode == 200;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}
