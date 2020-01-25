import '../image/TestImage.dart';
import 'IImageProvider.dart';

class TestImageProvider implements IImageProvider {
  Future<TestImage> getRandomPic() async =>
      Future.value(TestImage(1, '2020:01:12 18:30:31', 1578917666.0));
}
