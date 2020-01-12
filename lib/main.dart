import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:sqljocky5/exceptions/exceptions.dart';
import 'package:sqljocky5/sqljocky.dart' as sql;
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
//    SystemChrome.restoreSystemUIOverlays();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
//      showPerformanceOverlay: true,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  sql.MySqlConnection db;
  Timer _timer;
  String baseURL = 'http://192.168.1.109:81/';
  sql.Row row;
  Duration refreshDuration = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    this.initAsyncState();
  }

  void initAsyncState() async {
    await this.connectToDB();
    this.getRandomPic();
    _timer = new Timer.periodic(
        this.refreshDuration, (Timer timer) => this.getRandomPic());
  }

  Future connectToDB() async {
    print('Reconnect...');
    var settings = new sql.ConnectionSettings(
        host: '192.168.1.109',
        port: 3306,
        user: 'slawa',
        password: '123',
        db: 'pina');
    this.db = await sql.MySqlConnection.connect(settings);
    print('Connected.');
  }

  void getRandomPic() async {
    try {
      var results = await this.db.prepared(
          "select * from files where type = 'file' order by rand() limit 1",
          []);
      results.forEach((sql.Row row) {
        // Access columns by index
        print('Row: ${row}');
        // Access columns by name
        //      print('Name: ${row.id}, email: ${row.path}');
        setState(() {
          this.row = row;
        });
      });
    } catch (e) {
      if (e is MySqlClientError) {
        print(e);
        await this.connectToDB();
        this.getRandomPic();
      }
    }
  }

  int get file {
    return this.row.byName('id');
  }

  DateTime get dateTime {
    String sDateTime = this.row.byName('DateTime');
    print(sDateTime);
    double dTimestamp = this.row.byName('timestamp');

    DateTime dateTime;
    if (sDateTime != null) {
      try {
        var parts = sDateTime.split(' ');
        String date = parts[0];
        String time = parts[1];
        date = date.replaceAll(':', '-');
        dateTime = DateTime.parse(date + ' ' + time);
      } catch (e) {
        dateTime = new DateTime.fromMillisecondsSinceEpoch(dTimestamp.floor());
      }
    } else {
      dateTime = new DateTime.fromMillisecondsSinceEpoch(dTimestamp.floor());
    }
    print(dateTime);
    return dateTime;
  }

  int get year {
    var dateTime = this.dateTime;
    return dateTime.year;
  }

  int get month {
    var dateTime = this.dateTime;
    return dateTime.month;
  }

  void _incrementCounter() {
    this.getRandomPic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 1,
        title: Text(this.row != null
            ? this.dateTime.toIso8601String().replaceAll('T', ' ')
            : 'Loading...'),
      ),
      body: Center(
        child: this.row != null
            ? GestureDetector(
                child: imageAsDoubleBackground(
                  this.baseURL + 'ShowOriginal?file=${this.file}',
                  thumbURL: this.baseURL + 'ShowThumb?file=${this.file}',
                ),
                onTap: () {
                  launch(baseURL +
                      'Preview?source=0&year=${this.year}&month=${this.month}&file=${this.file}');
                },
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
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
