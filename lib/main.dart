// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_offline_app/database/dbconn.dart';
import 'package:flutter_offline_app/models/trans.dart';
import 'package:flutter_offline_app/ui/trans/translist.dart';
import 'package:flutter_offline_app/widget/adddatawidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transactions',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Transactions Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbConn dbConn = DbConn();
  var transList = <Trans>[];
  // List<Trans> transList = List<Trans>();
  int totalCount = 0;

  @override
  Widget build(BuildContext context) {
    // if(transList == null){
    //   transList = List<Trans>();
    // }
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return OfflineBuilder(
            connectivityBuilder: (BuildContext context,
                ConnectivityResult connectivity, Widget child) {
              final bool connected = connectivity != ConnectivityResult.none;
              return Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    height: 32.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: connected ? null : Colors.red,
                      child: connected
                          ? null
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  "Offline",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                SizedBox(
                                  width: 12.0,
                                  height: 12.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )
                ],
              );
            },
            child: Center(
                child: FutureBuilder(
              future: loadList(),
              builder: (context, snapshot) {
                return transList.isNotEmpty
                    ? TransList(trans: transList)
                    : new Center(
                        child: new Text(
                            'No data found, tap plus button to add!',
                            style: Theme.of(context).textTheme.headline6));
              },
            )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddScreen(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.cyanAccent,
        child: FutureBuilder(
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Total: $totalCount',
                  style: Theme.of(context).textTheme.headline6),
            );
          },
        ),
      ),
    );
  }

  Future loadList() {
    final Future futureDB = dbConn.initDB();
    return futureDB.then((db) {
      Future<List<Trans>> futureTrans = dbConn.trans();
      futureTrans.then((transList) {
        setState(() {
          this.transList = transList;
        });
      });
    });
  }

  Future loadTotal() {
    final Future futureDB = dbConn.initDB();
    return futureDB.then((db) {
      Future<int> futureTotal = dbConn.countTotal();
      futureTotal.then((ft) {
        setState(() {
          totalCount = ft;
        });
      });
    });
  }

  _navigateToAddScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDataWidget()),
    );
  }
}
