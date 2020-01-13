import 'package:sqljocky5/exceptions/exceptions.dart';
import 'package:sqljocky5/sqljocky.dart' as sql;

import 'IImageProvider.dart';
import 'MyImage.dart';

class MyImageProvider implements IImageProvider {
  sql.MySqlConnection db;

  MyImageProvider() {
    this.connectToDB();
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

  Future<MyImage> getRandomPic() async {
    try {
      var results = await this.db.prepared(
          "select * from files where type = 'file' order by rand() limit 1",
          []);
      await for (var row in results) {
        // Access columns by index
        print('Row: $row');
        // Access columns by name
        //      print('Name: ${row.id}, email: ${row.path}');
        return new MyImage(
            row.byName('id'), row.byName('DateTime'), row.byName('timestamp'));
      }
    } catch (e) {
      if (e is MySqlClientError) {
        print(e);
        await this.connectToDB();
      }
    }
    return this.getRandomPic();
  }
}
