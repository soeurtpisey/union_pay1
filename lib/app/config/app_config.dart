/// ////////////////////////////////////////////
/// @author: mac
/// @Date: 2022/11/8 09:47
/// @Description: 环境配置
/// /////////////////////////////////////////////
class EnvConfig {
  final String appTitle;
  final String apiUrl;

  EnvConfig({required this.appTitle, required this.apiUrl});
}

// 声明的环境
abstract class EnvName {
  // 环境key
  static const String envKey = 'DART_DEFINE_APP_ENV';

  // 环境value
  static const String prod = 'prod';
  static const String uat = 'uat';
  static const String dev = 'dev';
}

// 获取的配置信息
class Env {
  // 获取到当前环境
  static const appEnv = String.fromEnvironment(EnvName.envKey);

  // 发布环境
  static final EnvConfig _prodConfig = EnvConfig(
    appTitle: 'Union Pay',
    apiUrl: 'https://dev-api.ipagrato.com/',
  );

  // UAT环境
  static final EnvConfig _uatConfig = EnvConfig(
    appTitle: 'Union Pay Uat',
    apiUrl: 'https://dev-api.ipagrato.com/',
  );

  // dev环境
  static final EnvConfig _devConfig = EnvConfig(
    appTitle: 'Union Pay Dev',
    apiUrl: 'https://dev-api.ipagrato.com/',
  );

  static String get apiUrl => Env.envConfig.apiUrl;

  static EnvConfig get envConfig => _getEnvConfig();

// 根据不同环境返回对应的环境配置,原生打包时请注意，需要强制根据当前打包的注释环境代码,暂时没找到解决方案
  static EnvConfig _getEnvConfig() {
    // switch (appEnv) {
    //   case EnvName.prod:
    //     return _prodConfig;
    //   case EnvName.uat:
    //     return _uatConfig;
    //   case EnvName.dev:
    //     return _devConfig;
    //   default:
    //     return _devConfig;
    // }

    //flutter build apk --dart-define=DART_DEFINE_APP_ENV=dev --flavor dev --release -t lib/main.dart
    //flutter build apk --dart-define=DART_DEFINE_APP_ENV=uat --flavor uat --release -t lib/main.dart
    //flutter build apk --dart-define=DART_DEFINE_APP_ENV=prod --flavor prod --release -t lib/main.dart

    // 打包专用，需要强制根据当前打包的注释环境代码,暂时没找到解决方案
    return _devConfig;
    // return _uatConfig;
    // return _prodConfig;
  }
}
