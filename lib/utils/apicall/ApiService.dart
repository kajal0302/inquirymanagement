import 'dart:async';
import 'dart:convert';
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
    final jsonBody = jsonEncode(body);

    try {
      if (kDebugMode) {
        loggerNoStack.i('POST Request: $url');
        loggerNoStack.i('POST Body: $jsonBody');
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