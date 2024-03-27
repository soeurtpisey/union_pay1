import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wecloudchatkit_flutter_example/http/api.dart';
import 'package:wecloudchatkit_flutter_example/http/net/dio_new.dart';

class DioClientController extends GetxService {
  Future<HttpClient> init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String cookiesPath = join(appDocDir.path, ".cookies/");
    HttpConfig dioConfig = HttpConfig(
        baseUrl: Api.BaseUrl,
        // proxy: "192.168.1.150:8866",
        cookiesPath: cookiesPath
    );
    HttpClient client = HttpClient(dioConfig: dioConfig);
    return client;
  }
}
