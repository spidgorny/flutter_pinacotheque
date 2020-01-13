import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';

class ImageWithBackground extends StatelessWidget {
  String url;
  String thumbURL;
  Duration refreshDuration;

  ImageWithBackground(this.url, {this.thumbURL, this.refreshDuration});

  @override
  Widget build(BuildContext context) {
    return imageAsDoubleBackground(this.url, thumbURL: this.thumbURL);
  }

  Container imageAsBackground(String url,
      {String thumbURL, Widget child, BoxFit fit}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            url,
          ),
          fit: fit != null ? fit : BoxFit.cover,
        ),
      ),
      child: child ?? Container(),
    );
  }

  imageAsDoubleBackground(String url, {String thumbURL}) {
    return imageAsBackground(thumbURL,
        child: imageAsBackground(url, fit: BoxFit.contain));
  }

  imageAsAdvanced(String url, {String thumbURL}) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: NetworkImage(
          thumbURL,
        ),
        fit: BoxFit.cover,
      )),
      child: ZoomableWidget(
          autoCenter: true,
          minScale: 1,
          maxScale: 2.0,
          // default factor is 1.0, use 0.0 to disable boundary
          panLimit: 0.8,
          child: TransitionToImage(
            image: AdvancedNetworkImage(
              url,
              timeoutDuration: this.refreshDuration,
            ),
            placeholder: Container(), // to see the background
            duration: Duration(milliseconds: 300),
            fit: BoxFit.cover, // TODO: this is not working
          )),
    );
  }
}
