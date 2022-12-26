import 'package:flutter/material.dart';
import 'package:flutter_offline_app/database/dbconn.dart';
import 'package:flutter_offline_app/models/trans.dart';
import 'package:flutter_offline_app/widget/editdatawidget.dart';

class DetailWidget extends StatefulWidget {
  final Trans trans;
  const DetailWidget({Key? key, required this.trans}) : super(key: key);

  @override
  State<DetailWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  DbConn dbConn = DbConn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              width: 440,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      children: <Widget>[
                        Text('Transaction Name:',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8))),
                        Text(widget.trans.transName!,
                            style: Theme.of(context).textTheme.headline6)
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      children: <Widget>[
                        Text('Transaction Type:',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8))),
                        Text(widget.trans.transType!,
                            style: Theme.of(context).textTheme.headline6)
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      children: <Widget>[
                        Text('Amount:',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8))),
                        Text(widget.trans.amount.toString(),
                            style: Theme.of(context).textTheme.headline6)
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      children: <Widget>[
                        Text('Transaction Date:',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8))),
                        Text(widget.trans.transDate!,
                            style: Theme.of(context).textTheme.headline6)
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () {
                            _navigateToEditScreen(context, widget.trans);
                          },
                          child: const Text('Edit',
                              style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () {
                            _confirmDialog();
                          },
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _navigateToEditScreen(BuildContext context, Trans trans) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditDataWidget(
                trans: trans,
              )),
    );
  }

  Future<void> _confirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                final initDB = dbConn.initDB();
                initDB.then((db) async {
                  await dbConn.deleteTrans(widget.trans.id!);
                });

                Navigator.popUntil(
                    context, ModalRoute.withName(Navigator.defaultRouteName));
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
