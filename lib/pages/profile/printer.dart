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
  final Map<String, bool> connectingDevices = {};

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

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      connectingDevices[device.id.id] = true;
    });

    try {
      await device.connect();
      await _getBluetoothDevices(); // 刷新已连接设备列表
    } catch (e) {
      debugPrint('Error connecting to device: $e');
    } finally {
      setState(() {
        connectingDevices[device.id.id] = false;
      });
    }
  }

  Future<void> _disconnectDevice(BluetoothDevice device) async {
    try {
      await device.disconnect();
      await _getBluetoothDevices(); // 刷新已连接设备列表
    } catch (e) {
      debugPrint('Error disconnecting from device: $e');
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
            ...devices
                .where((device) => device.name.isNotEmpty)
                .map((device) => ListTile(
                      title: Text(device.name),
                      subtitle: Text(device.id.id),
                      trailing: TextButton(
                        onPressed: () => _disconnectDevice(device),
                        child: const Text('断开连接', style: TextStyle(color: Colors.red)),
                      ),
                      onTap: () {
                        // 处理已配对设备点击事件
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
            ...scanResults
                .where((result) => result.device.name.isNotEmpty)
                .map((result) => ListTile(
                      title: Text(result.device.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${result.rssi} dBm'),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: connectingDevices[result.device.id.id] == true
                                ? null
                                : () => _connectToDevice(result.device),
                            child: Text(
                              connectingDevices[result.device.id.id] == true
                                  ? '连接中...'
                                  : '连接',
                              style: TextStyle(
                                color: connectingDevices[result.device.id.id] == true
                                    ? Colors.grey
                                    : Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // 处理扫描设备点击事件
                      },
                    )),
          ],
        ],
      ),
    );
  }
} 