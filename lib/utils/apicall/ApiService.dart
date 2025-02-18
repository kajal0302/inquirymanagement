import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:inquirymanagement/utils/constants.dart';
import 'package:logger/logger.dart';

class ApiService {
  final String baseUrlInquiry = urlInquiryManagement;
  final Logger logger;
  final http.Client client;

  ApiService({
    http.Client? client,
  })  : client = client ?? http.Client(),
        logger = Logger(
          printer: PrettyPrinter(),
        );

  final loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  // Generic GET method with improved error handling and Futures
  Future<modelName?> get<modelName>({
    required String endpoint,
    required modelName Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final url = Uri.parse('$baseUrlInquiry$endpoint').replace(
      queryParameters: queryParameters?.map((k, v) => MapEntry(k, v.toString())),
    );

    try {
      if (kDebugMode) {
        loggerNoStack.i('GET Request: $url');
      }

      final response = await client
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 5)); // Reduced timeout

      if (kDebugMode) {
        loggerNoStack.i('GET Response (${response.statusCode}): ${response.body}');
      }

      if (response.statusCode == 200) {
        // Offload JSON parsing to an isolate for large payloads
        final jsonData = await compute(jsonDecode, response.body);
        return fromJson(jsonData);
      } else {
        throw ApiException(
          'GET failed (${response.statusCode}): ${response.body}',
          response.statusCode,
        );
      }
    } on TimeoutException {
      throw ApiException('Request timed out', 408);
    } on http.ClientException catch (e) {
      throw ApiException('Network error: $e', 0);
    } catch (e) {
      throw ApiException('Unexpected error: $e', 0);
    }
  }

  // Generic POST method with JSON support
  Future<modelName?> post<modelName>({
    required String endpoint,
    required Map<String, dynamic> body,
    required modelName Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrlInquiry$endpoint');
    final jsonBody = body;

    try {
      if (kDebugMode) {
        loggerNoStack.i('POST Request: $url');
        loggerNoStack.i('POST Body: ${jsonEncode(jsonBody)}');
      }

      final response = await client
          .post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          ...?headers,
        },
        body: jsonBody,
      )
          .timeout(const Duration(seconds: 5));

      if (kDebugMode) {
        loggerNoStack.i('POST Response (${response.statusCode}): ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = await compute(jsonDecode, response.body);
        return fromJson(jsonData);
      } else {
        throw ApiException(
          'POST failed (${response.statusCode}): ${response.body}',
          response.statusCode,
        );
      }
    } on TimeoutException {
      throw ApiException('Request timed out', 408);
    } on http.ClientException catch (e) {
      throw ApiException('Network error: $e', 0);
    } catch (e) {
      throw ApiException('Unexpected error: $e', 0);
    }
  }

  // Generic POST method with Image support
  Future<modelName?> postMedia<modelName>({
    required String endpoint,
    required Map<String, String> body,
    required modelName Function(Map<String, dynamic>) fromJson,
    File? file, // File to upload
    String fileField = 'file', // Field name for the file (default: 'file')
    Map<String, String>? headers,
    int maxFileSizeMB = 2,
  }) async {
    final url = Uri.parse('$baseUrlInquiry$endpoint');

    try {
      if(file != null) {
        final fileSizeInBytes = await file.length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        if (fileSizeInMB > maxFileSizeMB) {
          throw ApiException(
            'File size exceeds the maximum allowed size of $maxFileSizeMB MB',
            413, // Payload Too Large
          );
        }
      }

      // Create a multipart request
      final request = http.MultipartRequest('POST', url);

      // Add headers
      if (headers != null) {
        request.headers.addAll(headers);
      }

      if(file!=null) {
        // Add the file
        final fileStream = http.ByteStream(file.openRead());
        final fileLength = await file.length();
        final multipartFile = http.MultipartFile(
          fileField,
          fileStream,
          fileLength,
          filename: file.path
              .split('/')
              .last, // Extract filename
        );
        request.files.add(multipartFile);
      }

      // Add form fields
      request.fields.addAll(body);

      if (kDebugMode) {
        loggerNoStack.i('POST Media Request: $url');
        loggerNoStack.i('POST Media Fields: $body');
        loggerNoStack.i('POST Media File: ${file != null ? file.path : ""}');
      }

      // Send the request
      final response = await request.send().timeout(const Duration(seconds: 30));

      // Convert StreamedResponse to Response
      final http.Response parsedResponse = await http.Response.fromStream(response);

      if (kDebugMode) {
        loggerNoStack.i('POST Media Response (${parsedResponse.statusCode}): ${parsedResponse.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = await compute(jsonDecode, parsedResponse.body);
        return fromJson(jsonData);
      } else {
        throw ApiException(
          'POST failed (${parsedResponse.statusCode}): ${parsedResponse.body}',
          parsedResponse.statusCode,
        );
      }
    } on TimeoutException {
      throw ApiException('Request timed out', 408);
    } on http.ClientException catch (e) {
      throw ApiException('Network error: $e', 0);
    } catch (e) {
      throw ApiException('Unexpected error: $e', 0);
    }
  }

  void dispose() {
    client.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}