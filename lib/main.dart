import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ImageWithBackground.dart';
import 'image/IImage.dart';
import 'provider/HttpImageProvider.dart';
import 'provider/IImageProvider.dart';
import 'provider/TestImageProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
//    SystemChrome.restoreSystemUIOverlays();
    return MaterialApp(
      title: 'Pinacotheque',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
//      showPerformanceOverlay: true,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  sql.MySqlConnection db;
  Timer _timer;
  Timer _timerTillRefresh;
  String baseURL = 'http://192.168.1.120/';
  Duration refreshDuration = Duration(seconds: 15);
//  IImageProvider provider = new MyImageProvider();
  IImageProvider provider;
  IImage image;

  @override
  void initState() {
    super.initState();
    this.initAsyncState();
  }

  void initAsyncState() async {
    this.provider = await this.getImageProvider();
    this.getRandomPic();
    this.restartTimer();
  }

  void restartTimer() {
    _timer = new Timer.periodic(
        this.refreshDuration, (Timer timer) => this.getRandomPic());
  }

  Future<IImageProvider> getImageProvider() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.wifi) {
//      return new MyImageProvider();
      return new HttpImageProvider(baseURL);
    }
    return new TestImageProvider();
  }

  void getRandomPic() async {
    var image = await this.provider.getRandomPic();
    setState(() {
      this.image = image;
      this.image.setBaseURL(this.baseURL);
      _timerTillRefresh = new Timer.periodic(
          Duration(milliseconds: 100), (Timer timer) => this.setState(() {}));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(['_timerTillRefresh.tick', _timerTillRefresh.tick]);
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 1,
        title: Text(this.image != null ? this.image.humanTime : 'Loading...'),
        actions: <Widget>[
          _timerTillRefresh != null
              ? GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: _timer.isActive
                          ? CircularProgressIndicator(
                              value: _timerTillRefresh.tick / 150,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Icon(
                              Icons.play_arrow,
                              size: 48,
                            ),
                    ),
                  ),
                  onTap: () {
                    if (_timer.isActive) {
                      _timer.cancel();
                      _timerTillRefresh.cancel();
                    } else {
                      this.restartTimer();
                      this.getRandomPic();
                    }
                  },
                )
              : Container(),
        ],
      ),
      body: Center(
        child: this.image != null
            ? GestureDetector(
                child: ImageWithBackground(
                  this.image.imageURL,
                  thumbURL: image.thumbURL,
                ),
                onTap: () {
                  launch(this.image.clickURL);
                },
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: this.getRandomPic,
        tooltip: 'Next Image',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
