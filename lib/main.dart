import 'dart:io';

import 'package:budget_check/presentation/addTransactions.dart';
import 'package:budget_check/presentation/chart.dart';

import 'package:budget_check/presentation/userTransaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'models/transactions.dart';
import 'package:flutter/material.dart';

void main() {
  // if (Platform.isAndroid)
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(const MyHome());
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoApp(debugShowCheckedModeBanner: false, home: MyHomePage())
        : MaterialApp(
            theme: ThemeData(primarySwatch: Colors.deepPurple),
            debugShowCheckedModeBanner: false,
            home: MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(),
                color: Colors.grey[100],
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            height: isLandScape(context)
                ? MediaQuery.of(context).size.height - 200
                : MediaQuery.of(context).size.height - 680,
            child:
                SingleChildScrollView(child: AddTransaction(_addTransaction)),
          ),
        );
      },
    );
  }

  void _startAddNewTransaction(BuildContext ctx) {
    Platform.isIOS
        ? _showAlertDialog(ctx)
        : showModalBottomSheet(
            context: ctx,
            builder: (_) {
              return SingleChildScrollView(
                  child: AddTransaction(_addTransaction));
            },
          );
  }

  List<Transaction> _transactions = [
    // Transaction(
    // dateTime: DateTime.now(), price: 999, title: "Shoes", id: "sadsa")
  ];
  bool _isChanged = true;
  void _addTransaction(String title, int amount, DateTime date) {
    final transactionTx = Transaction(
        dateTime: date,
        price: amount,
        title: title,
        id: DateTime.now().toString());

    setState(() {
      _transactions.add(transactionTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  List<Transaction> get recentTransaction {
    return _transactions.where((tx) {
      return tx.dateTime
          .isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  bool isLandScape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  Widget _showSwitchButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text(
        "Show Chart",
      ),
      Switch.adaptive(
          value: _isChanged,
          onChanged: (value) {
            setState(() {
              _isChanged = value;
            });
          }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (!isLandScape(context)) _isChanged = true;
    final bodyWidget = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandScape(context)) _showSwitchButton(),
          if (_isChanged)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chart(recentTransaction),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: UserTransaction(_transactions, _deleteTransaction),
          ),
        ],
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                middle: const Text("Budget Checker"),
                trailing: TextButton(
                  child: const Icon(CupertinoIcons.add),
                  onPressed: () {
                    _startAddNewTransaction(context);
                  },
                )),
            child: bodyWidget)
        : Scaffold(
            drawer: Drawer(
              child: ListView(children: [
                const DrawerHeader(
                    child: const Text(
                  "Check Your Expenses",
                  style: const TextStyle(fontSize: 25),
                ))
              ]),
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            appBar: AppBar(
              title: const Text("Budget Check"),
            ),
            body: bodyWidget,
            floatingActionButton: Platform.isIOS
                ? Container()
                : Builder(
                    builder: (context) => FloatingActionButton(
                        elevation: 20,
                        child: const Icon(Icons.add),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return AddTransaction(_addTransaction);
                              });
                        }),
                  ),
          );
  }
}
