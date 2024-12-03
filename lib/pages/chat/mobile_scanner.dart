import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'qr_payment.dart';
import 'package:mobile_scanner/src/enums/torch_state.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController? controller;
  bool isFlashOn = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
  print('Camera: ${await Permission.camera.status}');
    print('Camera permanently denied: ${await Permission.camera.isPermanentlyDenied}');
    // print('Camera service status: ${await Permission.camera.serviceStatus}');

    final status = await Permission.camera.request();
    print("Camera permission status: $status");
    if (status.isDenied) {
      // 用户拒绝了权限
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('需要相机权限才能扫描二维码')),
      );
      Navigator.pop(context);
      
    }
  }

  Future<void> _scanImageFromGallery() async {
    final status = await Permission.photos.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('需要相册权限才能选择二维码图片')),
      );
      return;
    }
    
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final controller = MobileScannerController();
      try {
        final result = await controller.analyzeImage(image.path);
        if (result != null && result.barcodes.isNotEmpty) {
          final String? code = result.barcodes.first.rawValue;
          if (code != null) {
            identifyPaymentType(code);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('未在图片中找到二维码')),
          );
        }
      } finally {
        controller.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller ?? MobileScannerController(),
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && !_isProcessing) {
                _isProcessing = true;
                controller?.stop();
                
                Future.delayed(Duration(milliseconds: 100), () {
                  if (barcodes.first.rawValue != null) {
                    identifyPaymentType(barcodes.first.rawValue!);
                  }
                });
              }
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 + 150,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Colors.black26,
              child: GestureDetector(
                onTap: _toggleFlash,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isFlashOn ? Icons.flashlight_off : Icons.flashlight_on,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '轻触照亮',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              '识别二维码 / 花草 / 动物 / 商品等',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '扫一扫',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 80),
                      Text(
                        '翻译',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBottomButton(Icons.person, '我的二维码'),
                      SizedBox(width: 100),
                      _buildBottomButton(
                        Icons.photo_library, 
                        '相册',
                        onTap: _scanImageFromGallery,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() async {
    if (controller != null) {
      await controller!.toggleTorch();
      setState(() {
        isFlashOn = !isFlashOn;  // Simply toggle the state
      });
    }
  }

  void identifyPaymentType(String code) {
    _isProcessing = false;
    print('scan handle: ${code}');

    if (code.contains('SG.PAYNOW')) {
      // PayNow QR
      Map<String, dynamic> parsedData = parseSGQR(code);
      String? uen = extractUEN(parsedData["26"]);

      print('Payload Format Indicator: ${parsedData["00"]}');
      print('Point of Initiation Method: ${parsedData["01"]}');
      print('Merchant Account(UEN): $uen');
      print('Currency: ${parsedData["53"]}');
      print('Amount: ${parsedData["54"]}');
      print('Merchant Name: ${parsedData["59"]}');
      print('Merchant City: ${parsedData["60"]}');
      if (Navigator.canPop(context)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QRPaymentPage(
              qrData: code,
              paymentType: 'PAYNOW',
              parsedData: parsedData,
              recipientName: parsedData["59"],
              recipientId: uen,
            ),
          ),
        );
      }
  } else if (code.startsWith('https://qr.alipay.com')) {
    // Alipay QR
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  } else if (code.startsWith('https://u.wechat.com')) {
    // Weixin User QR
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  } else if (code.startsWith('wxp://f2f6Ot7CKDr4Ia_4L_zMFVWzkkAN9ukglcumERxAHLVlowY')) {
    // Weixin Pay
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  } else {
    // Default: URL (https://aridb.com/qr)
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      }
    }
    _isProcessing = false;
  }


Map<String, dynamic> parseSGQR(String sgqrData) {
  Map<String, dynamic> result = {};

  RegExp regExp = RegExp(r'(\d{2})(\d{2})(.+)');
  while (sgqrData.isNotEmpty) {
    final match = regExp.matchAsPrefix(sgqrData);
    if (match == null) break;

    String tag = match.group(1)!;
    int length = int.parse(match.group(2)!);
    String value = match.group(3)!.substring(0, length);

    // 存储解析结果
    result[tag] = value;

    // 截取剩余数据
    sgqrData = match.group(3)!.substring(length);
  }

    return result;
  }


  String? extractUEN(String merchantAccount) {
  RegExp regExp = RegExp(r'02(\d{2})(.+)');
  Match? match = regExp.firstMatch(merchantAccount);

  if (match != null) {
    int length = int.parse(match.group(1)!); // 获取长度
    String value = match.group(2)!.substring(0, length); // 提取值
    return value;
  }
    return null; // 未找到时返回 null
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}