import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class PrinterPage extends StatefulWidget {
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  List<BluetoothDevice> devices = [];
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    try {
      // 监听蓝牙状态变化
      FlutterBluePlus.adapterState.listen((state) {
        if (state == BluetoothAdapterState.on) {
          _getBluetoothDevices();
        } else {
          setState(() {
            devices = [];
            scanResults = [];
          });
        }
      });

      if (await FlutterBluePlus.isOn) {
        await _getBluetoothDevices();
      }
    } catch (e) {
      debugPrint('Error initializing bluetooth: $e');
    }
  }

  Future<void> _getBluetoothDevices() async {
    try {
      final connectedDevices = await FlutterBluePlus.connectedDevices;
      setState(() {
        devices = connectedDevices;
      });
    } catch (e) {
      debugPrint('Error getting bluetooth devices: $e');
    }
  }

  Future<void> _startScan() async {
    setState(() {
      scanResults = [];
      isScanning = true;
    });

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
      
      FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          scanResults = results;
        });
      });

      await Future.delayed(const Duration(seconds: 4));
      setState(() {
        isScanning = false;
      });
    } catch (e) {
      debugPrint('Error scanning: $e');
      setState(() {
        isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('打印机'),
        actions: [
          TextButton(
            onPressed: isScanning ? null : _startScan,
            child: Text(
              isScanning ? '扫描中...' : '扫描',
              style: TextStyle(
                color: isScanning ? Colors.grey : Colors.pink,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          if (devices.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '已配对设备',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ...devices.map((device) => ListTile(
                  title: Text(device.name.isEmpty ? 'Unknown Device' : device.name),
                  subtitle: Text(device.id.id),
                  onTap: () {
                    // TODO: 处理已配对设备点击事件
                  },
                )),
          ],
          if (scanResults.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '可用设备',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ...scanResults.map((result) => ListTile(
                  title: Text(
                    result.device.name.isEmpty
                        ? 'Unknown Device'
                        : result.device.name,
                  ),
                  subtitle: Text(result.device.id.id),
                  trailing: Text('${result.rssi} dBm'),
                  onTap: () {
                    // TODO: 处理扫描设备点击事件
                  },
                )),
          ],
        ],
      ),
    );
  }
} 