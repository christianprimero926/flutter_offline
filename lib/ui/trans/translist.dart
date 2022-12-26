import 'package:flutter/material.dart';
import 'package:flutter_offline_app/models/trans.dart';
import 'package:flutter_offline_app/widget/detailwidget.dart';

class TransList extends StatelessWidget {
  final List<Trans> trans;
  const TransList({Key? key, required this.trans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: trans.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailWidget(trans: trans[index])),
              );
            },
            child: ListTile(
              leading: trans[index].transType == 'earning'
                  ? const Icon(Icons.attach_money)
                  : const Icon(Icons.money_off),
              title: Text(trans[index].transName!),
              subtitle: Text(trans[index].amount.toString()),
            ),
          ));
        });
  }
}
