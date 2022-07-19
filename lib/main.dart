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
  runApp(MyHome());
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
            home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddTransaction(_addTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  List<Transaction> _transactions = [];
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
      return tx.dateTime.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (!isLandScape) _isChanged = true;

    final bodyWidget = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandScape)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Show Chart",
              ),
              Switch.adaptive(
                  value: _isChanged,
                  onChanged: (value) {
                    setState(() {
                      _isChanged = value;
                    });
                  }),
            ]),
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
                middle: Text("Budget Checker"),
                trailing: TextButton(
                  child: Icon(CupertinoIcons.add),
                  onPressed: () {
                    _startAddNewTransaction(context);
                  },
                )),
            child: bodyWidget)
        : Scaffold(
            drawer: Drawer(
              child: ListView(children: [
                DrawerHeader(
                    child: Text(
                  "Check Your Expenses",
                  style: TextStyle(fontSize: 25),
                ))
              ]),
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return AddTransaction(_addTransaction);
                          });
                    },
                    icon: Icon(Icons.add))
              ],
              title: Text("Budget Check"),
            ),
            body: bodyWidget,
            floatingActionButton: Platform.isIOS
                ? Container()
                : Builder(
                    builder: (context) => FloatingActionButton(
                        elevation: 20,
                        child: Icon(Icons.add),
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
