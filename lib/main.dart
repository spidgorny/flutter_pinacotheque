import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqljocky5/sqljocky.dart' as sql;
import 'package:url_launcher/url_launcher.dart';

import 'IImage.dart';
import 'IImageProvider.dart';
import 'ImageWithBackground.dart';
import 'TestImageProvider.dart';

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
  sql.MySqlConnection db;
  Timer _timer;
  String baseURL = 'http://192.168.1.109:81/';
  Duration refreshDuration = Duration(seconds: 15);
//  IImageProvider provider = new MyImageProvider();
  IImageProvider provider = new TestImageProvider();
  IImage image;

  @override
  void initState() {
    super.initState();
    this.initAsyncState();
  }

  void initAsyncState() async {
    this.getRandomPic();
    _timer = new Timer.periodic(
        this.refreshDuration, (Timer timer) => this.getRandomPic());
  }

  void getRandomPic() async {
    var image = await this.provider.getRandomPic();
    setState(() {
      this.image = image;
      this.image.setBaseURL(this.baseURL);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 1,
        title: Text(this.image != null ? this.image.humanTime : 'Loading...'),
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
