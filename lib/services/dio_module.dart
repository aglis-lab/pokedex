import 'package:dio/dio.dart';

class DioModule with DioMixin implements Dio {
  DioModule._() {
    options = BaseOptions(
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      followRedirects: true,
      receiveDataWhenStatusError: true,
      // baseUrl: 'https://pokeapi.co/api/v2',
    );
  }

  static Dio getInstance() => DioModule._();
}
