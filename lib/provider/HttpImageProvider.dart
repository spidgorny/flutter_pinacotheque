import 'package:dio/dio.dart';
import 'package:flutter_pinacotheque/image/HttpImage.dart';

import 'IImageProvider.dart';

class HttpImageProvider implements IImageProvider {
  final baseUrl;

  HttpImageProvider(this.baseUrl);

  Future<HttpImage> getRandomPic() async {
    Response response = await Dio().get(baseUrl + 'RandomPic');
    print(['dio', response]);
    return HttpImage.fromJson(response.data);
  }
}
