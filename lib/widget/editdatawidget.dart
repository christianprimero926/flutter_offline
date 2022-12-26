import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline_app/database/dbconn.dart';
import 'package:flutter_offline_app/models/trans.dart';

enum TransType { earning, expense }

class EditDataWidget extends StatefulWidget {
  final Trans trans;
  const EditDataWidget({Key? key, required this.trans}) : super(key: key);

  @override
  State<EditDataWidget> createState() => _EditDataWidgetState();
}

class _EditDataWidgetState extends State<EditDataWidget> {
  DbConn dbconn = DbConn();
  int? _id;
  final _addFormKey = GlobalKey<FormState>();
  final format = DateFormat("dd-MM-yyyy");
  final _transDateController = TextEditingController();
  final _transNameController = TextEditingController();
  String transType = '';
  final _amountController = TextEditingController();
  TransType _transType = TransType.earning;

  @override
  void initState() {
    _id = widget.trans.id;
    _transDateController.text = widget.trans.transDate!;
    _transNameController.text = widget.trans.transName!;
    _amountController.text = widget.trans.amount.toString();
    transType = widget.trans.transType!;
    if (widget.trans.transType == 'earning') {
      _transType = TransType.earning;
    } else {
      _transType = TransType.expense;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Data'),
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
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
                          const Text('Transaction Date'),
                          DateTimeField(
                            format: format,
                            controller: _transDateController,
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  initialDate: DateTime(1900),
                                  firstDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                            },
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        children: <Widget>[
                          const Text('Transaction Name'),
                          TextFormField(
                            controller: _transNameController,
                            decoration: const InputDecoration(
                              hintText: 'Transaction Name',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter transaction name';
                              }
                              return null;
                            },
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        children: <Widget>[
                          const Text('Transaction Type'),
                          ListTile(
                            title: const Text('Earning'),
                            leading: Radio(
                              value: TransType.earning,
                              groupValue: _transType,
                              onChanged: (TransType? value) {
                                setState(() {
                                  _transType = value!;
                                  transType = 'earning';
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Expense'),
                            leading: Radio(
                              value: TransType.expense,
                              groupValue: _transType,
                              onChanged: (TransType? value) {
                                setState(() {
                                  _transType = value!;
                                  transType = 'expense';
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        children: <Widget>[
                          const Text('Amount'),
                          TextFormField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              hintText: 'Amount',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter amount';
                              }
                              return null;
                            },
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                if (_addFormKey.currentState!.validate()) {
                                  _addFormKey.currentState?.save();
                                  final initDB = dbconn.initDB();
                                  initDB.then((db) async {
                                    dbconn.insertTrans(Trans(
                                      id: _id,
                                      transDate: _transDateController.text,
                                      transName: _transNameController.text,
                                      transType: transType,
                                      amount: int.parse(_amountController.text),
                                    ));
                                  });
                                  Navigator.popUntil(
                                      context,
                                      ModalRoute.withName(
                                          Navigator.defaultRouteName));
                                }
                              },
                              child: const Text('Update',
                                  style: TextStyle(color: Colors.white)))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
