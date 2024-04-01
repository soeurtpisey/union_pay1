import '../../app/base/base_response.dart';
import 'dio_new.dart';

class DefaultHttpTransformer extends HttpTransformer {
  @override
  HttpResponse parse(Response response) {
    ResponseData res = ResponseData.fromJson(response.data);
    if (res.status?.toUpperCase() == 'OK') {
      return HttpResponse.success(res.data);
    } else {
      return HttpResponse.failure(errorMsg: res.message, errorCode: res.status);
    }
  }

  /// 单例对象
  static final DefaultHttpTransformer _instance =
      DefaultHttpTransformer._internal();

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  DefaultHttpTransformer._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory DefaultHttpTransformer.getInstance() => _instance;
}
