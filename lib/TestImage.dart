import 'IImage.dart';

class TestImage extends IImage {
  int id;
  String DateTime;
  double timestamp;

  TestImage(this.id, this.DateTime, this.timestamp);

  String get humanTime {
    return 'some date';
  }

  String get imageURL {
    return 'https://images.pexels.com/photos/556416/pexels-photo-556416.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940';
  }

  String get thumbURL {
    return 'https://images.pexels.com/photos/556416/pexels-photo-556416.jpeg?crop=entropy&cs=srgb&dl=brown-train-railway-near-mountain-556416.jpg&fit=crop&fm=jpg&h=422&w=640';
  }

  String get clickURL {
    return 'https://www.pexels.com/photo/brown-train-railway-near-mountain-556416/';
  }
}
