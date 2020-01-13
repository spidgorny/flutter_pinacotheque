abstract class IImage {
  String baseURL;

  void setBaseURL(String url) {
    this.baseURL = url;
  }

  String get humanTime {}

  String get imageURL {}

  String get thumbURL {}

  String get clickURL {}
}
