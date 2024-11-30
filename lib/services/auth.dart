import 'package:local_auth/local_auth.dart';

final LocalAuthentication auth = LocalAuthentication();

Future<bool> login() async {
  try {
    // 检查是否支持生物识别
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate = await auth.isDeviceSupported();
    
    if (!canAuthenticate) {
      print('设备不支持生物识别');
      return false;
    }

    // 进行认证
    final bool didAuthenticate = await auth.authenticate(
      localizedReason: '请使用Face ID验证身份',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
    
    print(didAuthenticate ? '认证成功' : '认证失败');
    return didAuthenticate;
    
  } catch (e) {
    print('认证错误: $e');
    return false;
  }
}

Future<void> logout() async {
  try {
    // Clear any stored authentication state
    await auth.stopAuthentication();
    print('Successfully logged out');
  } catch (e) {
    print('Error during logout: $e');
  }
}

Future<void> switchAccount() async {
  try {
    // First stop any existing authentication
    await auth.stopAuthentication();
    
    // Re-authenticate with biometrics
    final bool didAuthenticate = await auth.authenticate(
      localizedReason: '请使用Face ID切换账号',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );

    if (didAuthenticate) {
      print('身份验证成功，可以切换账号');
      // Additional account switching logic would go here
    } else {
      print('身份验证失败，无法切换账号');
    }
  } catch (e) {
    print('切换账号时出错: $e');
  }
}

