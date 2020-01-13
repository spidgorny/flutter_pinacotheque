import 'IImage.dart';

abstract class IImageProvider {
  Future<IImage> getRandomPic();
}
