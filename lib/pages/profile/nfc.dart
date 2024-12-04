import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCPage extends StatelessWidget {
  const NFCPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Tools'),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: 实现设置功能
            },
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              // TODO: 实现暗黑模式切换
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'Welcome to NFC Tools',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildActionButton(
                  icon: Icons.search,
                  label: 'Read',
                  color: Colors.orange,
                  onTap: () async {
                    bool isAvailable = await NfcManager.instance.isAvailable();
                    if (!isAvailable) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('NFC not available')),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('NFC Reader'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Please hold your NFC card near the device...'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                NfcManager.instance.stopSession();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );

                    // 开始 NFC 会话
                    NfcManager.instance.startSession(
                      onDiscovered: (NfcTag tag) async {
                        try {
                          // 添加调试信息
                          debugPrint('NFC Tag discovered: ${tag.data}');
                          
                          var ndef = Ndef.from(tag);
                          String tagContent = '';
                          
                          if (ndef == null) {
                            // 尝试读取原始数据
                            tagContent = 'Raw tag data:\n${tag.data}';
                          } else {
                            debugPrint('NDEF is supported');
                            
                            var ndefMessage = await ndef.read();
                            if (ndefMessage != null) {
                              debugPrint('Records found: ${ndefMessage.records.length}');
                              
                              for (var record in ndefMessage.records) {
                                // 打印记录类型和载荷信息
                                debugPrint('Record type: ${record.typeNameFormat}');
                                debugPrint('Payload length: ${record.payload.length}');
                                
                                // 尝试不同的解码方式
                                try {
                                  // 跳过 NDEF 头部的语言代码（如果存在）
                                  var payload = record.payload;
                                  if (payload.isNotEmpty && payload[0] == 0x02) {
                                    // Text record with UTF8 encoding
                                    payload = payload.sublist(1 + payload[1]);
                                  }
                                  
                                  tagContent += 'Content: ${String.fromCharCodes(payload)}\n';
                                  tagContent += 'Hex: ${payload.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}\n\n';
                                } catch (e) {
                                  tagContent += 'Raw payload: ${record.payload}\n';
                                }
                              }
                            } else {
                              tagContent = 'No NDEF message found. Raw data:\n${tag.data}';
                            }
                          }

                          Navigator.of(context).pop(); // 关闭进度对话框
                          
                          // 显示读取结果
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Tag Content'),
                              content: SingleChildScrollView(
                                child: Text(tagContent),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } catch (e, stackTrace) {
                          debugPrint('Error reading NFC: $e');
                          debugPrint('Stack trace: $stackTrace');
                          
                          Navigator.of(context).pop(); // 关闭进度对话框
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error reading NFC: $e')),
                          );
                        } finally {
                          NfcManager.instance.stopSession();
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Write',
                  color: Colors.orange,
                  onTap: () {
                    // TODO: 实现写入功能
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.build,
                  label: 'Other',
                  color: Colors.orange,
                  onTap: () {
                    // TODO: 实现其他功能
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.bookmark,
                  label: 'My saved tags',
                  color: Colors.orange,
                  onTap: () {
                    // TODO: 实现已保存标签功能
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 