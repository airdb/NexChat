import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpService {
  static const String baseUrl = 'https://airdb.tech/apis/app/nexchat'; // 替换为实际的API地址
  
  // 单例模式
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  // 通用 headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'airdb.tech/1205a5f6822a1b901faefdbf96f2e77b',
    // 可以在这里添加 token 等认证信息
    // 'Authorization': 'Bearer $token',
  };

  // GET 请求
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST 请求
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT 请求
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE 请求
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // 处理响应
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('HTTP Error: ${response.statusCode}, ${response.body}');
    }
  }
} 