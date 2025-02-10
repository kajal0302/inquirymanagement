import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:inquirymanagement/utils/constants.dart';
import 'package:logger/logger.dart';

class ApiService{
  final String baseUrlInquiry = urlInquiryManagement;

  //This will include a stack trace (method call hierarchy) in the log messages, showing where the log was triggered in the code.
  var logger=Logger(
    printer: PrettyPrinter(),
  );

  //This disables the stack trace, meaning no method call hierarchy will be included in the log output.
  var loggerNoStack= Logger(
    printer:PrettyPrinter(
        methodCount: 0
    ),
  );


  Future<void> get<modelName>({
    required String endpoint,
    required modelName Function(Map<String, dynamic>) fromJson,
    required Function(modelName data) onSuccess,
    required Function(String errorMessage) onError,}) async {

    String baseUrl = baseUrlInquiry;
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      if (kDebugMode) {
        print('Making GET request to: $url');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = fromJson(jsonDecode(response.body));
        loggerNoStack.t(response.body);
        onSuccess(data);
      } else {
        final errorMessage =
            'Failed to GET data, Status code: ${response.statusCode}';
        if (kDebugMode) {
          logger.e("Failed to GET data, Status code",
              error: response.statusCode);
          print(errorMessage);
        }
        onError(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'Error during GET request: $e';
      logger.e("Error during GET request", error: e);
      if (kDebugMode) {
        print(errorMessage);
      }
      onError(errorMessage);
    }
  }


  Future<void> post<modelName>({
    required String endpoint,
    required Map<String, String> body,
    required modelName Function(Map<String, dynamic>) fromJson,
    required Function(modelName data) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    String baseUrl = baseUrlInquiry;


    final url = Uri.parse('$baseUrl$endpoint');

    try {
      if (kDebugMode) {
        print('Making POST request to: $url');
        print(
            'Request Headers: {Content-Type: application/x-www-form-urlencoded}');
        print('Request Body: $body');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (kDebugMode) {
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = fromJson(jsonDecode(response.body));
        loggerNoStack.t(response.body);
        onSuccess(data);
      } else {
        final errorMessage =
            'Failed to POST data, Status code: ${response.statusCode}';
        if (kDebugMode) {
          print(errorMessage);
        }
        onError(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'Error during POST request: $e';
      if (kDebugMode) {
        print(errorMessage);
      }
      onError(errorMessage);
    }
  }

}