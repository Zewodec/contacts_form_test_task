import 'package:dio/dio.dart';

class DioSendMessage {
  DioSendMessage({required Dio dio}) : _dio = dio;

  final Dio _dio;
  
  static const String endpoint = 'https://api.byteplex.info/api/test/contact/';

  Future<Map<String,dynamic>> sendMessage(
      String name, String email, String message) async {
    Map<String, dynamic> dataToSend = {
      'name': name,
      'email': email,
      'message': message,
    };

    try {
      final response = await _dio.post(
        endpoint,
        data: dataToSend,
      );

      if (response.statusCode == 201) {
        return {"success" : true};
      } else {
        return {"success" : false};
      }
    } on DioException catch (e) {
      return {"error" : e.message.toString()};
    }
  }
}
