//import 'package:bju_information_app/api/api.dart';
import 'dart:ffi';
import 'package:dio/dio.dart';

///
/// BJU网络
///
class BjuHttp {
  /// Dio 请求的配置
  // static final BaseOptions baseOptions = BaseOptions(
  //       // baseUrl: API.baseUri,
  //       connectTimeout: 6000,
  //       receiveTimeout: 4000,
  //       contentType: Headers.jsonContentType,
  //       headers: {
  //         Headers.contentTypeHeader: Headers.jsonContentType,
  //         'Authorization': 'Bearer '
  //       }
  //   );

  /// Dio请求
  static final Dio dio = Dio();

  /// 初始化Dio配置
  static void initConfig() {
    // 基础选项设置
    // dio.options = BaseOptions(
    //     // baseUrl: API.baseUri,
    //     // connectTimeout: 6000,
    //     // receiveTimeout: 4000,
    //     // contentType: Headers.jsonContentType,
    //     // headers: {
    //     //   // Headers.contentTypeHeader: Headers.jsonContentType,
    //     //   // 'Authorization': 'Bearer '
    //     // }
    // );

    // 请求拦截器设置
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          return handler.next(options);
        }, onResponse: (response, handler) async {
          // Do something with response data
          return handler.next(response);
        }, onError: (error, handler) async {
          // Do something with response error
          return handler.next(error);
        }
    ));
  }

  /// 设置访问Token
  static token(dynamic token) {
    dio.options.contentType = 'application/json';
    dio.options.headers['Authorization'] = token;
    print('[set token] dio header :' + dio.options.headers.toString());
  }

  // 销毁token
  static disposeToken() {
    dio.options.contentType = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ';
    print('[dispose token] dio header :' + dio.options.headers.toString());
  }

  //Dio get instance => _dio;

  ///
  /// GET请求
  ///   * [path] 路径字符串
  ///   * [params] 请求参数
  ///
  static Future<Response> get(String path,
          {Map<String, dynamic>? params}) async =>
      await dio.get(path, queryParameters: params);

  ///
  /// POST请求
  ///   * [path] 路径字符串
  ///   * [data] body数据
  ///   * [params] 请求参数（URL编码后）
  ///   * [options] 请求设置
  ///
  static Future<Response> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? params,
        Options? options
      }
  ) async => await dio.post(
      path,
      queryParameters: params,
      options: options
  );

  ///
  /// POST请求
  ///   * [path] 路径字符串
  ///   * [data] body数据(支持FormData)
  ///   * [params] 请求参数（URL编码后）
  ///
  static Future<Response> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? params
      }
  ) async => await dio.put(
      path,
      queryParameters: params
  );

  ///
  /// POST请求
  ///   * [path] 路径字符串
  ///   * [data] body数据
  ///   * [params] 请求参数（URL编码后）
  ///
  static Future<Response> delete(
      String path,
      {dynamic data, Map<String, dynamic>? params}
  ) async => await dio.delete(
      path,
      queryParameters: params
  );
}
