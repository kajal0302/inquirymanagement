import 'dart:convert';
import 'dart:io';
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
    bool? wp,
    bool? qt,
    required String endpoint,
    required modelName Function(Map<String, dynamic>) fromJson,
    required Function(modelName data) onSuccess,
    required Function(String errorMessage) onError,}) async {

    String baseUrl = baseUrlInquiry;
    var url = Uri.parse('$baseUrl$endpoint');

    if(wp != null && wp){
      url = Uri.parse('$wpUrl$endpoint');
    }

    if(qt != null && qt){
      url = Uri.parse('$quotation$endpoint');
    }

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
    bool? wp,
    bool? temp,
    required String endpoint,
    required Map<String, String> body,
    required modelName Function(Map<String, dynamic>) fromJson,
    required Function(modelName data) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    String baseUrl = baseUrlInquiry;
    var url = Uri.parse('$baseUrl$endpoint');

    //// temp mean globalitinfosolution current is on globalitians so delete after transfer to globalitinfsolution
    if(temp != null && temp){
      url = Uri.parse('$urlClassManagement$endpoint');
    }

    if(wp != null && wp){
      url = Uri.parse('$wpUrl$endpoint');
    }

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

  Future<void> postMedia<modelName>({
    bool? wp,
    required String endpoint,
    required Map<String, String> body,
    required modelName Function(Map<String, dynamic>) fromJson,
    required Function(modelName data) onSuccess,
    required Function(String errorMessage) onError,
    File? file,
    List<File>? files,
    String fileField = 'file',
  }) async {
    String baseUrl = urlClassManagement;
    if(wp != null){
      baseUrl = wpUrl;
    }

    var url = Uri.parse('$baseUrl$endpoint');

    if(wp != null && wp){
      url = Uri.parse('$urlClassManagement$endpoint');
    }
    try {
      if (kDebugMode) {
        print('Making POST request to: $url');
        print('Request Body: $body');
      }

      // Use MultipartRequest for file uploads
      final request = http.MultipartRequest('POST', url);

      // Add regular form data
      body.forEach((key, value) {
        request.fields[key] = value;
      });

      // If a single file is provided, add it to the request
      if (file != null) {
        final fileStream = http.ByteStream(file.openRead());
        final length = await file.length();
        final multipartFile = http.MultipartFile(
          fileField,
          fileStream,
          length,
          filename: file.path.split('/').last,  // Extract file name
        );
        request.files.add(multipartFile);
      }

      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          final fileStream = http.ByteStream(file.openRead());
          final length = await file.length();
          final multipartFile = http.MultipartFile(
            'files[]',
            fileStream,
            length,
            filename: file.path.split('/').last,
          );
          request.files.add(multipartFile);
        }
      }

      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });
      if (kDebugMode) {
        print("Number of files to upload: ${request.files.length}");
      }
      // Send the request
      final response = await request.send();

      // Handle response
      if (kDebugMode) {
        print('Response Status Code: ${response.statusCode}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        loggerNoStack.i(responseData);
        final data = fromJson(jsonDecode(responseData));
        onSuccess(data);
      } else {
        final responseData = await response.stream.bytesToString();
        loggerNoStack.i(responseData);
        if (kDebugMode) {
          print(responseData);
        }
        final errorMessage = 'Failed to upload file, Status code: ${response.statusCode}';
        if (kDebugMode) {
          print(errorMessage);
        }
        onError(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'Error during file upload: $e';
      if (kDebugMode) {
        print(errorMessage);
      }
      onError(errorMessage);
    }
  }

}