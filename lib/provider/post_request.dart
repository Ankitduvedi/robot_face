import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../data/model/failure.dart';

Future<Either<Failure, String>> postRequest({
  required String endpoint,
  required dynamic data,
}) async {
  try {
    log('Request Data: ${data.toString()}');
    final dio = Dio();

    final response = await dio.post(
      // <-- Use `this._dio` directly
      "http://192.168.29.36:6000/gemini",
      data: data,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    log('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      log("Response data: ${response.data}");
      return right(response.data.toString());
    } else {
      log('Failed to upload data: ${response.statusCode}');
      return left(Failure(message: response.data.toString()));
    }
  } on DioException catch (e) {
    if (e.response != null) {
      log('Dio error occurred with status code: ${e.response!.statusCode}');
      log('Error data: ${e.response!.data}');
      return left(Failure(message: e.response!.data.toString()));
    } else {
      log('Dio error without response: ${e.message}');
      return left(Failure(message: e.message ?? 'Unknown error'));
    }
  } catch (e) {
    log('Unexpected error occurred: $e');
    return left(Failure(message: e.toString()));
  }
}
