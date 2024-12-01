import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  Future<String> downloadFile(String url, String filename) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String filePath = '${appDir.path}/$filename';
        
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Download error: $e');
    }
  }

  Future<String> downloadAndUnzip(String url, String destinationDir) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String tempZipPath = '${appDir.path}/temp.zip';
        final String extractPath = '${appDir.path}/$destinationDir';
        
        // Save zip file
        await File(tempZipPath).writeAsBytes(response.bodyBytes);
        
        // Create extraction directory
        Directory(extractPath).createSync(recursive: true);
        
        // TODO: Add unzip logic here using archive package
        
        // Clean up zip file
        await File(tempZipPath).delete();
        
        return extractPath;
      } else {
        throw Exception('Failed to download zip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Download and unzip error: $e');
    }
  }
} 