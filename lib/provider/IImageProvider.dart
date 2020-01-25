import '../image/IImage.dart';

abstract class IImageProvider {
  Future<IImage> getRandomPic();
}
