import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart' as pathProvider;
// import 'package:path/path.dart' as path;

class Helper {
  // Singleton
  Helper._internal();
  static final Helper _helper = Helper._internal();
  factory Helper() => _helper;

  // final _baseUrl = 'http://202.157.176.79:7000';
  // final _baseUrl =
  //     kDebugMode ? "http://192.168.43.120:8080" : 'http://202.157.176.79:7000';
  // final _platform = MethodChannel("com.zy.biker_shop_sales/chat");

  late Dio _dio;
  late Options _postOptions;

  Dio get dio => _dio;
  Options get postOptions => _postOptions;

  Future<void> init() async {
    // final dir = await pathProvider.getApplicationDocumentsDirectory();
    // final pathCookie = path.join(dir.path, '.cookies');

    _dio = Dio(
      BaseOptions(
        // baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    // _dio.interceptors.add(
    //   CookieManager(
    //     PersistCookieJar(
    //       storage: FileStorage(pathCookie),
    //     ),
    //   ),
    // );
    _postOptions = Options(contentType: Headers.formUrlEncodedContentType);
  }

  // Future<List> importChatData() {
  //   return _platform.invokeMethod<List>("importChatData");
  // }

  String converPhoneWA(String phone) {
    phone.replaceAll(RegExp(r'[^\w\s]+'), '');

    final firstNumber = phone[0];
    if (firstNumber == '0') {
      return "+62${phone.substring(1)}";
    }
    if (firstNumber == '+') {
      return phone;
    }

    return "+62$phone";
  }

  String idToNumber(int id) {
    var idStr = id.toString();

    if (idStr.length == 1) {
      idStr = '#00$idStr';
    } else if (idStr.length == 2) {
      idStr = '#0$idStr';
    } else {
      idStr = '#$idStr';
    }

    return idStr;
  }

  Color darken(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}

class Error {
  String message;

  Error(this.message);
}
