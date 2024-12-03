import 'dart:convert';
import 'http.dart';

class ApiService {
  static final _api = HttpService();

  static Future<Map<String, dynamic>?> reportBarcodeScan({
    required String barcodeValue,
    required String barcodeType,
  }) async {
    try {
      final response = await _api.post(
        '/v1/scan/barcode',
        body: {
          'timestamp': DateTime.now().toIso8601String(),
          'barcode_type': barcodeType,
          'barcode_value': barcodeValue,
        },
      );
      return response;
    } catch (e) {
      print('Error reporting barcode scan: $e');
      return null;
    }
  }
}
