import 'get_server_key.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SendNotificationService {
  static Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    String serverKey = await GetServerKey().getServerKeyToken();

    String url =
        "https://fcm.googleapis.com/v1/projects/flutterflow-auth-931d9/messages:send";

    var headers = <String, String>{
      'Authorization': 'Bearer $serverKey',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {"body": body, "title": title},
        "data": data
      }
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully!");
    } else {
      print("Failed to send notification. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }
}